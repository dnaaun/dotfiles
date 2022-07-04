M = {
	_bound_funcs = {},
}

-- String related
local str = {}
M.str = str

--- For example,
---   times("hi", 3) === "hihihi"
---@param s string
---@param times number
---@returns string
function str.times(s, times)
	local res = ""
	while times > 0 do
		res = res .. s
		times = times - 1
	end
	return res
end

---@param del string
---@param array string[]
---@return string
function str.concat(del, array)
	local res = ""
	local i = 1
	while array[i] ~= nil do
		res = res .. del .. array[i]
		i = i + 1
	end
	return res
end

--- @param txt string
function str.first_to_upper(txt)
	return (txt:gsub("^%l", string.upper))
end

local next_functionname = "a"

---@returns string
local get_next_functionname = function()
	local to_return = next_functionname
	-- Update next_functionname
	local last_ltr = next_functionname:gmatch(".$")()
	if last_ltr == "z" then
		next_functionname = str.times("a", next_functionname:len() + 1)
	else
		local next_lastltr = string.char(last_ltr:byte() + 1)
		next_functionname = next_functionname.gsub(next_functionname, ".$", "") .. next_lastltr
	end
	return to_return
end

-- https://stackoverflow.com/a/21419777
local package_name, _ = ...

---@param mode string
---@param keys string
---@param function_ fun():nil
---@param buf_only boolean
---@param name string | nil
local function _mapfunc(mode, keys, function_, opts, buf_only, name)
	opts = opts or {}
	if buf_only then
		opts = vim.tbl_extend("force", {}, opts, { buffer = true })
	end
	-- print("function_, " .. vim.inspect(function_))
	-- print("mode, " .. vim.inspect(mode))
	-- print("keys, " .. vim.inspect(keys))
	-- print("opts, " .. vim.inspect(opts))
	-- print("buf_only, " .. vim.inspect(buf_only))
	if function_ then
		vim.keymap.set(mode, keys, function_, opts)
	end

	-- This broke on March 30-ish, 2022, after a :PackerUpdate, so I'm using the
	-- newly added vim.keymap, which doesn't show function names in which-key, but
	-- oh well.
	-- local funcname = ((name and (name .. " | ")) or "") .. get_next_functionname()
	-- M._bound_funcs[funcname] = function_
	-- local fmt_string = "<cmd>lua require('%s')._bound_funcs['%s']()<CR>"
	-- if buf_only then
	--   vim.api.nvim_buf_set_keymap(0, mode, keys, fmt_string:format(package_name, funcname), opts)
	-- else
	--   vim.api.nvim_set_keymap(mode, keys, fmt_string:format(package_name, funcname), opts)
	-- end
end

---@param mode string
---@param keys string
---@param function_ fun():nil
---@param name string | nil
function M.mapfunc(mode, keys, function_, opts, name)
	_mapfunc(mode, keys, function_, opts, false, name)
end

---@param mode string
---@param keys string
---@param function_ fun():nil
---@param name string | nil
function M.buf_mapfunc(mode, keys, function_, opts, name)
	return _mapfunc(mode, keys, function_, opts, true, name)
end

---@param buffer number
---@return string[]
function M.get_visual_selection_text(buffer)
	local beg_col, beg_row, end_col, end_row
	_, beg_row, beg_col, _ = unpack(vim.fn.getpos("v")) -- :help line()
	_, end_row, end_col, _ = unpack(vim.fn.getpos(".")) -- :help line()

	return M.get_text_in_range(buffer, beg_row - 1, beg_col - 1, end_row, end_col)
end

---@param buffer number
---@param beg_row number Zero indexed, exclusive.
---@param beg_col number Zero indexed, inclusive.
---@param end_row number Zero indexed, exclusive.
---@param end_col number Zero indexed, exclusive.
---@return string[]
function M.get_text_in_range(buffer, beg_row, beg_col, end_row, end_col)
	---@type string[]
	local lines = vim.api.nvim_buf_get_lines(buffer, beg_row, end_row, false)
	if #lines > 0 then
		lines[1] = lines[1]:sub(beg_col + 1, -1)
		lines[#lines] = lines[#lines]:sub(1, end_col)
	end
	return lines
end

--@param table_ any named table_ cuz I dunno if table is  a reserved keyword
--@param value name of value to remove from table
function M.remove_value(table_, value)
	local new_table = {}
	for k, v in pairs(table_) do
		if v ~= value then
			new_table[k] = v
		end
	end
	return new_table
end

--@param table_ any[]
--@param another_table any[]
function M.list_concat(table_, another_table)
	return vim.list_extend(vim.list_extend({}, table_), another_table)
end

-- @param mod string The module name to require
function M.try_require(mod)
	local status, err = pcall(function()
		return require(mod)
	end)
	if not status then
		print("Couldn't require " .. mod .. " because of: " .. err)
		return false
	end
end

---@generic T
---@param list T[]
---@param func fun(t: T) -> boolean
---@return T[]
function M.list_filter(list, func)
	local new_list = {}
	for i = 1, #list do
		local item = list[i]
		if func(item) then
			new_list[#new_list + 1] = item
		end
	end

	return new_list
end

return M
