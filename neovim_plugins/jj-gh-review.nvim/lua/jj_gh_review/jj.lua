--- Working-copy preparation: `jj new <pr head>` (fetching the branch first if
--- the commit is unknown locally) and then the configured diffview command,
--- with `{base}` replaced by the commit GitHub diffs the PR against.
local config = require("jj_gh_review.config")
local state = require("jj_gh_review.state")
local util = require("jj_gh_review.util")

local M = {}

---@param repo JjGhReviewRepo
---@param args string[]
---@param callback fun(result: JjGhReviewRunResult)
local function jj(repo, args, callback)
	util.run(vim.list_extend({ "jj" }, args), { cwd = repo.root }, callback)
end

--- Commit id of the single commit `revset` names, or nil when it names none.
---@param repo JjGhReviewRepo
---@param revset string
---@param callback fun(commit_id: string|nil)
local function resolve_commit(repo, revset, callback)
	jj(repo, { "log", "--ignore-working-copy", "--no-graph", "-r", revset, "-T", "commit_id" }, function(result)
		local commit_id = util.trim(result.stdout)
		callback(result.code == 0 and commit_id ~= "" and commit_id or nil)
	end)
end

---@param repo JjGhReviewRepo
---@param branch string
---@param callback fun(err: string|nil)
local function fetch_branch(repo, branch, callback)
	jj(repo, { "git", "fetch", "--branch", branch }, function(result)
		if result.code ~= 0 then
			callback(util.command_error("jj git fetch", result))
			return
		end
		callback(nil)
	end)
end

--- Make sure `commit` exists locally, fetching `branch` when it doesn't.
---@param repo JjGhReviewRepo
---@param commit string
---@param branch string
---@param callback fun(err: string|nil)
local function ensure_commit(repo, commit, branch, callback)
	resolve_commit(repo, commit, function(found)
		if found then
			callback(nil)
			return
		end
		state.set_phase("preparing", "jj git fetch --branch " .. branch)
		fetch_branch(repo, branch, function(err)
			if err then
				callback(err)
				return
			end
			resolve_commit(repo, commit, function(found_now)
				if found_now then
					callback(nil)
				else
					callback("commit " .. commit:sub(1, 12) .. " not found after fetching " .. branch)
				end
			end)
		end)
	end)
end

--- Is the working copy already an empty change directly on top of `commit`?
---@param repo JjGhReviewRepo
---@param commit string
---@param callback fun(on_top: boolean)
local function already_on_top(repo, commit, callback)
	jj(repo, {
		"log",
		"--ignore-working-copy",
		"--no-graph",
		"-r",
		"@",
		"-T",
		'if(empty, "empty", "nonempty") ++ " " ++ parents.map(|p| p.commit_id()).join(" ")',
	}, function(result)
		if result.code ~= 0 then
			callback(false)
			return
		end
		local out = util.trim(result.stdout)
		local empty, parents = out:match("^(%S+)%s*(.*)$")
		callback(empty == "empty" and parents ~= nil and parents:find(commit, 1, true) ~= nil)
	end)
end

---@param repo JjGhReviewRepo
---@param commit string
---@param callback fun(err: string|nil)
local function jj_new(repo, commit, callback)
	jj(repo, { "new", commit }, function(result)
		if result.code ~= 0 then
			callback(util.command_error("jj new", result))
			return
		end
		vim.cmd("checktime")
		callback(nil)
	end)
end

--- The configured diffview command with `{base}` replaced by the commit GitHub
--- diffs the PR against: the fork point of the PR's base and head, which is the
--- base branch tip unless that moved on since the head was last rebased.
---@param session JjGhReviewSession
---@param callback fun(cmd: string|nil, err: string|nil)
local function diffview_command(session, callback)
	local cmd = config.options.diffview_cmd
	if not cmd or cmd == "" then
		callback(nil)
		return
	end
	if not cmd:find("{base}", 1, true) then
		callback(cmd)
		return
	end
	local pr, repo = session.pr, session.repo
	if not pr or not pr.baseRefOid or not pr.headRefOid then
		callback(nil, "PR base/head commit unknown")
		return
	end
	ensure_commit(repo, pr.headRefOid, pr.headRefName, function(head_err)
		if head_err then
			callback(nil, head_err)
			return
		end
		ensure_commit(repo, pr.baseRefOid, pr.baseRefName, function(base_err)
			if base_err then
				callback(nil, base_err)
				return
			end
			local revset = string.format("fork_point(%s | %s)", pr.baseRefOid, pr.headRefOid)
			resolve_commit(repo, revset, function(base)
				if not base then
					callback(nil, "could not resolve " .. revset)
					return
				end
				callback((cmd:gsub("{base}", base)))
			end)
		end)
	end)
end

--- Run the configured diffview command, if the command exists.
---@param session JjGhReviewSession
---@param callback fun()
local function open_diffview(session, callback)
	diffview_command(session, function(cmd, err)
		if err then
			util.notify("Not opening a diff view: " .. err, vim.log.levels.WARN)
		end
		if not cmd or not state.is_active(session) then
			callback()
			return
		end
		local name = cmd:match("^%s*(%S+)")
		if not name or vim.fn.exists(":" .. name) ~= 2 then
			util.notify(
				"Command :" .. tostring(name) .. " is not available; not opening a diff view",
				vim.log.levels.WARN
			)
		else
			local ok, exec_err = pcall(vim.api.nvim_exec2, cmd, {})
			if not ok then
				util.notify("Failed to run " .. cmd .. ": " .. tostring(exec_err), vim.log.levels.ERROR)
			end
		end
		callback()
	end)
end

--- Make the working copy an empty change on top of the PR head, then open the
--- diff view once per session. `callback(err)` runs when done.
---@param session JjGhReviewSession
---@param callback? fun(err: string|nil)
function M.prepare(session, callback)
	local done = callback or function() end
	local pr, repo = session.pr, session.repo
	if not pr or not pr.headRefOid then
		done("no PR head known yet")
		return
	end
	local head = pr.headRefOid

	---@param err string|nil
	local function finish(err)
		if err then
			state.set_error(err)
			util.notify(err, vim.log.levels.ERROR)
			done(err)
			return
		end
		session.prepared_head = head
		--- Leave the "preparing" phase and hand control back to the caller.
		local function ready()
			if session.phase == "preparing" then
				state.set_phase("ready", nil)
			end
			done(nil)
		end
		if session.diffview_opened then
			ready()
			return
		end
		session.diffview_opened = true
		open_diffview(session, ready)
	end

	if not config.options.jj_new then
		finish(nil)
		return
	end
	if session.prepared_head == head then
		finish(nil)
		return
	end

	state.set_phase("preparing", "jj new " .. head:sub(1, 8))

	ensure_commit(repo, head, pr.headRefName, function(err)
		if err then
			finish(err)
			return
		end
		already_on_top(repo, head, function(on_top)
			if on_top then
				finish(nil)
				return
			end
			jj_new(repo, head, finish)
		end)
	end)
end

return M
