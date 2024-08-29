local M = {}

local function capture_text_object()
	local start_pos = vim.fn.getpos("'[")
	local end_pos = vim.fn.getpos("']")
	local lines = vim.fn.getline(start_pos[2], end_pos[2])

	if #lines == 1 then
		lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
	else
		lines[1] = string.sub(lines[1], start_pos[3])
		lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
	end

	local result = table.concat(lines, "\n")
	return result
end

local function_to_invoke = nil

--- @motion_mode - "line" | "char" | "block"
function _G.opfunc(motion_mode)
	content = capture_text_object()
	function_to_invoke(content)
end

M.invoke = function(func)
	if func == nil then
		vim.cmd(
			"echoerr \"Yo, there's some error with hwo you setup `invoke_with_text_from_motion`. `func` Should not be nil."
		)
		return
	end
	function_to_invoke = func
	vim.o.operatorfunc = "v:lua.opfunc"
	vim.api.nvim_feedkeys("g@", "n", false)
	vim.cmd("redraw") -- Force a redraw to ensure the operatorfunc has been executed
end

return M
