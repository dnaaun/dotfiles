local mapfunc = require("std2").mapfunc

-- Prepare the Codi buffer with some text, if necessary.
local preparatory_lines_by_filetype = {
	ruby = { "# frozen_string_literal: true" },
}

-- s for scratchpad
mapfunc("n", "<leader>rs", function()
	local filetype = vim.opt.filetype

	-- Temp file to open
	local temp_file = vim.api.nvim_eval("tempname()") .. "_codi." .. vim.fn.expand("%:e") .. "asdf"

	-- get the preparatory lines
	local preparatory_lines = vim.list_extend({}, preparatory_lines_by_filetype[filetype] or {})
	vim.list_extend(preparatory_lines, { "" }) -- This is the line where we will start the insert

	--  Open split buffer
	vim.api.nvim_exec("botright vsplit " .. temp_file, false)

	-- Execute things in new buffer
	vim.opt.filetype = filetype
	vim.api.nvim_buf_set_lines(0, 0, -1, false, preparatory_lines)
	vim.api.nvim_win_set_cursor(0, { #preparatory_lines, 0 }) -- Prepare for :startinsert
	vim.api.nvim_exec("startinsert", false)
	vim.api.nvim_command("Codi")
end, {}, "Open Codi in a new buffer.")

return {
	"metakirby5/codi.vim",
	-- cmd = { "Codi", "Codi!", "Codi!!" },
	setup = function()
		-- Fix irb not working with default settings
		-- https://github.com/metakirby5/codi.vim/issues/133#issuecomment-912868183
		vim.g["codi#interpreters"] = {
			ruby = {
				bin = { "irb", "-f", "--nomultiline" },
			},
      python = {
        bin = "ipython",
        prompt ="In \\[[0-9]\\]: ",
      }
		}
	end,
}
