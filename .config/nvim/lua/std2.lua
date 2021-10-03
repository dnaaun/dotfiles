M = {
  _bound_funcs = {}
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

local next_functionname = "a"

---@returns string
local get_next_functionname = function()
  local to_return = next_functionname
  -- Update next_functionname
  local last_ltr = next_functionname:gmatch('.$')()
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
  local funcname = ((name and (name .. " | ")) or "") .. get_next_functionname()
  M._bound_funcs[funcname] = function_
  local fmt_string = "<cmd>lua require('%s')._bound_funcs['%s']()<CR>"
  if buf_only then
    vim.api.nvim_buf_set_keymap(0, mode, keys, fmt_string:format(package_name, funcname), opts)
  else
    vim.api.nvim_set_keymap(mode, keys, fmt_string:format(package_name, funcname), opts)
  end
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
function M.buf_mapfunc(mode,  keys, function_, opts, name)
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


return M
