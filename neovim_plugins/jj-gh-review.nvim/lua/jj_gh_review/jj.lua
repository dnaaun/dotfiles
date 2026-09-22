--- Working-copy preparation: `jj new <pr head>` (fetching the branch first if
--- the commit is unknown locally) and then the configured diffview command.
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

---@param repo JjGhReviewRepo
---@param commit string
---@param callback fun(exists: boolean)
local function commit_exists(repo, commit, callback)
	jj(repo, { "log", "--ignore-working-copy", "--no-graph", "-r", commit, "-T", "commit_id" }, function(result)
		callback(result.code == 0 and util.trim(result.stdout) ~= "")
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

--- Run the configured diffview command, if the command exists.
local function open_diffview()
	local cmd = config.options.diffview_cmd
	if not cmd or cmd == "" then
		return
	end
	local name = cmd:match("^%s*(%S+)")
	if not name or vim.fn.exists(":" .. name) ~= 2 then
		util.notify("Command :" .. tostring(name) .. " is not available; not opening a diff view", vim.log.levels.WARN)
		return
	end
	local ok, err = pcall(vim.api.nvim_exec2, cmd, {})
	if not ok then
		util.notify("Failed to run " .. cmd .. ": " .. tostring(err), vim.log.levels.ERROR)
	end
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
		else
			session.prepared_head = head
			if not session.diffview_opened then
				session.diffview_opened = true
				open_diffview()
			end
			if session.phase == "preparing" then
				state.set_phase("ready", nil)
			end
		end
		done(err)
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

	---@param cb fun(err: string|nil)
	local function ensure_commit(cb)
		commit_exists(repo, head, function(exists)
			if exists then
				cb(nil)
				return
			end
			state.set_phase("preparing", "jj git fetch --branch " .. pr.headRefName)
			fetch_branch(repo, pr.headRefName, function(err)
				if err then
					cb(err)
					return
				end
				commit_exists(repo, head, function(exists_now)
					if exists_now then
						cb(nil)
					else
						cb("commit " .. head:sub(1, 12) .. " not found after fetching " .. pr.headRefName)
					end
				end)
			end)
		end)
	end

	ensure_commit(function(err)
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
