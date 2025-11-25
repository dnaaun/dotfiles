-- Found somewhere. Is originally by folke I think.
_G.ansi_colorize = function()
	vim.bo.modifiable = true
  vim.wo.wrap = false
  vim.go.wrap = false
	-- vim.wo.number = false
	-- vim.wo.relativenumber = false
	-- vim.wo.statuscolumn = ""
	-- vim.wo.signcolumn = "no"
	-- vim.opt.listchars = { space = " " }

	local buf = vim.api.nvim_get_current_buf()

	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})

	vim.api.nvim_chan_send(vim.api.nvim_open_term(buf, {}), table.concat(lines, "\r\n"))
	vim.keymap.set("n", "q", "<cmd>qa!<cr>", { silent = true, buffer = buf })
	vim.api.nvim_create_autocmd("TermEnter", { buffer = buf, command = "stopinsert" })

	-- I am doing this because in non-pager mode, we use Lazy
	-- to load catppuccin, but we delay loading Lazy for perf reasons in pager mode.
	vim.opt_global.runtimepath:append("~/.local/share/nvim/lazy/catppuccin")
	vim.opt_global.runtimepath:append("~/.local/share/nvim/lazy/catppuccin/after")
	-- Set the colorscheme to catppuccin-mocha
	vim.cmd("colorscheme " .. require("selected_colorscheme").selected)
end

_G.PAGER_MODE = true

local ansi_once = vim.api.nvim_create_augroup("AnsiOnce", { clear = true })
vim.api.nvim_create_autocmd("StdinReadPost", {
	group = ansi_once,
	callback = function()
		_G.ansi_colorize()

		-- require("options")
		-- We don't need to load init.lua anymore, or colorize any more buffers.
		-- vim.api.nvim_del_augroup_by_id(ansi_once)

		vim.defer_fn(
			function()
				vim.cmd("source ~/.config/nvim/init.lua")
				vim.wo.signcolumn = "no"
				vim.wo.number = false
				vim.wo.foldcolumn = "0"
			end,

			200 -- ms is lowest I can go while having neovim decide
		)
	end,
})
