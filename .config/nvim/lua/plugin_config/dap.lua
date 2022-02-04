local dap = require("dap")
local std2 = require("std2")
local buf_mapfunc = require("std2").buf_mapfunc
dap.set_log_level("TRACE")

dap.defaults.fallback.terminal_win_cmd = "10split new"

-- Rust/C/C++
local dap = require('dap')
dap.adapters.lldb = {
  type = 'executable',
  command = 'lldb-vscode-11', -- adjust as needed
  name = "lldb"
}

local dap = require('dap')
dap.configurations.rust = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      local cwd = vim.fn.getcwd() 
      local beg, end_ = vim.regex('[^/]*$'):match_str(cwd)
      local exec_name = cwd:sub(beg, end_) -- Aint nobody got time to parse Cargo.toml.
      return cwd .. '/target/debug/' .. exec_name
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},

    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    runInTerminal = false,
  },
}

--- Rails
local dap = require('dap')
dap.adapters.ruby = {
  type = 'executable';
  command = 'readapt';
  args = {'stdio'};
}

dap.configurations.ruby = {
  {
    type = 'ruby';
    request = 'launch';
    name = 'Rails';
    program = 'bundle';
    programArgs = {'exec', 'puma', 't', '1:1', '-w', '0'};
    useBundler = true;
  },
}

-- Python
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
    program = function()
      return vim.fn.expand('%')
    end,
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

-- Run django: manage.py test
_G.djangoTestDapConfig = {
  type = "python",
  request = "launch",
  name = "Django tests",
  program = "${workspaceFolder}/manage.py",
  args = { "test", "--keepdb" },
  -- console = "integratedTerminal";
  autoReload = {
    enable = false,
  },
  pythonPath = function()
    return vim.g.python3_host_prog
  end,
}

mapfunc("n", "<leader>dja", function()
  require("dap").run(_G.djangoDapConfig)
end, {}, "Debug django application")
mapfunc("n", "<leader>djt", function()
  require("dap").run(_G.djangoTestDapConfig)
end, {}, "Debug django tests")
mapfunc("n", "<leader>dc", function()
  require("dap").continue()
end, { silent = true }, "continue debugging")
mapfunc("n", "<leader>dh", function()
  require("dap.ui.widgets").hover()
end, { silent = true }, "hover info from DAP")
mapfunc("v", "<leader>dh", function()
  require("dap.ui.widgets").hover()
end, { silent = true }, "hover info from DAP")
buf_mapfunc("n", "<leader>dd", function()
  dap.close()
  dap.disconnect()
  require("dapui").close()
end, { silent = true }, "stop debugging")
mapfunc("n", "<leader>dp", function()
  require("dap").pause()
end, { silent = true }, "pause debugging")
mapfunc("n", "<leader>du", function()
  require("dap").up()
end, { silent = true }, "go up in stack frame without stepping")
mapfunc("n", "<leader>dl", function()
  require("dap").up()
end, { silent = true }, "go lower (down) in stack frame without stepping")
mapfunc("n", "<leader>d.", function()
  require("dap").up()
end, { silent = true }, "run until cursor")
mapfunc("n", "<leader>dv", function()
  require("dap").step_over()
end, { silent = true }, "step over debugger")
mapfunc("n", "<leader>di", function()
  require("dap").step_into()
end, { silent = true }, "step into debugger")
mapfunc("n", "<leader>do", function()
  require("dap").step_out()
end, { silent = true }, "step out debugger")
mapfunc("n", "<leader>db", function()
  require("dap").toggle_breakpoint()
end, { silent = true }, "toggle breakpoint")
mapfunc("n", "<leader>dB", function()
  require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, {
  silent = true,
}, "set conditional breakpoint")
mapfunc("n", "<leader>dr", function()
  require("dap").repl.open()
end, { silent = true }, "toggle debugger repl")


mapfunc("v", "<leader>dr", function()
  require("dap.repl").evaluate(std2.get_visual_selection_text(0))
end, {
  silent = true,
}, "run visual text in debugger repl")


