jsx_prettier = function()
  return {
    exe = "prettier",
    args = {"--parser", "babel", "--stdin-filepath", vim.api.nvim_buf_get_name(0), '--single-quote'},
    stdin = true
  }
end

local filetype = {}
filetype['javascript'] =  {
      function()
        return {
          exe = "prettier",
          args = {"--parser", "babel", "--stdin-filepath", vim.api.nvim_buf_get_name(0), '--single-quote'},
          stdin = true
        }
      end
    }
filetype['python'] = {
    function()
        return {
            exe = "black",
            stdin = false
        }
    end
}
filetype['sql'] = {
	function()
	return {
	exe = "pgformatter",
	args = {"-"},
	stdin = true
	}
	end
}

filetype['json'] = {
    function()
        return {
            exe = "jq",
            args = {"."},
            stdin = true
        }
    end
}

filetype['tex'] = {
  function()
    return {
      exe = "latexindent",
      stdin = true
    }
  end
}

filetype['javascript.jsx'] = {jsx_prettier }
filetype['htmldjango'] = {
    function()
        return {
            exe = "djhtml",
            stdin = true
        }
    end
}




require('formatter').setup({
  logging = false,
  filetype = filetype
})


-- Ideas mainly from: https://github.com/neovim/neovim/issues/14680
function Format_range_operator(fmt_line)
  fmt_line = fmt_line or false

  local old_func = vim.go.operatorfunc  -- ERROR: Error executing lua: <path to init.lua>: attampt to index field 'go' (a nil value)
  _G.op_func_formatting = function()
    local start
    local finish

    if fmt_line then
      start = vim.fn.line('.')
      finish = start
    else
      start = vim.api.nvim_buf_get_mark(0, '[')[1]
      finish = vim.api.nvim_buf_get_mark(0, ']')[1]
    end


    require("formatter.format").format("", "", start, finish, false)
    vim.go.operatorfunc = old_func
    _G.op_func_formatting = nil
  end
  vim.go.operatorfunc = 'v:lua.op_func_formatting'
  vim.api.nvim_feedkeys('g@', 'nt', false)
end
vim.api.nvim_set_keymap("n", "gq", "<cmd>lua Format_range_operator()<CR>", {noremap = true})
vim.api.nvim_set_keymap("v", "gq", "<cmd>lua Format_range_operator()<CR>", {noremap = true})
