--- Ghost text (extmarks) for threads in every buffer that shows a reviewed file.
local config = require("jj_gh_review.config")
local state = require("jj_gh_review.state")
local util = require("jj_gh_review.util")

local M = {}

---@type integer
M.ns = vim.api.nvim_create_namespace("jj_gh_review")

---@class JjGhReviewBufferTarget
---@field path string repo-relative path
---@field side "LEFT"|"RIGHT"

---@alias JjGhReviewVirtChunk [string, string]

--- Define (linkable) highlight groups, without overriding user definitions.
local function define_highlights()
	local links = {
		JjGhReviewVirtText = "Comment",
		JjGhReviewVirtTextResolved = "NonText",
		JjGhReviewVirtTextOutdated = "NonText",
		JjGhReviewVirtTextPending = "DiagnosticVirtualTextWarn",
		JjGhReviewVirtTextSyncing = "DiagnosticVirtualTextInfo",
		JjGhReviewRange = "CursorLine",
	}
	for group, link in pairs(links) do
		vim.api.nvim_set_hl(0, group, { link = link, default = true })
	end
end

---@param a integer
---@param b integer
---@return integer
local function min_int(a, b)
	if a < b then
		return a
	end
	return b
end

--- Which reviewed file (and diff side) a buffer displays, or nil.
---   * ordinary file buffers under the jj workspace root -> RIGHT (PR head)
---   * diffview://<toplevel>/.jj/<commit>/<path> buffers -> RIGHT when the
---     commit is the PR head, LEFT otherwise (the base side of the diff)
---@param bufnr integer
---@return JjGhReviewBufferTarget|nil
function M.buffer_target(bufnr)
	local session = state.session
	if not session or not vim.api.nvim_buf_is_valid(bufnr) then
		return nil
	end
	local name = vim.api.nvim_buf_get_name(bufnr)
	if name == "" then
		return nil
	end
	if vim.startswith(name, "diffview://") then
		local commit, path = name:match("^diffview://.-/%.jj/([^/]+)/(.+)$")
		if not commit or not path then
			return nil
		end
		local head = session.pr and session.pr.headRefOid or ""
		local side = (commit ~= "" and vim.startswith(head, commit)) and "RIGHT" or "LEFT"
		return { path = path, side = side }
	end
	if vim.bo[bufnr].buftype ~= "" then
		return nil
	end
	local rel = util.relpath(session.repo.root, vim.fn.fnamemodify(name, ":p"))
	if not rel or rel == "" then
		return nil
	end
	return { path = rel, side = "RIGHT" }
end

--- The buffer line a thread anchors to (1-based), or nil when not displayable.
---@param thread JjGhReviewThread
---@return integer|nil
function M.anchor_line(thread)
	if thread.outdated then
		return thread.original_start_line or thread.original_line
	end
	return thread.start_line or thread.line
end

--- Last line of the thread's range (1-based).
---@param thread JjGhReviewThread
---@return integer|nil
function M.end_line(thread)
	if thread.outdated then
		return thread.original_line or M.anchor_line(thread)
	end
	return thread.line or M.anchor_line(thread)
end

---@param thread JjGhReviewThread
---@return boolean
local function visible(thread)
	local opts = config.options
	if thread.outdated and not opts.show_outdated then
		return false
	end
	if thread.resolved and not opts.show_resolved then
		return false
	end
	return M.anchor_line(thread) ~= nil
end

--- Threads shown in `bufnr`, sorted by anchor line.
---@param bufnr integer
---@return JjGhReviewThread[] threads
---@return JjGhReviewBufferTarget|nil target
function M.threads_for_buffer(bufnr)
	local session = state.session
	local target = M.buffer_target(bufnr)
	if not session or not target then
		return {}, nil
	end
	local threads = {}
	for _, thread in ipairs(session.threads) do
		if thread.path == target.path and thread.side == target.side and visible(thread) then
			table.insert(threads, thread)
		end
	end
	table.sort(threads, function(a, b)
		return (M.anchor_line(a) or 0) < (M.anchor_line(b) or 0)
	end)
	return threads, target
end

--- Threads anchored exactly at `lnum` in `bufnr`.
---@param bufnr integer
---@param lnum integer
---@return JjGhReviewThread[]
function M.threads_at(bufnr, lnum)
	local found = {}
	for _, thread in ipairs(M.threads_for_buffer(bufnr)) do
		if M.anchor_line(thread) == lnum then
			table.insert(found, thread)
		end
	end
	return found
end

---@param thread JjGhReviewThread
---@return string highlight group
local function thread_hl(thread)
	if thread.syncing then
		return "JjGhReviewVirtTextSyncing"
	end
	if thread.outdated then
		return "JjGhReviewVirtTextOutdated"
	end
	if thread.resolved then
		return "JjGhReviewVirtTextResolved"
	end
	for _, comment in ipairs(thread.comments) do
		if comment.pending or comment.syncing then
			return "JjGhReviewVirtTextPending"
		end
	end
	return "JjGhReviewVirtText"
end

--- Default ghost text: icon, state glyphs, first author and a body preview.
---@param thread JjGhReviewThread
---@return JjGhReviewVirtChunk[]
function M.default_format(thread)
	local opts = config.options
	local first = thread.comments[1]
	local parts = { opts.icon }
	if thread.syncing then
		table.insert(parts, opts.icons.syncing)
	end
	if thread.outdated then
		table.insert(parts, opts.icons.outdated)
	end
	if thread.resolved then
		table.insert(parts, opts.icons.resolved)
	end
	if first then
		local pending = ""
		for _, comment in ipairs(thread.comments) do
			if comment.pending then
				pending = " " .. opts.icons.pending
				break
			end
		end
		local preview = util.truncate(util.first_line(first.body), opts.preview_width)
		table.insert(parts, string.format("@%s%s: %s", first.author, pending, preview))
	end
	if #thread.comments > 1 then
		table.insert(parts, string.format("(+%d)", #thread.comments - 1))
	end
	return { { table.concat(parts, " "), thread_hl(thread) } }
end

---@param thread JjGhReviewThread
---@return JjGhReviewVirtChunk[]
local function chunks_for(thread)
	local formatter = config.options.format_thread or M.default_format
	local result = formatter(thread)
	if type(result) == "string" then
		return { { result, thread_hl(thread) } }
	end
	return result
end

--- Remove all ghost text from a buffer.
---@param bufnr integer
function M.clear(bufnr)
	if vim.api.nvim_buf_is_valid(bufnr) then
		vim.api.nvim_buf_clear_namespace(bufnr, M.ns, 0, -1)
	end
end

--- (Re)draw ghost text in a buffer. Cheap when nothing changed since last time.
---@param bufnr integer
---@param force? boolean
function M.render(bufnr, force)
	if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
		return
	end
	local line_count = vim.api.nvim_buf_line_count(bufnr)
	local stamp = state.generation .. ":" .. line_count
	if not force and vim.b[bufnr].jj_gh_review_stamp == stamp then
		return
	end
	vim.b[bufnr].jj_gh_review_stamp = stamp
	M.clear(bufnr)
	if not state.session then
		return
	end
	define_highlights()
	---@type table<integer, JjGhReviewThread[]>
	local by_line = {}
	---@type integer[]
	local order = {}
	for _, thread in ipairs(M.threads_for_buffer(bufnr)) do
		local lnum = min_int(M.anchor_line(thread) or 1, line_count)
		local bucket = by_line[lnum]
		if not bucket then
			bucket = {}
			by_line[lnum] = bucket
			table.insert(order, lnum)
		end
		table.insert(bucket, thread)
	end
	for _, lnum in ipairs(order) do
		local threads = by_line[lnum]
		---@type JjGhReviewVirtChunk[]
		local chunks = {}
		for index, thread in ipairs(threads) do
			if index > 1 then
				table.insert(chunks, { "  ", "NonText" })
			end
			vim.list_extend(chunks, chunks_for(thread))
		end
		pcall(vim.api.nvim_buf_set_extmark, bufnr, M.ns, lnum - 1, 0, {
			virt_text = chunks,
			virt_text_pos = config.options.virt_text_pos,
			hl_mode = "combine",
			priority = 200,
		})
		if config.options.highlight_range then
			for _, thread in ipairs(threads) do
				local last = min_int(M.end_line(thread) or lnum, line_count)
				for l = lnum, last do
					pcall(vim.api.nvim_buf_set_extmark, bufnr, M.ns, l - 1, 0, {
						line_hl_group = "JjGhReviewRange",
						priority = 50,
					})
				end
			end
		end
	end
end

--- Render every loaded buffer.
---@param force? boolean
function M.render_all(force)
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(bufnr) then
			M.render(bufnr, force)
		end
	end
end

--- Remove ghost text from every loaded buffer.
function M.clear_all()
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(bufnr) then
			M.clear(bufnr)
			vim.b[bufnr].jj_gh_review_stamp = nil
		end
	end
end

local attached = false

--- Install the autocommands that keep ghost text up to date. Idempotent.
function M.attach()
	if attached then
		return
	end
	attached = true
	local group = vim.api.nvim_create_augroup("jj_gh_review_marks", { clear = true })
	vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "BufReadPost", "CursorHold", "TextChanged" }, {
		group = group,
		callback = function(args)
			M.render(args.buf)
		end,
	})
	vim.api.nvim_create_autocmd("User", {
		group = group,
		pattern = "JjGhReviewChanged",
		callback = function()
			M.render_all()
		end,
	})
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = group,
		callback = define_highlights,
	})
end

return M
