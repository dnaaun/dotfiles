--- jj-gh-review.nvim: GitHub PR review comments as ghost text, edited in
--- floating buffers, for jj repos (no plain `git` needed). Public API only:
--- bind these functions to your own mappings.
local cache = require("jj_gh_review.cache")
local config = require("jj_gh_review.config")
local gh = require("jj_gh_review.gh")
local jj = require("jj_gh_review.jj")
local marks = require("jj_gh_review.marks")
local repo_mod = require("jj_gh_review.repo")
local state = require("jj_gh_review.state")
local sync = require("jj_gh_review.sync")
local ui = require("jj_gh_review.ui")
local util = require("jj_gh_review.util")

local M = {}

--- Configure the plugin (all keys optional, see `config.lua` for defaults).
M.setup = config.setup

------------------------------------------------------------------------------
-- Fetching
------------------------------------------------------------------------------

---@param session JjGhReviewSession
---@param callback? fun(err: string|nil)
local function fetch_threads(session, callback)
	local pr = session.pr
	if not pr then
		return
	end
	state.set_phase("fetching", "comments")
	gh.fetch_threads(session.repo, pr, function(result, err)
		if not state.is_active(session) then
			return
		end
		if err or not result then
			local message = err or "empty response"
			state.set_error(message)
			util.notify(message, vim.log.levels.ERROR)
			if callback then
				callback(message)
			end
			return
		end
		sync.merge_remote(session, result.threads)
		session.pending_review_id = result.pending_review_id
		session.fetched_at = util.now_iso()
		session.from_cache = false
		if result.head_oid and pr.headRefOid ~= result.head_oid then
			pr.headRefOid = result.head_oid
		end
		cache.save_pr(session)
		state.set_phase("ready", nil)
		ui.refresh()
		if callback then
			callback(nil)
		end
	end)
end

---@param session JjGhReviewSession
local function load_viewer(session)
	session.viewer = cache.load_viewer(session.repo)
	if session.viewer then
		return
	end
	gh.viewer(session.repo, function(login)
		if login and state.is_active(session) then
			session.viewer = login
			cache.save_viewer(session.repo, login)
		end
	end)
end

---@param session JjGhReviewSession
local function resolve_pr(session)
	state.set_phase("resolving", session.spec)
	gh.pr_view(session.repo, session.spec, function(pr, err)
		if not state.is_active(session) then
			return
		end
		if err or not pr then
			local message = err or "empty response"
			state.set_error(message)
			if session.pr then
				-- Offline with a cached PR: keep going with what we have.
				util.notify("Using cached PR data: " .. message, vim.log.levels.WARN)
				jj.prepare(session, function()
					sync.process()
				end)
			else
				util.notify(message, vim.log.levels.ERROR)
			end
			return
		end
		local previous = session.pr
		session.pr = pr
		cache.remember_spec(session.repo, session.spec, pr)
		if previous and previous.number ~= pr.number then
			-- The specifier now points at a different PR than what we cached.
			session.threads = {}
			session.queue = cache.load_queue(pr)
			session.id_map = {}
		end
		cache.save_pr(session)
		state.changed()
		jj.prepare(session, function()
			fetch_threads(session, function()
				sync.process()
			end)
		end)
	end)
end

--- Start (or restart) reviewing the PR that `spec` names. `spec` is anything
--- `gh pr view` accepts: number, URL, branch name; empty for the current branch.
---@param spec? string
function M.open(spec)
	local clean_spec = util.trim(spec or "")
	ui.close()
	repo_mod.resolve(vim.fn.getcwd(), function(repo, err)
		if err or not repo then
			util.notify(err or "could not resolve jj repo", vim.log.levels.ERROR)
			return
		end
		local session = state.new_session(clean_spec, repo)
		marks.attach()
		--- After a successful sync, pull the authoritative state.
		sync.on_drained = function()
			if state.is_active(session) then
				fetch_threads(session)
			end
		end
		load_viewer(session)

		-- Offline first: show whatever we knew about this specifier right away.
		local ref = cache.lookup_spec(repo, clean_spec)
		local cached = ref and cache.load_pr(ref) or nil
		if cached and cached.pr then
			session.pr = cached.pr
			session.threads = cached.threads or {}
			session.pending_review_id = cached.pending_review_id
			session.fetched_at = cached.fetched_at
			session.from_cache = true
			session.queue = cache.load_queue(cached.pr)
			state.set_phase("cached", nil)
			marks.render_all(true)
		end
		resolve_pr(session)
	end)
end

--- Re-fetch comments from GitHub.
function M.refresh()
	local session = state.session
	if not session or not session.pr then
		util.notify("No active review", vim.log.levels.WARN)
		return
	end
	fetch_threads(session)
end

--- Push locally queued changes now (also resets retry backoff).
function M.sync()
	if not state.session then
		util.notify("No active review", vim.log.levels.WARN)
		return
	end
	sync.sync()
end

--- Drop queued operations that failed to sync.
function M.drop_failed()
	local dropped = sync.drop_failed()
	util.notify(string.format("Dropped %d failed operation(s)", dropped))
end

--- End the review session and remove all ghost text.
function M.close()
	ui.close()
	marks.clear_all()
	state.clear()
end

------------------------------------------------------------------------------
-- Cursor-relative actions
------------------------------------------------------------------------------

---@return JjGhReviewSession|nil
local function require_session()
	local session = state.session
	if not session then
		util.notify("No active review; run :Review <pr>", vim.log.levels.WARN)
		return nil
	end
	return session
end

--- Threads anchored at the cursor line of the current buffer (or the thread
--- shown in the current float).
---@return JjGhReviewThread[]
local function threads_here()
	local buf = vim.api.nvim_get_current_buf()
	local meta = vim.b[buf].jj_gh_review
	if type(meta) == "table" and meta.kind == "thread" then
		local thread = state.find_thread(meta.thread_id)
		return thread and { thread } or {}
	end
	local cursor = vim.api.nvim_win_get_cursor(0)
	return marks.threads_at(buf, cursor[1] or 1)
end

--- Open the thread(s) on the cursor line in a floating window.
function M.view()
	if not require_session() then
		return
	end
	local threads = threads_here()
	if #threads == 0 then
		util.notify("No comments on this line", vim.log.levels.INFO)
		return
	end
	ui.pick_thread(threads, ui.open_thread)
end

--- Line range of the active visual selection (and leave visual mode), or nil.
---@return integer|nil first
---@return integer|nil last
local function visual_range()
	local mode = vim.fn.mode()
	if not mode:match("^[vV\22]") then
		return nil, nil
	end
	local a, b = vim.fn.line("v"), vim.fn.line(".")
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
	return math.min(a, b), math.max(a, b)
end

--- Start a new comment on the cursor line, or on the visual selection.
--- `opts.line1`/`opts.line2` may be passed explicitly (e.g. from a range command).
---@param opts? {line1?: integer, line2?: integer}
function M.comment(opts)
	if not require_session() then
		return
	end
	opts = opts or {}
	local buf = vim.api.nvim_get_current_buf()
	local target = marks.buffer_target(buf)
	if not target then
		util.notify("This buffer is not a file in the reviewed jj workspace", vim.log.levels.WARN)
		return
	end
	local first, last = opts.line1, opts.line2
	if not first then
		first, last = visual_range()
	end
	if not first then
		first = vim.api.nvim_win_get_cursor(0)[1] or 1
	end
	ui.open_new({
		path = target.path,
		side = target.side,
		start_side = target.side,
		start_line = first,
		line = last or first,
	})
end

--- Jump to the next/previous commented line in the current buffer (wraps).
---@param direction 1|-1
local function jump(direction)
	if not require_session() then
		return
	end
	local buf = vim.api.nvim_get_current_buf()
	local threads = marks.threads_for_buffer(buf)
	if #threads == 0 then
		util.notify("No comments in this buffer", vim.log.levels.INFO)
		return
	end
	local current = vim.api.nvim_win_get_cursor(0)[1]
	---@type integer[]
	local lines = {}
	---@type table<integer, boolean>
	local seen = {}
	for _, thread in ipairs(threads) do
		local lnum = marks.anchor_line(thread)
		if lnum and not seen[lnum] then
			seen[lnum] = true
			table.insert(lines, lnum)
		end
	end
	---@type integer|nil
	local target
	if direction > 0 then
		for _, lnum in ipairs(lines) do
			if lnum > current then
				target = lnum
				break
			end
		end
		target = target or lines[1]
	else
		for index = #lines, 1, -1 do
			if lines[index] < current then
				target = lines[index]
				break
			end
		end
		target = target or lines[#lines]
	end
	if target then
		vim.api.nvim_win_set_cursor(0, { math.min(target, vim.api.nvim_buf_line_count(buf)), 0 })
	end
end

--- Jump to the next commented line.
function M.next()
	jump(1)
end

--- Jump to the previous commented line.
function M.prev()
	jump(-1)
end

--- Toggle resolved on the thread at the cursor (or in the open float).
function M.toggle_resolved()
	if not require_session() then
		return
	end
	local threads = threads_here()
	if #threads == 0 then
		util.notify("No thread here", vim.log.levels.INFO)
		return
	end
	ui.pick_thread(threads, function(thread)
		sync.set_resolved(thread, not thread.resolved)
		ui.refresh()
		marks.render_all(true)
	end)
end

--- Delete your comment under the cursor in a thread float (or the first own
--- comment of the thread on the cursor line).
function M.delete_comment()
	if not require_session() then
		return
	end
	local comment = ui.comment_at_cursor()
	if not comment then
		for _, thread in ipairs(threads_here()) do
			for _, candidate in ipairs(thread.comments) do
				if candidate.mine then
					comment = comment or candidate
				end
			end
		end
	end
	if not comment then
		util.notify("No comment of yours here", vim.log.levels.INFO)
		return
	end
	if not comment.mine then
		util.notify("You can only delete your own comments", vim.log.levels.WARN)
		return
	end
	local chosen = comment
	vim.ui.select({ "Delete", "Cancel" }, {
		prompt = "Delete comment: " .. util.truncate(util.first_line(chosen.body), 50),
	}, function(choice)
		if choice ~= "Delete" then
			return
		end
		sync.delete(chosen)
		local meta = vim.b[vim.api.nvim_get_current_buf()].jj_gh_review
		if type(meta) == "table" and not state.find_thread(meta.thread_id) then
			ui.close()
		else
			ui.refresh()
		end
		marks.render_all(true)
	end)
end

--- Open the thread at the cursor (or the PR) on GitHub.
function M.open_in_browser()
	local session = require_session()
	if not session then
		return
	end
	local threads = threads_here()
	local first = threads[1] and threads[1].comments[1] or nil
	local url = first and first.url or (session.pr and session.pr.url) or nil
	if not url then
		util.notify("Nothing to open", vim.log.levels.INFO)
		return
	end
	vim.ui.open(url)
end

--- Submit the pending review. Prompts for the event and an optional body
--- unless they are given.
---@param event? "COMMENT"|"APPROVE"|"REQUEST_CHANGES"
---@param body? string
function M.submit_review(event, body)
	if not require_session() then
		return
	end
	---@param chosen_event "COMMENT"|"APPROVE"|"REQUEST_CHANGES"
	---@param chosen_body string|nil
	local function go(chosen_event, chosen_body)
		sync.submit(chosen_event, chosen_body)
		util.notify("Review queued for submission (" .. chosen_event .. ")")
	end
	if event then
		go(event, body)
		return
	end
	vim.ui.select({ "COMMENT", "APPROVE", "REQUEST_CHANGES" }, { prompt = "Submit review as" }, function(choice)
		if not choice then
			return
		end
		vim.ui.input({ prompt = "Review body (optional): " }, function(text)
			if text == nil then
				return
			end
			go(choice, text)
		end)
	end)
end

--- Put every thread in the quickfix list (and open it, by default).
function M.list()
	local session = require_session()
	if not session then
		return
	end
	---@type vim.quickfix.entry[]
	local items = {}
	for _, thread in ipairs(session.threads) do
		local first = thread.comments[1]
		local flags = {}
		if thread.side == "LEFT" then
			table.insert(flags, "LEFT")
		end
		if thread.resolved then
			table.insert(flags, "resolved")
		end
		if thread.outdated then
			table.insert(flags, "outdated")
		end
		if thread.syncing then
			table.insert(flags, "unsynced")
		end
		table.insert(items, {
			filename = session.repo.root .. "/" .. thread.path,
			lnum = marks.anchor_line(thread) or 1,
			text = string.format(
				"%s@%s: %s%s",
				#flags > 0 and ("[" .. table.concat(flags, ",") .. "] ") or "",
				first and first.author or "?",
				util.first_line(first and first.body or ""),
				#thread.comments > 1 and string.format(" (+%d)", #thread.comments - 1) or ""
			),
		})
	end
	table.sort(items, function(a, b)
		if a.filename ~= b.filename then
			return (a.filename or "") < (b.filename or "")
		end
		return (a.lnum or 0) < (b.lnum or 0)
	end)
	local number = session.pr and tostring(session.pr.number) or "?"
	vim.fn.setqflist({}, " ", { title = "PR #" .. number .. " review threads", items = items })
	if config.options.open_quickfix then
		vim.cmd("copen")
	end
end

------------------------------------------------------------------------------
-- Status
------------------------------------------------------------------------------

--- A compact status string for your statusline. Empty when no review is active.
---@return string
function M.statusline()
	local session = state.session
	if not session then
		return ""
	end
	local icons = config.options.icons
	local parts = {}
	local label = session.pr and ("#" .. session.pr.number) or session.spec
	table.insert(parts, icons.review .. " " .. label)

	local counts = state.counts()
	if session.pr then
		table.insert(parts, string.format("%s %d/%d", config.options.icon, counts.unresolved, counts.threads))
	end
	if counts.pending > 0 then
		table.insert(parts, string.format("%s %d", icons.pending, counts.pending))
	end
	if counts.queued > 0 then
		table.insert(parts, string.format("%s %d", icons.syncing, counts.queued))
	end
	if session.from_cache then
		table.insert(parts, "(cached)")
	end

	local phase = session.phase
	if phase == "resolving" then
		table.insert(parts, "resolving…")
	elseif phase == "preparing" then
		table.insert(parts, session.detail or "jj new…")
	elseif phase == "fetching" then
		table.insert(parts, "fetching…")
	elseif phase == "syncing" then
		table.insert(parts, "syncing…")
	elseif phase == "error" then
		table.insert(parts, icons.error .. " " .. util.truncate(util.first_line(session.error or "error"), 40))
	end
	return table.concat(parts, " ")
end

--- Raw session for statusline components that want their own formatting.
---@return JjGhReviewSession|nil
function M.status()
	return state.session
end

------------------------------------------------------------------------------
-- :Review completion
------------------------------------------------------------------------------

---@type {at: integer, items: string[]}
local completion_cache = { at = 0, items = {} }

--- Command-line completion for `:Review`: open PR numbers and head branches.
---@param arg_lead string
---@return string[]
function M.complete(arg_lead)
	local now = vim.uv.now()
	if now - completion_cache.at > 60000 then
		local cwd = vim.fn.getcwd()
		local root = vim.system({ "jj", "root", "--ignore-working-copy" }, { cwd = cwd, text = true }):wait(2000)
		local git = vim.system({ "jj", "git", "root", "--ignore-working-copy" }, { cwd = cwd, text = true }):wait(2000)
		---@type string[]
		local items = {}
		if root.code == 0 and git.code == 0 then
			local repo = { root = util.trim(root.stdout), git_dir = util.trim(git.stdout) }
			for _, pr in ipairs(gh.pr_list_sync(repo, 4000)) do
				table.insert(items, tostring(pr.number))
				if pr.headRefName then
					table.insert(items, pr.headRefName)
				end
			end
		end
		completion_cache = { at = now, items = items }
	end
	local matches = {}
	for _, item in ipairs(completion_cache.items) do
		if vim.startswith(item, arg_lead) then
			table.insert(matches, item)
		end
	end
	return matches
end

return M
