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
	vim.cmd("colorscheme " .. require("selected_colorscheme").selected)
end

vim.cmd("source ~/.config/nvim/init.lua")

vim.wo.signcolumn = "no"
vim.wo.number = false
vim.wo.foldcolumn = "0"

local ansi_once = vim.api.nvim_create_augroup("AnsiOnce", { clear = true })
vim.api.nvim_create_autocmd("StdinReadPost", {
	group = ansi_once,
	callback = _G.ansi_colorize,
})
