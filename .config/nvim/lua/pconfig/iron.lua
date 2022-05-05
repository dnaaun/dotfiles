local node = {
	node = {
		command = { "node" },
	},
}

return {
	"hkupty/iron.nvim",
	ft = { "python", "ruby", "javascript", "javascriptreact", "typescript", "typescriptreact" },
	setup = function()
		-- Disable default mappings
		vim.g.iron_map_defaults = true
	end,
	config = function()
		local iron = require("iron")

		-- The function is called `t` for `termcodes`.
		-- You don't have to call it that, but I find the terseness convenient
		local function t(str)
			-- Adjust boolean arguments as needed
			return vim.api.nvim_replace_termcodes(str, true, true, true)
		end

		iron.core.add_repl_definitions({
			typescriptreact = {
        node = { command = { "node" } }
      },
			typescript = {
        node = { command = { "node" } }
      },
			javascriptreact = {
        node = { command = { "node" } }
      },
			javascript = {
        node = { command = { "node" } }
      },
			python = {
				ipython = {
					command = { "ipython" },
					-- You know where I found out how to pass ANSI control sequences like below to
					-- neovim's terminal?
					-- On a reply, to a comment, on a PR: https://github.com/neovim/neovim/pull/12080#discussion_r546579388
					-- The ANSI control sequence is bracketed paste mode.
					open = t("\x1b[200~"),
					close = t("\x1b[201~"),
				},
				-- ptpython = {
				--   command = {"ptpython"},
				--   -- You know where I found out how to pass ANSI control sequences like below to
				--   -- neovim's terminal?
				--   -- On a reply, to a comment, on a PR: https://github.com/neovim/neovim/pull/12080#discussion_r546579388
				--   -- Also, the <esc>i is because PtPython has it's own vim mode that I use.
				--   -- The ANSI control sequence is bracketed paste mode.
				--   open = t("<esc>i\x1b[200~"),
				--   close = t("\x1b[201~")
				-- },
				-- ptpython = {
				--   command = {"python", "manage.py", "shell_plus", "--ptpython"},
				--   -- You know where I found out how to pass ANSI control sequences like below to
				--   -- neovim's terminal?
				--   -- On a reply, to a comment, on a PR: https://github.com/neovim/neovim/pull/12080#discussion_r546579388
				--   -- Also, the <esc>i is because PtPython has it's own vim mode that I use.
				--   -- The ANSI control sequence is bracketed paste mode.
				--   open = t("<esc>i\x1b[200~"),
				--   close = t("\x1b[201~")
				-- },
				-- django_ptpython = {
				-- 	command = { "python", "manage.py", "shell_plus", "--ptpython" },
				-- 	-- You know where I found out how to pass ANSI control sequences like below to
				-- 	-- neovim's terminal?
				-- 	-- On a reply, to a comment, on a PR: https://github.com/neovim/neovim/pull/12080#discussion_r546579388
				-- 	open = t("\x1b[200~"),
				-- 	close = t("\x1b[201~"),
				-- },
			},
		})

		iron.core.add_repl_definitions({
			sql = {
				pgcli = {
					command = { "pgcli", "-u", "terra" },
					-- You know where I found out how to pass ANSI control sequences like below to
					-- neovim's terminal?
					-- On a reply, to a comment, on a PR: https://github.com/neovim/neovim/pull/12080#discussion_r546579388
					-- Also, the <esc>i is because PtPython has it's own vim mode that I use.
					-- The ANSI control sequence is bracketed paste mode.
					open = t("<esc>i\x1b[200~"),
					close = t("\x1b[201~"),
				},
			},
			ruby = {
				rails = {
					command = { "bundle", "exec", "rails", "console" },
					-- You know where I found out how to pass ANSI control sequences like below to
					-- neovim's terminal?
					-- On a reply, to a comment, on a PR: https://github.com/neovim/neovim/pull/12080#discussion_r546579388
					-- Also, the <esc>i is because PtPython has it's own vim mode that I use.
					-- The ANSI control sequence is bracketed paste mode.
					open = t("<esc>i\x1b[200~"),
					close = t("\x1b[201~"),
				},
			},
		})
		iron.core.set_config({
			preferred = {
				python = "ipython",
				ruby = "rails",
				javascriptreact = "node",
				javascript = "node",
				typescriptreact = "node",
				typescript = "node",
			},
			repl_open_cmd = "vertical vsplit new",
			visibility = "focus",
		})

		vim.api.nvim_set_keymap("n", "<leader>ro", ":IronRepl<CR>", {})
		vim.api.nvim_set_keymap("n", "<leader>r", "<Plug>(iron-send-motion)", {})
		vim.api.nvim_set_keymap("n", "<leader>rr", "<Plug>(iron-send-lines)", {})
		vim.api.nvim_set_keymap("v", "<leader>r", "<Plug>(iron-visual-send)", {})
		vim.api.nvim_set_keymap("n", "<leader>ri", "<Plug>(iron-interrupt)", {})
		vim.api.nvim_set_keymap("n", "<leader>rl", "<Plug>(iron-clear)", {})
		vim.api.nvim_set_keymap(
			"n",
			"<leader>re",
			'<Cmd>lua require("iron").core.send(vim.api.nvim_buf_get_option(0,"ft"), vim.api.nvim_buf_get_lines(0, 0, -1, false))<CR>',
			{}
		)
	end,
}
