local M = {}

---@param args string[]
---@param opts? vim.SystemOpts
---@return vim.SystemCompleted|nil
local function system_result(args, opts)
	if vim.fn.executable(args[1]) ~= 1 then
		return nil
	end

	---@return vim.SystemCompleted
	local function run_system()
		return vim.system(args, opts):wait()
	end

	local ok, result = pcall(run_system)
	if not ok then
		return nil
	end

	return result
end

---@param args string[]
---@param opts? vim.SystemOpts
---@return string|nil
local function system_stdout(args, opts)
	local result = system_result(args, opts)
	if result == nil or result.code ~= 0 then
		return nil
	end

	return vim.trim(result.stdout or "")
end

---@param args string[]
---@param opts? vim.SystemOpts
---@return boolean|nil
local function git_check_ignore(args, opts)
	local result = system_result(args, opts)
	if result == nil then
		return nil
	end
	if result.code == 0 then
		return true
	end
	if result.code == 1 then
		return false
	end

	return nil
end

---@param path string
---@return boolean
function M.git_ignored(path)
	local jj_root = system_stdout({ "jj", "root", "--ignore-working-copy" }, { cwd = path })
	local jj_git_root = system_stdout({ "jj", "git", "root", "--ignore-working-copy" }, { cwd = path })
	if jj_root ~= nil and jj_git_root ~= nil then
		local ignored = git_check_ignore({
			"git",
			"--git-dir",
			jj_git_root,
			"--work-tree",
			jj_root,
			"check-ignore",
			"-q",
			"--",
			path,
		})
		if ignored ~= nil then
			return ignored
		end
	end

	return git_check_ignore({ "git", "-C", path, "check-ignore", "-q", "--", path }) == true
end

---@return string[]
function M.hidden_arg()
	return { "--hidden" }
end

---@param include_ignored boolean
---@return string[]
function M.live_grep_args(include_ignored)
	local args = M.hidden_arg()
	if include_ignored then
		args[#args + 1] = "--no-ignore"
	end

	return args
end

---@param dir string
---@param opts? table
---@return table
function M.fd_opts(dir, opts)
	local include_ignored = M.git_ignored(dir)
	return vim.tbl_extend("force", {
		search_dirs = { dir },
		hidden = true,
		no_ignore = include_ignored,
		no_ignore_parent = include_ignored,
	}, opts or {})
end

---@param dir string
---@param opts? table
---@return table
function M.live_grep_opts(dir, opts)
	local include_ignored = M.git_ignored(dir)

	---@return string[]
	local function additional_args()
		return M.live_grep_args(include_ignored)
	end

	return vim.tbl_extend("force", {
		search_dirs = { dir },
		additional_args = additional_args,
	}, opts or {})
end

return M
