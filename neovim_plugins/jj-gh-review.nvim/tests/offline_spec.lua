--- Offline smoke test: exercises the whole write path with GitHub stubbed out.
--- Run with `make test` (nvim --headless -l tests/offline_spec.lua).
local info = debug.getinfo(1, "S")
assert(info, "debug.getinfo failed")
local plugin_root = vim.fs.normalize(vim.fs.dirname(vim.fs.dirname(info.source:sub(2))))
vim.opt.rtp:prepend(plugin_root)
vim.cmd("runtime plugin/jj_gh_review.lua")
local tmp = vim.fn.tempname()
vim.fn.mkdir(tmp, "p")
local R = require("jj_gh_review")
local state = require("jj_gh_review.state")
local marks = require("jj_gh_review.marks")
local ui = require("jj_gh_review.ui")
local gh = require("jj_gh_review.gh")
R.setup({ cache_dir = tmp .. "/cache", jj_new = false, diffview_cmd = false })

---@param condition any
---@param message string
---@return any
local function check(condition, message)
	assert(condition, message)
	return condition
end

---@param id string
---@param body string
---@param author string
---@param mine boolean
---@return JjGhReviewComment
local function comment(id, body, author, mine)
	return { id = id, body = body, author = author, pending = mine, mine = mine }
end

------------------------------------------------------------------------------
-- Network stubs: every GitHub call succeeds and returns a plausible response.
------------------------------------------------------------------------------

--- Pretend a pending review exists.
---@param _repo JjGhReviewRepo
---@param _pr JjGhReviewPr
---@param cb fun(review_id: string|nil, err: string|nil)
gh.create_pending_review = function(_repo, _pr, cb)
	cb("PRR_fake")
end

--- Echo the new thread back with GitHub ids.
---@param _repo JjGhReviewRepo
---@param _review_id string
---@param thread JjGhReviewNewThread
---@param cb fun(thread: JjGhReviewThread|nil, err: string|nil)
gh.add_thread = function(_repo, _review_id, thread, cb)
	cb({
		id = "PRRT_remote",
		path = thread.path,
		line = thread.line,
		start_line = thread.start_line or thread.line,
		side = thread.side,
		resolved = false,
		outdated = false,
		comments = { comment("PRRC_remote", thread.body, "david", true) },
	})
end

--- Return the thread with the reply appended (body of the first comment as GitHub has it).
---@param _repo JjGhReviewRepo
---@param thread_id string
---@param _review_id string|nil
---@param body string
---@param cb fun(thread: JjGhReviewThread|nil, err: string|nil)
gh.reply = function(_repo, thread_id, _review_id, body, cb)
	local existing = check(state.find_thread(thread_id), "reply to unknown thread " .. thread_id)
	local first = check(existing.comments[1], "thread without comments")
	cb({
		id = thread_id,
		path = "src/a.lua",
		line = 3,
		start_line = 3,
		side = "RIGHT",
		resolved = false,
		outdated = false,
		comments = {
			comment("PRRC_remote", first.body, "david", true),
			comment("PRRC_reply", body, "david", true),
		},
	})
end

--- Accept every edit.
---@param _repo JjGhReviewRepo
---@param id string
---@param _body string
---@param cb fun(comment: table|nil, err: string|nil)
gh.update_comment = function(_repo, id, _body, cb)
	cb({ id = id })
end

------------------------------------------------------------------------------
-- Fixture: a fake repo with one file and one existing thread from someone else.
------------------------------------------------------------------------------

local root = tmp .. "/repo"
vim.fn.mkdir(root .. "/src", "p")
vim.fn.writefile({ "line1", "line2", "line3", "line4", "line5" }, root .. "/src/a.lua")

local session = state.new_session("123", { root = root, git_dir = root .. "/.git" })
session.pr = {
	id = "PR_x",
	number = 123,
	title = "Test PR",
	url = "https://github.com/o/r/pull/123",
	state = "OPEN",
	isDraft = false,
	author = { login = "alice" },
	headRefName = "feat",
	headRefOid = "abcdef1234567890",
	baseRefName = "main",
	baseRefOid = "0000000aaaa1111",
	isCrossRepository = false,
	owner = "o",
	name = "r",
}
session.viewer = "david"
---@type JjGhReviewThread[]
local existing_threads = {
	{
		id = "PRRT_1",
		path = "src/a.lua",
		line = 2,
		start_line = 2,
		side = "RIGHT",
		resolved = false,
		outdated = false,
		comments = { comment("PRRC_1", "existing comment\nsecond line", "alice", false) },
	},
}
session.threads = existing_threads
marks.attach()

--- Virtual text of the n-th extmark in the current buffer.
---@param index integer
---@return string
local function virt_text_at(index)
	local extmarks = vim.api.nvim_buf_get_extmarks(0, marks.ns, 0, -1, { details = true })
	local extmark = check(extmarks[index], "no extmark #" .. index)
	local details = check(extmark[4], "extmark without details")
	local chunk = check(details.virt_text and details.virt_text[1], "extmark without virt_text")
	return chunk[1]
end

---@return integer
local function extmark_count()
	return #vim.api.nvim_buf_get_extmarks(0, marks.ns, 0, -1, {})
end

---@return integer
local function cursor_line()
	return check(vim.api.nvim_win_get_cursor(0)[1], "no cursor line")
end

------------------------------------------------------------------------------
-- Rendering of existing threads
------------------------------------------------------------------------------

vim.cmd("edit " .. root .. "/src/a.lua")
marks.render(0, true)
check(extmark_count() == 1, "expected 1 extmark, got " .. extmark_count())
local first_extmark = check(vim.api.nvim_buf_get_extmarks(0, marks.ns, 0, -1, {})[1], "missing extmark")
check(first_extmark[2] == 1, "extmark on wrong row")
print("virt text:", virt_text_at(1))
print("statusline:", R.statusline())

------------------------------------------------------------------------------
-- New comment on line 3 through the float + :w path
------------------------------------------------------------------------------

vim.api.nvim_win_set_cursor(0, { 3, 0 })
R.comment()
local new_buf = check(ui.float_buf, "no float buffer")
vim.cmd("stopinsert")
vim.api.nvim_buf_set_lines(new_buf, -1, -1, false, { "my new comment", "", "with two paragraphs" })
vim.cmd("write")
check(#session.threads == 2, "thread not added optimistically")
print("statusline after save:", R.statusline())
vim.wait(500, function()
	return #session.queue == 0
end)
check(#session.queue == 0, "queue not drained")
local created = check(session.threads[2], "second thread missing")
check(created.id == "PRRT_remote", "remote thread not adopted: " .. created.id)
local created_comment = check(created.comments[1], "created thread has no comment")
check(created_comment.body == "my new comment\n\nwith two paragraphs", "body mismatch: " .. created_comment.body)
marks.render(0, true)
check(extmark_count() == 2, "expected 2 extmarks, got " .. extmark_count())
print("virt text 2:", virt_text_at(2))

------------------------------------------------------------------------------
-- View the thread, edit own comment, add a reply, save
------------------------------------------------------------------------------

R.view()
local thread_buf = check(ui.float_buf, "no thread float")
local lines = vim.api.nvim_buf_get_lines(thread_buf, 0, -1, false)
print(table.concat(lines, "\n"))
for i, line in ipairs(lines) do
	if line == "my new comment" then
		lines[i] = "my EDITED comment"
	end
end
table.insert(lines, "a reply")
vim.api.nvim_buf_set_lines(thread_buf, 0, -1, false, lines)
vim.cmd("write")
vim.wait(500, function()
	return #session.queue == 0
end)
local thread = check(state.find_thread("PRRT_remote"), "thread lost after reply")
local edited = check(thread.comments[1], "edited comment missing")
local reply = check(thread.comments[2], "reply missing")
check(edited.body == "my EDITED comment\n\nwith two paragraphs", "edit not applied: " .. edited.body)
check(not edited.syncing and not reply.syncing, "syncing flag stuck")
check(#thread.comments == 2 and reply.body == "a reply", "reply not applied")
print("statusline end:", R.statusline())

------------------------------------------------------------------------------
-- Navigation wraps in both directions
------------------------------------------------------------------------------

vim.api.nvim_win_set_cursor(0, { 1, 0 })
R.next()
check(cursor_line() == 2, "next should land on line 2")
R.next()
check(cursor_line() == 3, "next should land on line 3")
R.next()
check(cursor_line() == 2, "next should wrap to line 2")
R.prev()
check(cursor_line() == 3, "prev should wrap to line 3")

------------------------------------------------------------------------------
-- Diffview buffers map to the right diff side
------------------------------------------------------------------------------

local diff_buf = vim.api.nvim_create_buf(false, true)
vim.api.nvim_buf_set_name(diff_buf, "diffview://" .. root .. "/.jj/abcdef12345/src/a.lua")
local head_target = check(marks.buffer_target(diff_buf), "head diffview buffer not recognised")
check(head_target.side == "RIGHT", "PR head commit should be the RIGHT side")
vim.api.nvim_buf_set_name(diff_buf, "diffview://" .. root .. "/.jj/0000000aaaa/src/a.lua")
local base_target = check(marks.buffer_target(diff_buf), "base diffview buffer not recognised")
check(base_target.side == "LEFT", "non-head commit should be the LEFT side")

------------------------------------------------------------------------------
-- Quickfix list and teardown
------------------------------------------------------------------------------

R.list()
print(
	"qf:",
	vim.inspect(vim.tbl_map(function(item)
		return item.text
	end, vim.fn.getqflist()))
)
R.close()
check(R.statusline() == "", "statusline should be empty after close")
print("ALL OK")
