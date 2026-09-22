--- Single active review session plus change notification.
local M = {}

---@class JjGhReviewComment
---@field id string            GraphQL node id, or "local:..." until synced
---@field database_id integer|nil
---@field body string
---@field author string
---@field created_at string|nil
---@field updated_at string|nil
---@field url string|nil
---@field pending boolean      part of an unsubmitted review on GitHub
---@field mine boolean
---@field syncing boolean|nil  created/edited locally, not yet on GitHub
---@field review_id string|nil

---@class JjGhReviewThread
---@field id string            GraphQL node id, or "local:..." until synced
---@field path string          repo-relative path
---@field line integer|nil     last line of the range (nil when outdated)
---@field start_line integer|nil
---@field original_line integer|nil
---@field original_start_line integer|nil
---@field side "LEFT"|"RIGHT"
---@field start_side "LEFT"|"RIGHT"|nil
---@field resolved boolean
---@field outdated boolean
---@field comments JjGhReviewComment[]
---@field syncing boolean|nil  a local change to the thread itself is queued

---@class JjGhReviewPr: JjGhReviewPrRef
---@field id string GraphQL node id
---@field title string
---@field url string
---@field state string
---@field isDraft boolean
---@field author {login: string}|nil
---@field headRefName string
---@field headRefOid string
---@field baseRefName string
---@field baseRefOid string
---@field isCrossRepository boolean

---@class JjGhReviewOp
---@field kind "add_thread"|"reply"|"edit"|"delete"|"resolve"|"submit"
---@field queued_at string|nil
---@field error string|nil
---@field attempts integer|nil
---@field local_id string|nil
---@field thread_id string|nil
---@field comment_id string|nil
---@field path string|nil
---@field body string|nil
---@field line integer|nil
---@field start_line integer|nil
---@field side "LEFT"|"RIGHT"|nil
---@field start_side "LEFT"|"RIGHT"|nil
---@field resolved boolean|nil
---@field event string|nil

---@alias JjGhReviewPhase "resolving"|"cached"|"preparing"|"fetching"|"syncing"|"ready"|"error"

---@class JjGhReviewSession
---@field spec string
---@field repo JjGhReviewRepo
---@field pr JjGhReviewPr|nil
---@field threads JjGhReviewThread[]
---@field pending_review_id string|nil
---@field queue JjGhReviewOp[]
---@field id_map table<string, string>  local id -> GitHub id, filled as ops sync
---@field phase JjGhReviewPhase
---@field detail string|nil
---@field error string|nil
---@field viewer string|nil
---@field fetched_at string|nil
---@field from_cache boolean
---@field prepared_head string|nil
---@field diffview_opened boolean|nil

---@type JjGhReviewSession|nil
M.session = nil

--- Bumped on every change; buffers compare against it to know when to re-render.
---@type integer
M.generation = 0

---@param spec string
---@param repo JjGhReviewRepo
---@return JjGhReviewSession
function M.new_session(spec, repo)
	---@type JjGhReviewSession
	local session = {
		spec = spec,
		repo = repo,
		pr = nil,
		threads = {},
		pending_review_id = nil,
		queue = {},
		id_map = {},
		phase = "resolving",
		detail = nil,
		error = nil,
		viewer = nil,
		fetched_at = nil,
		from_cache = false,
	}
	M.session = session
	M.changed()
	return session
end

--- Drop the active session.
function M.clear()
	M.session = nil
	M.changed()
end

---@param phase JjGhReviewPhase
---@param detail string|nil
function M.set_phase(phase, detail)
	local session = M.session
	if not session then
		return
	end
	session.phase = phase
	session.detail = detail
	if phase ~= "error" then
		session.error = nil
	end
	M.changed()
end

---@param message string
function M.set_error(message)
	local session = M.session
	if not session then
		return
	end
	session.phase = "error"
	session.error = message
	M.changed()
end

--- Notify listeners (marks, statusline) that something changed.
function M.changed()
	M.generation = M.generation + 1
	vim.schedule(function()
		pcall(vim.api.nvim_exec_autocmds, "User", { pattern = "JjGhReviewChanged", modeline = false })
		local lualine = package.loaded["lualine"]
		if type(lualine) == "table" and type(lualine.refresh) == "function" then
			pcall(lualine.refresh, { place = { "statusline" } })
		else
			vim.cmd.redrawstatus()
		end
	end)
end

--- Is `session` still the active one? (Async callbacks use this to bail out.)
---@param session JjGhReviewSession
---@return boolean
function M.is_active(session)
	return M.session == session
end

--- Resolve a possibly-local id to the GitHub id (if known yet).
---@param id string|nil
---@return string|nil
function M.resolve_id(id)
	local session = M.session
	if not session or not id then
		return id
	end
	return session.id_map[id] or id
end

---@param id string|nil
---@return JjGhReviewThread|nil thread
---@return integer|nil index
function M.find_thread(id)
	local session = M.session
	if not session or not id then
		return nil
	end
	local resolved = M.resolve_id(id)
	for index, thread in ipairs(session.threads) do
		if thread.id == resolved or session.id_map[thread.id] == resolved then
			return thread, index
		end
	end
	return nil
end

---@param comment_id string|nil
---@return JjGhReviewComment|nil comment
---@return JjGhReviewThread|nil thread
---@return integer|nil index
function M.find_comment(comment_id)
	local session = M.session
	if not session or not comment_id then
		return nil
	end
	local resolved = M.resolve_id(comment_id)
	for _, thread in ipairs(session.threads) do
		for index, comment in ipairs(thread.comments) do
			if comment.id == resolved or session.id_map[comment.id] == resolved then
				return comment, thread, index
			end
		end
	end
	return nil
end

---@class JjGhReviewCounts
---@field threads integer
---@field unresolved integer
---@field pending integer comments in the viewer's unsubmitted review
---@field queued integer local operations not yet pushed
---@field syncing integer comments with local changes not yet pushed

---@return JjGhReviewCounts
function M.counts()
	local session = M.session
	local counts = { threads = 0, unresolved = 0, pending = 0, queued = 0, syncing = 0 }
	if not session then
		return counts
	end
	for _, thread in ipairs(session.threads) do
		counts.threads = counts.threads + 1
		if not thread.resolved then
			counts.unresolved = counts.unresolved + 1
		end
		for _, comment in ipairs(thread.comments) do
			if comment.pending then
				counts.pending = counts.pending + 1
			end
			if comment.syncing then
				counts.syncing = counts.syncing + 1
			end
		end
	end
	counts.queued = #session.queue
	return counts
end

return M
