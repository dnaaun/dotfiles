--- Floating thread buffers. A thread is rendered as markdown sections, one per
--- comment, each tagged with a hidden id marker. Saving the buffer (`:w`) diffs
--- the sections against the thread: edited own comments become edits, a
--- non-empty trailing "reply"/"comment" section becomes a new comment.
local config = require("jj_gh_review.config")
local marks = require("jj_gh_review.marks")
local state = require("jj_gh_review.state")
local sync = require("jj_gh_review.sync")
local util = require("jj_gh_review.util")

local M = {}

---@type integer|nil
M.float_win = nil
---@type integer|nil
M.float_buf = nil

local MARKER = "<!%-%- jjghreview:(%S+) %-%->"
local NEW_ID = "new"

---@class JjGhReviewNewTarget
---@field path string
---@field side "LEFT"|"RIGHT"
---@field start_side "LEFT"|"RIGHT"|nil
---@field start_line integer
---@field line integer

---@class JjGhReviewBufferMeta
---@field kind "thread"|"new"
---@field thread_id string|nil
---@field target JjGhReviewNewTarget|nil

---@class JjGhReviewSection
---@field id string
---@field lines string[]
---@field body string

---@param id string
---@return string
local function marker(id)
	return string.format("<!-- jjghreview:%s -->", id)
end

---@param comment JjGhReviewComment
---@return string
local function header_for(comment)
	local bits = { "@" .. comment.author }
	if comment.created_at then
		table.insert(bits, util.format_time(comment.created_at))
	end
	if comment.syncing then
		table.insert(bits, "unsynced")
	elseif comment.pending then
		table.insert(bits, "pending review")
	end
	if not comment.mine then
		table.insert(bits, "read-only")
	end
	return string.format("### %s %s", table.concat(bits, " · "), marker(comment.id))
end

---@param target {path: string, line: integer|nil, start_line: integer|nil, side: string|nil}
---@return string
local function describe_range(target)
	local range = tostring(target.start_line or target.line)
	if target.start_line and target.line and target.start_line ~= target.line then
		range = range .. "-" .. target.line
	end
	return string.format("%s:%s (%s)", target.path, range, target.side or "RIGHT")
end

---@param thread JjGhReviewThread
---@return string[]
local function thread_lines(thread)
	local flags = {}
	if thread.resolved then
		table.insert(flags, "resolved")
	end
	if thread.outdated then
		table.insert(flags, "outdated")
	end
	local lines = {
		string.format(
			"<!-- %s%s · edit your own comments or type a reply below, then :w -->",
			describe_range(thread),
			#flags > 0 and (" · " .. table.concat(flags, ", ")) or ""
		),
	}
	for _, comment in ipairs(thread.comments) do
		table.insert(lines, "")
		table.insert(lines, header_for(comment))
		vim.list_extend(lines, vim.split(comment.body, "\n", { plain = true }))
	end
	table.insert(lines, "")
	table.insert(lines, string.format("### reply %s", marker(NEW_ID)))
	table.insert(lines, "")
	return lines
end

---@param target JjGhReviewNewTarget
---@return string[]
local function new_comment_lines(target)
	return {
		string.format("<!-- new comment on %s · type below, then :w -->", describe_range(target)),
		"",
		string.format("### comment %s", marker(NEW_ID)),
		"",
	}
end

--- Split buffer lines into sections keyed by marker id.
---@param lines string[]
---@return table<string, JjGhReviewSection> sections
---@return string[] order
local function parse_sections(lines)
	---@type table<string, JjGhReviewSection>
	local sections = {}
	---@type string[]
	local order = {}
	---@type JjGhReviewSection|nil
	local current = nil
	for index, line in ipairs(lines) do
		local id = line:match("^###.-" .. MARKER .. "%s*$")
		if id then
			current = { id = id, lines = {}, body = "" }
			sections[id] = current
			table.insert(order, id)
		elseif current then
			table.insert(current.lines, line)
		elseif index > 1 and util.trim(line) ~= "" then
			-- Text before the first section: attach to a synthetic section so
			-- it isn't silently lost.
			current = { id = NEW_ID, lines = { line }, body = "" }
			sections[NEW_ID] = current
			table.insert(order, NEW_ID)
		end
	end
	for _, section in pairs(sections) do
		while section.lines[1] and util.trim(section.lines[1]) == "" do
			table.remove(section.lines, 1)
		end
		while section.lines[#section.lines] and util.trim(section.lines[#section.lines]) == "" do
			table.remove(section.lines)
		end
		section.body = table.concat(section.lines, "\n")
	end
	return sections, order
end

------------------------------------------------------------------------------
-- Floating window sizing
------------------------------------------------------------------------------

---@param value number
---@param total integer
---@return integer
local function resolve_dim(value, total)
	if value < 1 then
		return math.floor(total * value)
	end
	return math.floor(value)
end

--- Width/height that fit `lines` (wrapped), within the configured bounds.
---@param lines string[]
---@return integer width
---@return integer height
local function measure(lines)
	local opts = config.options.float
	local max_width = math.max(resolve_dim(opts.max_width, vim.o.columns) - 2, 10)
	local width = opts.min_width
	for _, line in ipairs(lines) do
		width = math.max(width, vim.fn.strdisplaywidth(line) + 1)
	end
	width = math.min(width, max_width)
	local height = 0
	for _, line in ipairs(lines) do
		height = height + math.max(1, math.ceil(vim.fn.strdisplaywidth(line) / width))
	end
	local max_height = math.max(resolve_dim(opts.max_height, vim.o.lines) - 2, opts.min_height)
	height = math.max(opts.min_height, math.min(height, max_height))
	return math.floor(width), math.floor(height)
end

---@param lines string[]
---@param title string|nil
---@return vim.api.keyset.win_config
local function float_config(lines, title)
	local width, height = measure(lines)
	local win_row = vim.fn.winline()
	local room_below = vim.api.nvim_win_get_height(0) - win_row
	---@type "NW"|"SW"
	local anchor = "NW"
	local row = 1
	if room_below < height + 2 and win_row > height + 2 then
		anchor, row = "SW", 0
	end
	---@type vim.api.keyset.win_config
	local win_config = {
		relative = "cursor",
		anchor = anchor,
		row = row,
		col = 0,
		width = width,
		height = height,
		style = "minimal",
		border = config.options.float.border,
		zindex = 60,
	}
	if title then
		win_config.title = " " .. title .. " "
		win_config.title_pos = "left"
	end
	return win_config
end

--- Re-fit an open float to its buffer's content.
---@param win integer|nil
function M.resize(win)
	if not win or not vim.api.nvim_win_is_valid(win) then
		return
	end
	local buf = vim.api.nvim_win_get_buf(win)
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	local width, height = measure(lines)
	pcall(vim.api.nvim_win_set_config, win, { width = width, height = height })
end

------------------------------------------------------------------------------
-- Buffers
------------------------------------------------------------------------------

---@param name string
---@param lines string[]
---@param meta JjGhReviewBufferMeta
---@return integer bufnr
local function make_buffer(name, lines, meta)
	local existing = vim.fn.bufnr(name)
	if existing ~= -1 and vim.api.nvim_buf_is_valid(existing) then
		pcall(vim.api.nvim_buf_delete, existing, { force = true })
	end
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(buf, name)
	vim.bo[buf].buftype = "acwrite"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].swapfile = false
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modified = false
	vim.bo[buf].filetype = "markdown"
	vim.b[buf].jj_gh_review = meta
	return buf
end

---@param buf integer
---@return JjGhReviewBufferMeta|nil
local function meta_of(buf)
	local meta = vim.b[buf].jj_gh_review
	if type(meta) ~= "table" then
		return nil
	end
	return meta
end

---@param buf integer
---@param title string|nil
---@return integer win
local function open_float(buf, title)
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	local win = vim.api.nvim_open_win(buf, true, float_config(lines, title))
	vim.wo[win].wrap = true
	vim.wo[win].linebreak = true
	vim.wo[win].conceallevel = 2
	vim.wo[win].concealcursor = "nc"
	vim.wo[win].signcolumn = "no"
	vim.wo[win].number = false
	vim.wo[win].relativenumber = false
	vim.wo[win].cursorline = false
	M.float_win = win
	M.float_buf = buf

	local group = vim.api.nvim_create_augroup("jj_gh_review_float_" .. buf, { clear = true })
	vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
		group = group,
		buffer = buf,
		callback = function()
			M.resize(win)
		end,
	})
	vim.api.nvim_create_autocmd("BufWriteCmd", {
		group = group,
		buffer = buf,
		callback = function()
			M.save(buf)
		end,
	})
	vim.api.nvim_create_autocmd("BufWipeout", {
		group = group,
		buffer = buf,
		callback = function()
			if M.float_buf == buf then
				M.float_win, M.float_buf = nil, nil
			end
		end,
	})
	vim.api.nvim_exec_autocmds("User", {
		pattern = "JjGhReviewThreadBuffer",
		data = { buf = buf, win = win },
		modeline = false,
	})
	return win
end

--- Close the thread/comment float, if open.
function M.close()
	if M.float_win and vim.api.nvim_win_is_valid(M.float_win) then
		pcall(vim.api.nvim_win_close, M.float_win, true)
	end
	M.float_win, M.float_buf = nil, nil
end

--- Is `buf` (default: current) one of our thread/comment buffers?
---@param buf? integer
---@return boolean
function M.is_thread_buffer(buf)
	return meta_of(buf or vim.api.nvim_get_current_buf()) ~= nil
end

--- Open (or re-open) the float for `thread`.
---@param thread JjGhReviewThread
function M.open_thread(thread)
	local session = state.session
	if not session then
		return
	end
	M.close()
	local name = string.format("jjghreview://%d/%s", session.pr and session.pr.number or 0, thread.id)
	local buf = make_buffer(name, thread_lines(thread), { kind = "thread", thread_id = thread.id })
	local first = thread.comments[1]
	local title = string.format("%s%s", describe_range(thread), first and (" @" .. first.author) or "")
	local win = open_float(buf, title)
	-- Put the cursor in the reply section.
	vim.api.nvim_win_set_cursor(win, { vim.api.nvim_buf_line_count(buf), 0 })
end

--- Open the float for a brand-new comment on `target`.
---@param target JjGhReviewNewTarget
function M.open_new(target)
	local session = state.session
	if not session then
		return
	end
	M.close()
	local name = string.format(
		"jjghreview://%d/new/%s:%d",
		session.pr and session.pr.number or 0,
		target.path,
		target.start_line or target.line
	)
	local buf = make_buffer(name, new_comment_lines(target), { kind = "new", target = target })
	local win = open_float(buf, "new comment " .. describe_range(target))
	vim.api.nvim_win_set_cursor(win, { vim.api.nvim_buf_line_count(buf), 0 })
	vim.cmd("startinsert")
end

--- Refresh the content of an open thread float after the thread changed.
function M.refresh()
	local buf = M.float_buf
	if not buf or not vim.api.nvim_buf_is_valid(buf) then
		return
	end
	local meta = meta_of(buf)
	if not meta or meta.kind ~= "thread" or vim.bo[buf].modified then
		return
	end
	local thread = state.find_thread(meta.thread_id)
	if not thread then
		return
	end
	vim.b[buf].jj_gh_review = { kind = "thread", thread_id = thread.id }
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, thread_lines(thread))
	vim.bo[buf].modified = false
	M.resize(M.float_win)
end

--- The comment whose section contains the cursor in the current thread float.
---@param buf? integer
---@param lnum? integer
---@return JjGhReviewComment|nil
function M.comment_at_cursor(buf, lnum)
	buf = buf or vim.api.nvim_get_current_buf()
	local meta = meta_of(buf)
	if not meta or meta.kind ~= "thread" then
		return nil
	end
	lnum = lnum or vim.api.nvim_win_get_cursor(0)[1] or 1
	local lines = vim.api.nvim_buf_get_lines(buf, 0, lnum, false)
	for index = #lines, 1, -1 do
		local id = lines[index]:match("^###.-" .. MARKER .. "%s*$")
		if id then
			if id == NEW_ID then
				return nil
			end
			return (state.find_comment(id))
		end
	end
	return nil
end

--- BufWriteCmd handler: turn buffer edits into queued operations.
---@param buf integer
function M.save(buf)
	local session = state.session
	local meta = meta_of(buf)
	if not session or not meta then
		vim.bo[buf].modified = false
		return
	end
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	local sections = parse_sections(lines)
	local changes = 0

	local target = meta.target
	if meta.kind == "new" and target then
		local body = sections[NEW_ID] and sections[NEW_ID].body or ""
		if util.trim(body) == "" then
			util.notify("Empty comment; nothing saved", vim.log.levels.WARN)
			vim.bo[buf].modified = false
			return
		end
		local thread = sync.add_thread({
			path = target.path,
			body = body,
			line = target.line,
			start_line = target.start_line,
			side = target.side,
			start_side = target.start_side,
		})
		changes = changes + 1
		vim.bo[buf].modified = false
		if config.options.float.close_on_save then
			M.close()
		elseif thread then
			M.open_thread(thread)
		end
	else
		local thread = state.find_thread(meta.thread_id)
		if not thread then
			util.notify("Thread no longer exists", vim.log.levels.ERROR)
			vim.bo[buf].modified = false
			return
		end
		for _, comment in ipairs(thread.comments) do
			local section = sections[comment.id]
			if section and section.body ~= comment.body then
				if comment.mine then
					sync.edit(comment, section.body)
					changes = changes + 1
				else
					util.notify("Ignoring edit to @" .. comment.author .. "'s comment (not yours)", vim.log.levels.WARN)
				end
			end
		end
		local reply = sections[NEW_ID] and sections[NEW_ID].body or ""
		if util.trim(reply) ~= "" then
			sync.reply(thread, reply)
			changes = changes + 1
		end
		vim.bo[buf].modified = false
		if changes > 0 and config.options.float.close_on_save then
			M.close()
		else
			M.refresh()
		end
	end

	if changes == 0 then
		util.notify("No changes to save", vim.log.levels.INFO)
	end
	marks.render_all(true)
end

------------------------------------------------------------------------------
-- Pickers
------------------------------------------------------------------------------

--- Let the user pick one of several threads (skips the prompt for a single one).
---@param threads JjGhReviewThread[]
---@param callback fun(thread: JjGhReviewThread)
function M.pick_thread(threads, callback)
	if #threads == 1 then
		callback(threads[1])
		return
	end
	vim.ui.select(threads, {
		prompt = "Thread",
		format_item = function(thread)
			local first = thread.comments[1]
			return string.format(
				"@%s: %s (%d)",
				first and first.author or "?",
				util.truncate(util.first_line(first and first.body or ""), 60),
				#thread.comments
			)
		end,
	}, function(choice)
		if choice then
			callback(choice)
		end
	end)
end

return M
