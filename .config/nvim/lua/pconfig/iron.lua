return {
	"hkupty/iron.nvim",
	setup = function()
		-- Disable default mappings
		vim.g.iron_map_defaults = true
	end,
	config = function()
		local iron = require("iron.core")

		vim.keymap.set("n", "<leader>ro", function()
			iron.repl_for(vim.opt_local.filetype:get())
		end, {})

		vim.keymap.set("n", "<leader>rf", function()
			iron.focus_on(vim.bo.filetype)
		end, {})

		vim.api.nvim_set_keymap(
			"n",
			"<leader>re",
			'<Cmd>lua require("iron").core.send(vim.api.nvim_buf_get_option(0,"ft"), vim.api.nvim_buf_get_lines(0, 0, -1, false))<CR>',
			{}
		)

		iron.setup({
			config = {
				-- I dont have time to rework how the mappings are done
				should_map_plug = false,

				-- whether to create new repls for buffers of same file type if they are
				-- in different tabs/paths/etc. No, don't.
				scope = require("iron.scope").singleton,

				-- Whether the buffers should be scratch buffers
				scratch_repl = false,

				---@param bufnr number
				---@return string
				repl_open_cmd = function(bufnr)
					local width = vim.o.columns
					local height = vim.o.lines

					-- This is how wide I want it to be
					local size = 100

					local winid = vim.api.nvim_open_win(bufnr, false, {
						relative = "editor",
						width = size,
						height = height,
						row = 0,
						col = vim.fn.max({ 0, width - size }),
						zindex = 100,
					})

					-- Set a keymap to hide buffer when inside the repl
					-- Note  how we have a "t" instead of an "i" in the modes.
					vim.keymap.set({ "t", "n" }, "<C-q>", function()
						vim.api.nvim_win_close(0, false)
					end, { buffer = bufnr })

					return winid
				end,

				repl_definition = {
					python = require("iron.fts.python").ipython,
					typescript = require("iron.fts.typescript").ts,
					tsx = require("iron.fts.typescript").ts,
					lua = require("iron.fts.lua").lua,
					ruby = {
						command = { "bundle", "exec", "rails", "console" },
					},
				},
			},

			keymaps = {
				send_motion = "<leader>r",
				visual_send = "<leader>r",
				send_file = "<leader>ra", -- a for all
				send_line = "<leader>rr",
				cr = "<leader>r<cr>",
				interrupt = "<leader>ri",
				exit = "<leader>rq",
				clear = "<leader>rc",
				send_mark = "<leader>r.",
			},
		})
	end,
}
