-- Found somewhere. Is originally by folke I think.
_G.ansi_colorize = function()
	vim.bo.modifiable = true
	-- vim.wo.number = false
	-- vim.wo.relativenumber = false
	-- vim.wo.statuscolumn = ""
	-- vim.wo.signcolumn = "no"
	-- vim.opt.listchars = { space = " " }

	local buf = vim.api.nvim_get_current_buf()

	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	-- while #lines > 0 and vim.trim(lines[#lines]) == "" do
	-- 	lines[#lines] = nil
	-- end
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})

	vim.api.nvim_chan_send(vim.api.nvim_open_term(buf, {}), table.concat(lines, "\r\n"))
	vim.keymap.set("n", "q", "<cmd>qa!<cr>", { silent = true, buffer = buf })
	vim.api.nvim_create_autocmd("TermEnter", { buffer = buf, command = "stopinsert" })
end

_G.ansi_colorize()

_G.PAGER_MODE = true

local ansi_once = vim.api.nvim_create_augroup("AnsiOnce", { clear = true })
vim.api.nvim_create_autocmd("StdinReadPost", {
	group = ansi_once,
	callback = function()
		require("options")
		_G.ansi_colorize()

		-- We don't need to load init.lua anymore, or colorize any more buffers.
		vim.api.nvim_del_augroup_by_id(ansi_once)

		vim.defer_fn(
			function()
				vim.cmd("source ~/.config/nvim/init.lua")
			end,

			-- 200 ms is lowest I can go while having neovim decide 
      -- it's worth loading the text before running this function, apparently.
      200
		)
	end,
})
