return {
	"hkupty/iron.nvim",
	setup = function()
		-- Disable default mappings
		vim.g.iron_map_defaults = false
	end,
	config = function()
		local bracketed_paste = require("iron.fts.common").bracketed_paste
		local iron = require("iron.core")

		local wk = require("which-key")

		wk.register({
			["<leader>r"] = {
				name = "(iron) repl",
				h = {
					function()
						iron.close_repl(vim.opt.filetype:get())
					end,
					"close repl",
				},
				s = {
					name = "send specific keys",
					q = {
						function()
							iron.send(vim.opt.filetype:get(), { "q" })
						end,
						"q",
					},
				},
				f = {
					function()
						iron.focus_on(vim.opt.filetype:get())
					end,
					"focus on repl",
				},
				o = {
					function()
						iron.repl_for(vim.opt.filetype:get())
					end,
					"open repl",
				},
			},
		})

		local rails_console = {
			command = { "bundle", "exec", "rails", "console" },
			format = bracketed_paste			-- local new_lines = vim.list_extend({}, lines)
			-- new_lines[#new_lines] = new_lines[#new_lines] .. ";"
			-- return bracketed_paste(new_lines)
			-- end
, -- function(lines)			-- -- Add semi colons to the end to suppress "print what was returned" output
		}

		-- local irb = {
		-- 	command = { "irb" },
		-- 	format = bracketed_paste,
		-- }

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
						height = height - 2, -- -2 to avoid hiding the status line
						row = 0,
						col = vim.fn.max({ 0, width - size }),
						zindex = 100,
					})

					-- Set a keymap to hide buffer when inside the repl
					-- Note  how we have a "t" instead of an "i" in the modes.
					vim.keymap.set({ "t", "n" }, "<C-q>", function()
						vim.api.nvim_win_close(0, false)
					end, { buffer = bufnr })

					-- Create a buffer local autocmd that deletes the buffer when the terminal
					-- process ends. Otherwise, trying to send text to  a repl for a file type
					-- that I just closed the repl for gives me an error about trying to send data
					-- to a closed stream, while it should simply just start a new repl.
					-- I'd like this behavior for *all* terminal buffers (not just
					-- iron.nvim ones), but that breaks my telescope-git-diff setup:
					-- https://github.com/nvim-telescope/telescope.nvim/issues/1973#issuecomment-1153082196
					vim.api.nvim_create_autocmd({ "TermClose" }, {
						group = vim.api.nvim_create_augroup("IronCloseWinsOnProcessEnd", {}),
						buffer = bufnr,
						desc = "Close a terminal emulator buffer when the process ends",
						callback = function(args)
							vim.api.nvim_buf_delete(args.buf, {})
						end,
					})

					-- Set the timeoutlen to a value that is not zero
					-- (which is what I've set it to in order to render whichkey ASAP).
					-- This is necessary to use a tnoremap to
					-- escape from terminal mode (because which key
					-- doesn't show up in terminal mode, and because the
					-- default keys to escape termianl mode, <C-\><C-n>
					-- are not ergonomic.
					local previous_timeoutlen = 0
					local shadow_timeoutlen = vim.api.nvim_create_augroup("IronShadowTimeoutlen", {})
					vim.api.nvim_create_autocmd({ "TermEnter" }, {
						group = shadow_timeoutlen,
						buffer = bufnr,
						desc = "Save previous timeoutlen and set it to 500",
						callback = function()
							previous_timeoutlen = vim.opt.timeoutlen
							vim.opt.timeoutlen = 500
						end,
					})
					vim.api.nvim_create_autocmd({ "TermLeave" }, {
						group = shadow_timeoutlen,
						buffer = bufnr,
						desc = "Restore previous value of timeoutlen",
						callback = function()
							vim.opt.timeoutlen = previous_timeoutlen
						end,
					})
					vim.keymap.set(
						{ "t" },
						"<Esc><Esc>",
						"<C-\\><C-n>",
						{ desc = "Escape easier from terminal mode", buffer = bufnr }
					)
					return winid
				end,

				repl_definition = {
					python = require("iron.fts.python").ipython,
					typescript = require("iron.fts.typescript").ts,
					tsx = require("iron.fts.typescript").ts,
					lua = require("iron.fts.lua").lua,
					ruby = rails_console,
					sql = {
						command = { "pgcli", "-d", "hybrid_development", "-u", "hybrid" },
						-- command = { "pgcli", vim.env.PRODUCTION_POSTGRES },
						format = bracketed_paste,
					},
				},
			},

			keymaps = {
				visual_send = "<leader>r",
				send_motion = "<leader>rm",
				send_file = "<leader>ra",
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
