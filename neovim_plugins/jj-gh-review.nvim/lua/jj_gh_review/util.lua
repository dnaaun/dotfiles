local M = {}

---@param value any
---@return string
function M.trim(value)
	return (tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

---@param message string
---@param level? integer one of vim.log.levels
function M.notify(message, level)
	vim.schedule(function()
		vim.notify(message, level or vim.log.levels.INFO, { title = "jj-gh-review" })
	end)
end

---@class JjGhReviewRunResult
---@field code integer
---@field stdout string
---@field stderr string

--- Run a command asynchronously; the callback always runs on the main loop.
---@param args string[]
---@param opts? vim.SystemOpts
---@param callback fun(result: JjGhReviewRunResult)
function M.run(args, opts, callback)
	local system_opts = vim.tbl_extend("force", { text = true }, opts or {}) --[[@as vim.SystemOpts]]
	local ok, err = pcall(vim.system, args, system_opts, function(result)
		vim.schedule(function()
			callback({ code = result.code, stdout = result.stdout or "", stderr = result.stderr or "" })
		end)
	end)
	if not ok then
		vim.schedule(function()
			callback({ code = 127, stdout = "", stderr = tostring(err) })
		end)
	end
end

---@param command string
---@param result JjGhReviewRunResult
---@return string
function M.command_error(command, result)
	local details = M.trim(result.stderr)
	if details == "" then
		details = M.trim(result.stdout)
	end
	if details == "" then
		details = "exit code " .. tostring(result.code)
	end
	return command .. " failed: " .. details
end

---@param text string|nil
---@return string
function M.first_line(text)
	return tostring(text or ""):match("^[^\n]*") or ""
end

---@param text string
---@param width integer
---@return string
function M.truncate(text, width)
	if vim.fn.strdisplaywidth(text) <= width then
		return text
	end
	return vim.fn.strcharpart(text, 0, math.max(width - 1, 1)) .. "…"
end

---@param path string
---@return any|nil decoded JSON, or nil when missing/invalid
function M.read_json(path)
	local fd = io.open(path, "r")
	if not fd then
		return nil
	end
	local content = fd:read("*a")
	fd:close()
	local ok, decoded = pcall(vim.json.decode, content)
	if not ok then
		return nil
	end
	return decoded
end

--- Atomic-ish JSON write (write to a temp file, then rename over the target).
---@param path string
---@param value any
---@return boolean
function M.write_json(path, value)
	vim.fn.mkdir(vim.fs.dirname(path), "p")
	local tmp = path .. ".tmp." .. tostring(vim.uv.hrtime())
	local fd = io.open(tmp, "w")
	if not fd then
		return false
	end
	fd:write(vim.json.encode(value))
	fd:close()
	return vim.uv.fs_rename(tmp, path) ~= nil
end

---@return string
function M.uuid()
	return string.format("%x%x", vim.uv.hrtime(), math.random(0, 0xffffff))
end

--- Ids of threads/comments created locally that GitHub doesn't know yet.
---@param id any
---@return boolean
function M.is_local_id(id)
	return type(id) == "string" and vim.startswith(id, "local:")
end

--- Repo-relative path for an absolute path, or nil when outside `root`.
--- Symlinks are resolved on both sides (macOS /var -> /private/var, ~/git links, ...).
---@param root string
---@param abs string
---@return string|nil
function M.relpath(root, abs)
	root = vim.fs.normalize(vim.uv.fs_realpath(root) or root)
	abs = vim.fs.normalize(vim.uv.fs_realpath(abs) or abs)
	if abs == root then
		return ""
	end
	if vim.startswith(abs, root .. "/") then
		return abs:sub(#root + 2)
	end
	return nil
end

--- `2026-09-22T08:45:44Z` -> `2026-09-22 08:45`
---@param iso string|nil
---@return string
function M.format_time(iso)
	if not iso then
		return ""
	end
	return (iso:gsub("T", " "):gsub(":%d%dZ$", ""))
end

---@return string
function M.now_iso()
	return os.date("!%Y-%m-%dT%H:%M:%SZ") --[[@as string]]
end

return M
