return {
	"mfussenegger/nvim-dap",
	lazy = true,
	keys = {
		"<leader>d",
		-- "<leader>dc",
		-- "<leader>db",
		-- "<leader>dl",
		-- "<leader>do",
		-- "<leader>di",
		-- "<leader>ds",
		-- "<leader>dt",
		-- "<leader>dv",
		-- "<leader>de",
		-- "<leader>dn",
		-- "<leader>da",
		-- "<leader>dr",
		-- "<leader>dja",
		-- "<leader>djt",
		-- "<leader>dh",
	},
	dependencies = { "folke/which-key.nvim" },
	ft = require("consts").dap_enabled_filetypes,
	config = function()
		local dap = require("dap")

		dap.defaults.fallback.terminal_win_cmd = "10split new"

		-- 💀 Adjust the path to your executable
		local cmd = "/Users/davidat/src/codelldb-aarch64-darwin/extension/adapter/codelldb"

		-- https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(via--codelldb)#autolaunch-codelldb
		dap.adapters.codelldb = function(on_adapter)
			-- This asks the system for a free port
			local tcp = vim.loop.new_tcp()
			tcp:bind("127.0.0.1", 0)
			local port = tcp:getsockname().port
			tcp:shutdown()
			tcp:close()

			-- Start codelldb with the port
			local stdout = vim.loop.new_pipe(false)
			local stderr = vim.loop.new_pipe(false)
			local opts = {
				stdio = { nil, stdout, stderr },
				args = { "--port", tostring(port) },
			}
			local handle
			local pid_or_err
			handle, pid_or_err = vim.loop.spawn(cmd, opts, function(code)
				stdout:close()
				stderr:close()
				handle:close()
				if code ~= 0 then
					print("codelldb exited with code", code)
				end
			end)
			if not handle then
				vim.notify("Error running codelldb: " .. tostring(pid_or_err), vim.log.levels.ERROR)
				stdout:close()
				stderr:close()
				return
			end
			vim.notify("codelldb started. pid=" .. pid_or_err)
			stderr:read_start(function(err, chunk)
				assert(not err, err)
				if chunk then
					vim.schedule(function()
						require("dap.repl").append(chunk)
					end)
				end
			end)
			local adapter = {
				type = "server",
				host = "127.0.0.1",
				port = port,
			}
			-- 💀
			-- Wait for codelldb to get ready and start listening before telling nvim-dap to connect
			-- If you get connect errors, try to increase 500 to a higher value, or check the stderr (Open the REPL)
			vim.defer_fn(function()
				on_adapter(adapter)
			end, 500)
		end

		dap.configurations.rust = {
			{
				name = "Launch file",
				type = "codelldb",
				request = "launch",
				program = "${workspaceFolder}/target/debug/${workspaceFolderBasename}",
				args = function()
					local Path = require("plenary.path")
					local path = Path.path

					local cur_dir = vim.fn.getcwd()

					-- A file that contains one per line the arguments to pass as args to the debugged binary
					local NVIM_DAP_RUST_ARGS_BASENAME = ".nvim_dap_rust_args"

					local args_filename = Path:new(cur_dir, NVIM_DAP_RUST_ARGS_BASENAME)
					local abs = args_filename:absolute()
					if not args_filename:exists() then
						P("Didn't find " .. abs .. ". Passing no args.")
						return {}
					end

					local file = io.open(abs, "r")

					if not file then
						P("Couldn't open file " .. abs .. ". Passing no args.")
						return {}
					end

					local content = file:read("*a")

					local args = vim.fn.split(content, "\\n", false)
					P(args)

					return args
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = true,
			},
		}

		-- Rust/C/C++
		-- dap.adapters.lldb = {
		-- 	type = "executable",
		-- 	command = "/Users/davidat/src/codelldb/extension/lldb/bin/lldb", -- adjust as needed
		-- 	name = "lldb",
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
		dap.adapters.dart = {
			type = "executable",
			command = "flutter",
			args = { "debug_adapter" },
		}

		dap.configurations.dart = {
			{
				type = "dart",
				request = "launch",
				name = "launch flutter",
				dartsdkpath = "/Users/davidat/src/flutter/bin/cache/dart-sdk",
				fluttersdkpath = "/Users/davidat/src/flutter/",
				program = "lib/main.dart",
				-- device = "emulator-5554",
				-- toolArgs = { "-d", "emulator-5554" },
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

		local wk = require("which-key")

		-- method 3
		wk.add({
			{
				"<leader>dr",
				function()
					require("dap").restart()
				end,
				desc = "restart",
				group = "+dap (debugging)",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
					require("dapui").open()
				end,
				desc = "continue",
				group = "+dap (debugging)",
			},
			{
				"<leader>dh",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "hover info from DAP",
			},
			{ "<leader>dp", require("dap").pause, desc = "pause debugging" },
			{
				"<leader>dd",
				function()
					dap.close()
					dap.disconnect()
					require("dapui").close()
				end,
				desc = "stop debugging",
			},
			{ "<leader>du", require("dap").up, desc = "go up in stack frame without stepping" },
			{
				"<leader>dl",
				require("dap").down,
				desc = "go lower (down) in stack frame without stepping",
			},
			{ ".", require("dap").up, desc = "run until cursor" },
			{ "<leader>dv", require("dap").step_over, desc = "step over debugger" },
			{ "<leader>di", require("dap").step_into, desc = "step into debugger" },
			{ "<leader>do", require("dap").step_out, desc = "step out debugger" },
			{ "<leader>db", require("dap").toggle_breakpoint, desc = "toggle breakpoint" },
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "set conditional breakpoint",
			},
			{ "<leader>dr", require("dap").repl.open, desc = "toggle debugger repl" },
		})

		local mapfunc = require("std2").mapfunc
		mapfunc("v", "<leader>dr", function()
			require("dap.repl").evaluate(require("std2").get_visual_selection_text(0))
		end, { silent = true }, "run visual text in debugger repl")

		mapfunc("v", "<leader>dh", function()
			require("dap.ui.widgets").hover()
		end, { silent = true }, "hover info from DAP")
	end,
}
