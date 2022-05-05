return {
	"~/git/nvim-dap",
	-- ft = require("consts").dap_enabled_filetypes,
	as = "nvim-dap",
	config = function()
		local dap = require("dap")
		local buf_mapfunc = require("std2").buf_mapfunc
		dap.set_log_level("TRACE")

		dap.defaults.fallback.terminal_win_cmd = "10split new"
		-- INFO: execute ~/Downloads/vscode-extensions/codelldb/extension/adapter/codelldb --port 13000
		dap.adapters.codelldb = {
			type = "server",
			host = "127.0.0.1",
			port = 13000,
		}

		dap.configurations.c = {
			{
				type = "codelldb",
				request = "launch",
				program = function()
				 return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				--program = '${fileDirname}/${fileBasenameNoExtension}',
				cwd = "${workspaceFolder}",
				terminal = "integrated",
			},
		}

		dap.configurations.cpp = dap.configurations.c

		dap.configurations.rust = {
			{
				type = "codelldb",
				request = "launch",
				program = function()
					-- return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          return "/Users/davidat/git/highlights/target/debug/highlights"
				end,
				cwd = "${workspaceFolder}",
				terminal = "integrated",
				sourceLanguages = { "rust" },
			},
		}

		-- Rust/C/C++
		-- dap.adapters.lldb = {
		-- 	type = "executable",
		-- 	command = "/Users/davidat/src/codelldb/extension/lldb/bin/lldb", -- adjust as needed
		-- 	name = "lldb",
		-- }

		-- dap.configurations.rust = {
		-- 	{
		-- 		name = "Launch",
		-- 		type = "lldb",
		-- 		request = "launch",
		-- 		program = function()
		-- 			local cwd = vim.fn.getcwd()
		-- 			local beg, end_ = vim.regex("[^/]*$"):match_str(cwd)
		-- 			local exec_name = cwd:sub(beg, end_) -- Aint nobody got time to parse Cargo.toml.
		-- 			return cwd .. "/target/debug/" .. exec_name
		-- 		end,
		-- 		cwd = "${workspaceFolder}",
		-- 		stopOnEntry = false,
		-- 		args = {},
		-- 		runInTerminal = false,
		-- 	},
		-- }

		--- Rails
		dap.adapters.ruby = {
			type = "executable",
			command = "bundle",
			args = { "exec", "readapt", "stdio" },
		}

		dap.configurations.ruby = {
			{
				type = "ruby",
				request = "launch",
				name = "Rails",
				program = "bundle",
				programArgs = { "exec", "rails", "s" },
				useBundler = true,
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
					return vim.fn.expand("%")
				end,
				pythonPath = function()
					if vim.env.VIRTUAL_ENV then
						local bin_path = vim.env.VIRTUAL_ENV .. "/bin/python"
						if vim.fn.filereadable(bin_path) then
							return bin_path
						end
					end
					return nil
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

		local mapfunc = require("std2").mapfunc

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
			require("dap").down()
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
			require("dap.repl").evaluate(require("std2").get_visual_selection_text(0))
		end, {
			silent = true,
		}, "run visual text in debugger repl")
	end,
}
