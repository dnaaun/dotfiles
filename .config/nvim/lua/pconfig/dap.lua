return {
	"~/git/nvim-dap",
	requires = "folke/which-key.nvim",
	-- ft = require("consts").dap_enabled_filetypes,
	as = "nvim-dap",
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
				program = function()
					return "/Users/davidat/git/highlights/target/debug/highlights"
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
		wk.register({
			["<leader>d"] = {
				name = "+dap (debugging)",
				c = {
					function()
						require("dap").continue()
						-- require("dapui").open()
					end,
					"continue",
				},
				h = {
					function()
						require("dap.ui.widgets").hover()
					end,
					"hover info from DAP",
				},
				p = {
					require("dap").pause,
					"pause debugging",
				},
				d = {
					function()
						dap.close()
						dap.disconnect()
						require("dapui").close()
					end,
					"stop debugging",
				},
				u = {
					require("dap").up,
					"go up in stack frame without stepping",
				},
				l = {
					require("dap").down,
					"go lower (down) in stack frame without stepping",
				},
				["."] = {
					require("dap").up,
					"run until cursor",
				},
				v = {
					require("dap").step_over,
					"step over debugger",
				},
				i = {
					require("dap").step_into,
					"step into debugger",
				},
				o = {
					require("dap").step_out,
					"step out debugger",
				},
				b = {
					require("dap").toggle_breakpoint,
					"toggle breakpoint",
				},
				B = {
					function()
						require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
					end,
					"set conditional breakpoint",
				},
				r = {
					require("dap").repl.open,
					"toggle debugger repl",
				},
			},
		})

		local mapfunc = require("std2").mapfunc
		mapfunc("v", "<leader>dr", function()
			require("dap.repl").evaluate(require("std2").get_visual_selection_text(0))
		end, { silent = true }, "run visual text in debugger repl")

		mapfunc("n", "<leader>dja", function()
			require("dap").run(_G.djangoDapConfig)
		end, {}, "Debug django application")
		mapfunc("n", "<leader>djt", function()
			require("dap").run(_G.djangoTestDapConfig)
		end, {}, "Debug django tests")
		mapfunc("v", "<leader>dh", function()
			require("dap.ui.widgets").hover()
		end, { silent = true }, "hover info from DAP")
	end,
}
