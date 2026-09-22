local util = require("jj_gh_review.util")

local M = {}

---@class JjGhReviewRepo
---@field root string jj workspace root
---@field git_dir string backing git dir (`jj git root`)

--- Resolve the jj workspace root and the backing git dir for `cwd`. Everything
--- `gh` does runs with GIT_DIR pointed at the latter so it works in jj
--- workspaces that are not colocated with a git checkout.
---@param cwd string|nil
---@param callback fun(repo: JjGhReviewRepo|nil, err: string|nil)
function M.resolve(cwd, callback)
	cwd = cwd or vim.fn.getcwd()
	util.run({ "jj", "root", "--ignore-working-copy" }, { cwd = cwd }, function(root_result)
		if root_result.code ~= 0 then
			callback(nil, util.command_error("jj root", root_result))
			return
		end
		local root = util.trim(root_result.stdout)
		util.run({ "jj", "git", "root", "--ignore-working-copy" }, { cwd = root }, function(git_result)
			if git_result.code ~= 0 then
				callback(nil, util.command_error("jj git root", git_result))
				return
			end
			callback({ root = root, git_dir = util.trim(git_result.stdout) })
		end)
	end)
end

--- Environment for `gh`: inherit everything and point GIT_DIR at the jj git dir.
---@param repo JjGhReviewRepo
---@return table<string, string>
function M.gh_env(repo)
	return vim.tbl_extend("force", vim.fn.environ(), { GIT_DIR = repo.git_dir })
end

return M
