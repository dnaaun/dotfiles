local dap = require("dap")
local buf_mapfunc = require("std2").buf_mapfunc
dap.set_log_level("TRACE")

dap.defaults.fallback.terminal_win_cmd = "10split new"

dap.adapters.python = {
  type = "executable",
  command = vim.g.python3_host_prog,
  args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    justMyCode = false,
    name = "Launch file",
    program = "${file}",
    pythonPath = function()
      -- python3_host_prog is set in init.nvim
      return vim.g.python3_host_prog
    end,
  },
}

_G.djangoDapConfig = {
  type = "python",
  request = "launch",
  name = "Django application",
  program = "${workspaceFolder}/manage.py",
  args = { "runserver", "--noreload" },
  -- console = "integratedTerminal";
  django = true,
  autoReload = {
    enable = true,
  },
  pythonPath = function()
    return vim.g.python3_host_prog
  end,
}

vim.api.nvim_set_keymap("n", "<leader>dj", "<cmd>lua require'dap'.run(_G.djangoDapConfig)<CR>", {})
-- This mapping is probably the one most likely used, so it gets the most ergonomic
-- mapping

vim.api.nvim_set_keymap("n", "<leader>dc", "<cmd>lua require'dap'.continue()<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>dh", "<cmd>lua require('dap.ui.widgets').hover()<CR>", { silent = true })
vim.api.nvim_set_keymap("v", "<leader>dh", "<cmd>lua require('dap.ui.widgets').hover()<CR>", { silent = true })

buf_mapfunc("n", "<leader>dd", function()
  dap.close();
  dap.disconnect()
end, { silent = true })
vim.api.nvim_set_keymap("n", "<leader>dp", "<cmd>lua require'dap'.pause()<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>dv", "<cmd>lua require'dap'.step_over()<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>di", "<cmd>lua require'dap'.step_into()<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>do", "<cmd>lua require'dap'.step_out()<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { silent = true })
vim.api.nvim_set_keymap(
  "n",
  "<leader>dB",
  "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
  { silent = true }
)
vim.api.nvim_set_keymap("n", "<leader>dr", "<cmd>lua require'dap'.repl.open()<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<CR>", { silent = true })
