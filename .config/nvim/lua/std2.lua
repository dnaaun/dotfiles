M = {
  _bound_funcs = {}
}

-- String related
local str = {}

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
function M.mapfunc(mode, keys, function_, opts, buf_only)
  local funcname = get_next_functionname()
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
function M.buf_mapfunc(mode,  keys, function_, opts)
  return M.mapfunc(mode, keys, function_, opts, true)
end


return M
