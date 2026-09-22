--- Optimistic, offline-first write path. Every local change is applied to the
--- in-memory session immediately, appended to a persisted queue, and pushed to
--- GitHub in order in the background. Failures keep the op queued and retry
--- with backoff (or on the next explicit `sync()`).
local cache = require("jj_gh_review.cache")
local config = require("jj_gh_review.config")
local gh = require("jj_gh_review.gh")
local state = require("jj_gh_review.state")
local util = require("jj_gh_review.util")

local M = {}

--- Called after the queue drained successfully (set by the entry point).
---@type fun()|nil
M.on_drained = nil

local running = false
---@type uv.uv_timer_t|nil
local retry_timer = nil
---@type number|nil
local retry_delay = nil

---@param session JjGhReviewSession
local function persist(session)
	cache.save_queue(session)
	cache.save_pr(session)
end

---@param session JjGhReviewSession
---@param kind string
---@param key string
---@param id string
---@return boolean
local function has_queued(session, kind, key, id)
	for _, op in ipairs(session.queue) do
		if op.kind == kind and state.resolve_id(op[key]) == id then
			return true
		end
	end
	return false
end

--- Merge the comments GitHub returned for a thread with what we have locally:
--- keep bodies of comments whose edits are still queued, and keep comments
--- that only exist locally (their create op hasn't synced yet).
---@param session JjGhReviewSession
---@param local_thread JjGhReviewThread
---@param remote JjGhReviewThread
local function merge_comments(session, local_thread, remote)
	---@type table<string, JjGhReviewComment>
	local by_remote_id = {}
	for _, comment in ipairs(local_thread.comments) do
		by_remote_id[session.id_map[comment.id] or comment.id] = comment
	end
	local merged = {}
	for _, remote_comment in ipairs(remote.comments) do
		local local_comment = by_remote_id[remote_comment.id]
		if local_comment and has_queued(session, "edit", "comment_id", remote_comment.id) then
			remote_comment.body = local_comment.body
			remote_comment.syncing = true
		end
		table.insert(merged, remote_comment)
	end
	for _, comment in ipairs(local_thread.comments) do
		if util.is_local_id(comment.id) and not session.id_map[comment.id] then
			table.insert(merged, comment)
		end
	end
	remote.comments = merged
	if has_queued(session, "resolve", "thread_id", remote.id) then
		-- A resolve/unresolve is still queued; trust the local flag.
		remote.resolved = local_thread.resolved
		remote.syncing = true
	end
end

--- Replace a local thread with the authoritative one from GitHub, recording id
--- mappings so queued ops that reference local ids still resolve.
---@param session JjGhReviewSession
---@param local_thread JjGhReviewThread|nil
---@param remote JjGhReviewThread|nil
local function adopt_thread(session, local_thread, remote)
	if not remote then
		return
	end
	if local_thread then
		session.id_map[local_thread.id] = remote.id
		for index, comment in ipairs(local_thread.comments) do
			local remote_comment = remote.comments[index]
			if remote_comment and util.is_local_id(comment.id) and not session.id_map[comment.id] then
				session.id_map[comment.id] = remote_comment.id
			end
		end
		merge_comments(session, local_thread, remote)
	end
	local replaced = false
	for index, thread in ipairs(session.threads) do
		if thread == local_thread or thread.id == remote.id then
			session.threads[index] = remote
			replaced = true
			break
		end
	end
	if not replaced then
		table.insert(session.threads, remote)
	end
end

--- Mark the authoritative comment for a queued reply by matching bodies.
---@param session JjGhReviewSession
---@param thread JjGhReviewThread
---@param remote JjGhReviewThread|nil
---@param local_comment_id string|nil
local function adopt_reply(session, thread, remote, local_comment_id)
	if not remote then
		return
	end
	local local_comment = nil
	for _, comment in ipairs(thread.comments) do
		if comment.id == local_comment_id then
			local_comment = comment
		end
	end
	if local_comment then
		for _, remote_comment in ipairs(remote.comments) do
			if remote_comment.body == local_comment.body and remote_comment.mine then
				session.id_map[local_comment.id] = remote_comment.id
			end
		end
	end
	adopt_thread(session, thread, remote)
end

--- Replace the whole thread list with a fresh fetch, preserving local-only
--- threads/comments and bodies of comments whose edits are still queued.
---@param session JjGhReviewSession
---@param remote_threads JjGhReviewThread[]
function M.merge_remote(session, remote_threads)
	---@type table<string, JjGhReviewThread>
	local by_id = {}
	for _, thread in ipairs(session.threads) do
		by_id[session.id_map[thread.id] or thread.id] = thread
	end
	local merged = {}
	for _, remote in ipairs(remote_threads) do
		local local_thread = by_id[remote.id]
		if local_thread then
			merge_comments(session, local_thread, remote)
			by_id[remote.id] = nil
		end
		table.insert(merged, remote)
	end
	for _, thread in pairs(by_id) do
		if util.is_local_id(thread.id) and not session.id_map[thread.id] then
			table.insert(merged, thread)
		end
	end
	session.threads = merged
end

---@param session JjGhReviewSession
---@param callback fun(review_id: string|nil, err: string|nil)
local function ensure_review(session, callback)
	if not config.options.use_pending_review then
		callback(nil)
		return
	end
	if session.pending_review_id then
		callback(session.pending_review_id)
		return
	end
	if not session.pr then
		callback(nil, "no PR")
		return
	end
	gh.create_pending_review(session.repo, session.pr, function(review_id, err)
		if err then
			callback(nil, err)
			return
		end
		session.pending_review_id = review_id
		callback(review_id)
	end)
end

---@alias JjGhReviewExecutor fun(session: JjGhReviewSession, op: JjGhReviewOp, done: fun(err: string|nil))

---@type table<string, JjGhReviewExecutor>
local executors = {}

executors.add_thread = function(session, op, done)
	local pr = session.pr
	if not pr then
		return done("no PR")
	end
	local local_thread = state.find_thread(op.local_id)
	---@type JjGhReviewNewThread
	local payload = {
		path = op.path or "",
		body = op.body or "",
		line = op.line or 1,
		start_line = op.start_line,
		side = op.side or "RIGHT",
		start_side = op.start_side,
	}
	if not config.options.use_pending_review then
		gh.add_immediate_thread(session.repo, pr, payload, function(remote, err)
			if err then
				return done(err)
			end
			adopt_thread(session, local_thread, remote)
			done(nil)
		end)
		return
	end
	ensure_review(session, function(review_id, err)
		if err or not review_id then
			return done(err or "no pending review")
		end
		gh.add_thread(session.repo, review_id, payload, function(remote, err2)
			if err2 then
				return done(err2)
			end
			adopt_thread(session, local_thread, remote)
			done(nil)
		end)
	end)
end

executors.reply = function(session, op, done)
	local thread_id = state.resolve_id(op.thread_id)
	if not thread_id or util.is_local_id(thread_id) then
		return done("thread not yet created on GitHub")
	end
	local thread = state.find_thread(thread_id)
	local review_id = config.options.use_pending_review and session.pending_review_id or nil
	gh.reply(session.repo, thread_id, review_id, op.body or "", function(remote, err)
		if err then
			return done(err)
		end
		if thread then
			adopt_reply(session, thread, remote, op.local_id)
		end
		done(nil)
	end)
end

executors.edit = function(session, op, done)
	local comment_id = state.resolve_id(op.comment_id)
	if not comment_id or util.is_local_id(comment_id) then
		return done("comment not yet created on GitHub")
	end
	gh.update_comment(session.repo, comment_id, op.body or "", function(_, err)
		if err then
			return done(err)
		end
		local comment = state.find_comment(comment_id)
		if comment then
			comment.syncing = nil
		end
		done(nil)
	end)
end

executors.delete = function(session, op, done)
	local comment_id = state.resolve_id(op.comment_id)
	if not comment_id or util.is_local_id(comment_id) then
		-- Never made it to GitHub; nothing to delete remotely.
		return done(nil)
	end
	gh.delete_comment(session.repo, comment_id, function(_, err)
		done(err)
	end)
end

executors.resolve = function(session, op, done)
	local thread_id = state.resolve_id(op.thread_id)
	if not thread_id or util.is_local_id(thread_id) then
		return done("thread not yet created on GitHub")
	end
	gh.set_resolved(session.repo, thread_id, op.resolved == true, function(_, err)
		if err then
			return done(err)
		end
		local thread = state.find_thread(thread_id)
		if thread then
			thread.syncing = nil
		end
		done(nil)
	end)
end

executors.submit = function(session, op, done)
	local pr = session.pr
	if not pr then
		return done("no PR")
	end
	local event = op.event --[[@as "COMMENT"|"APPROVE"|"REQUEST_CHANGES"]]

	---@param review_id string
	local function submit(review_id)
		gh.submit_review(session.repo, review_id, event, op.body, function(_, err)
			if err then
				return done(err)
			end
			if session.pending_review_id == review_id then
				session.pending_review_id = nil
			end
			for _, thread in ipairs(session.threads) do
				for _, comment in ipairs(thread.comments) do
					if comment.pending and comment.mine then
						comment.pending = false
					end
				end
			end
			done(nil)
		end)
	end
	if session.pending_review_id then
		submit(session.pending_review_id)
		return
	end
	gh.create_pending_review(session.repo, pr, function(review_id, err)
		if err or not review_id then
			return done(err or "could not create review")
		end
		submit(review_id)
	end)
end

--- Retry `process()` after an exponentially growing delay.
local function schedule_retry()
	local opts = config.options.retry_seconds
	retry_delay = math.min((retry_delay or (opts.min / 2)) * 2, opts.max)
	if retry_timer then
		retry_timer:stop()
		retry_timer:close()
		retry_timer = nil
	end
	local timer = vim.uv.new_timer()
	if not timer then
		return
	end
	retry_timer = timer
	timer:start(math.floor(retry_delay * 1000), 0, function()
		vim.schedule(function()
			if retry_timer == timer then
				retry_timer = nil
			end
			timer:close()
			M.process()
		end)
	end)
end

---@param session JjGhReviewSession
local function drained(session)
	retry_delay = nil
	state.set_phase("ready", nil)
	persist(session)
	if M.on_drained then
		M.on_drained()
	end
end

--- Push queued ops to GitHub, one at a time, in order.
function M.process()
	local session = state.session
	if running or not session or not session.pr or not session.pr.id then
		return
	end
	if #session.queue == 0 then
		return
	end
	running = true
	state.set_phase("syncing", string.format("%d queued", #session.queue))

	--- Execute the head of the queue, then recurse.
	local function step()
		local op = session.queue[1]
		local still_active = state.is_active(session)
		if not op or not still_active then
			running = false
			if still_active then
				drained(session)
			end
			return
		end
		local executor = executors[op.kind]
		if not executor then
			table.remove(session.queue, 1)
			step()
			return
		end
		executor(session, op, function(err)
			if not state.is_active(session) then
				running = false
				return
			end
			if err then
				running = false
				op.error = err
				op.attempts = (op.attempts or 0) + 1
				persist(session)
				state.set_error(string.format("%s failed: %s", op.kind, err))
				util.notify(string.format("Sync of %s failed (will retry): %s", op.kind, err), vim.log.levels.WARN)
				schedule_retry()
				return
			end
			table.remove(session.queue, 1)
			persist(session)
			state.set_phase("syncing", string.format("%d queued", #session.queue))
			step()
		end)
	end
	step()
end

--- Append an op and start pushing. Callers apply the optimistic local change.
---@param op JjGhReviewOp
function M.enqueue(op)
	local session = state.session
	if not session then
		return
	end
	op.queued_at = util.now_iso()
	table.insert(session.queue, op)
	persist(session)
	state.changed()
	M.process()
end

--- Drop queued ops that have failed at least once.
---@return integer dropped
function M.drop_failed()
	local session = state.session
	if not session then
		return 0
	end
	local kept, dropped = {}, 0
	for _, op in ipairs(session.queue) do
		if op.error then
			dropped = dropped + 1
		else
			table.insert(kept, op)
		end
	end
	session.queue = kept
	persist(session)
	state.changed()
	return dropped
end

--- Run queued ops now (also resets the backoff).
function M.sync()
	retry_delay = nil
	M.process()
end

------------------------------------------------------------------------------
-- Optimistic local mutations (each applies immediately, then enqueues).
------------------------------------------------------------------------------

---@param session JjGhReviewSession
---@param body string
---@return JjGhReviewComment
local function new_local_comment(session, body)
	return {
		id = "local:" .. util.uuid(),
		body = body,
		author = session.viewer or "me",
		created_at = util.now_iso(),
		pending = config.options.use_pending_review,
		mine = true,
		syncing = true,
	}
end

---@class JjGhReviewNewThreadTarget
---@field path string
---@field body string
---@field line integer
---@field start_line integer|nil
---@field side "LEFT"|"RIGHT"|nil
---@field start_side "LEFT"|"RIGHT"|nil

--- Create a new thread locally and queue its creation.
---@param target JjGhReviewNewThreadTarget
---@return JjGhReviewThread|nil
function M.add_thread(target)
	local session = state.session
	if not session then
		return nil
	end
	local comment = new_local_comment(session, target.body)
	---@type JjGhReviewThread
	local thread = {
		id = "local:" .. util.uuid(),
		path = target.path,
		line = target.line,
		start_line = target.start_line or target.line,
		side = target.side or "RIGHT",
		start_side = target.start_side,
		resolved = false,
		outdated = false,
		comments = { comment },
		syncing = true,
	}
	table.insert(session.threads, thread)
	M.enqueue({
		kind = "add_thread",
		local_id = thread.id,
		path = thread.path,
		body = target.body,
		line = thread.line,
		start_line = thread.start_line ~= thread.line and thread.start_line or nil,
		side = thread.side,
		start_side = thread.start_side,
	})
	return thread
end

--- Reply to a thread locally and queue the reply.
---@param thread JjGhReviewThread
---@param body string
---@return JjGhReviewComment|nil
function M.reply(thread, body)
	local session = state.session
	if not session then
		return nil
	end
	local comment = new_local_comment(session, body)
	table.insert(thread.comments, comment)
	M.enqueue({ kind = "reply", thread_id = thread.id, local_id = comment.id, body = body })
	return comment
end

--- Edit a comment body locally and queue the edit.
---@param comment JjGhReviewComment
---@param body string
function M.edit(comment, body)
	comment.body = body
	comment.updated_at = util.now_iso()
	comment.syncing = true
	M.enqueue({ kind = "edit", comment_id = comment.id, body = body })
end

--- Delete a comment locally (and its thread when it was the last one) and queue the deletion.
---@param comment JjGhReviewComment
function M.delete(comment)
	local session = state.session
	if not session then
		return
	end
	local _, thread, index = state.find_comment(comment.id)
	if thread and index then
		table.remove(thread.comments, index)
		if #thread.comments == 0 then
			for i, candidate in ipairs(session.threads) do
				if candidate == thread then
					table.remove(session.threads, i)
					break
				end
			end
		end
	end
	M.enqueue({ kind = "delete", comment_id = comment.id })
end

--- Resolve/unresolve a thread locally and queue it.
---@param thread JjGhReviewThread
---@param resolved boolean
function M.set_resolved(thread, resolved)
	thread.resolved = resolved
	thread.syncing = true
	M.enqueue({ kind = "resolve", thread_id = thread.id, resolved = resolved })
end

--- Queue submission of the pending review.
---@param event "COMMENT"|"APPROVE"|"REQUEST_CHANGES"
---@param body string|nil
function M.submit(event, body)
	M.enqueue({ kind = "submit", event = event, body = body })
end

return M
