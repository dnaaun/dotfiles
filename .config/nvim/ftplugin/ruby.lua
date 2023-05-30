-- Doing this NOT on every BufEnter is not working
vim.api.nvim_create_autocmd({ "BufAdd", "BufCreate", "BufEnter" }, {
	group = vim.api.nvim_create_augroup("RubyRemoveSomeIndentKeys", {}),
	pattern = "*.rb",
	callback = function()
		-- It's really annoying when the line is de-dented when typing a period.
		vim.opt_local.indentkeys:remove(".")
		vim.opt_local.indentkeys:remove("{")
		vim.opt_local.indentkeys:remove("}")
	end,
})

-- I have nvim-surround to load in InsertEnter in my lazy.nvim config,
-- which means, potentially, that this file (ie ftplubin/ruby.lua) is loaded before 
-- nvim-surround is loaded. So, I'm going to load it here, too.
-- The fact that I have `module = true` in my lazy.nvim config for nvim-surround
-- probably helps here too.
require("pconfig.surround").config()

-- Following the blueprint: https://github.com/kylechui/nvim-surround/discussions/53#discussioncomment-3341113
require("nvim-surround").buffer_setup({
	surrounds = {
		["d"] = {
			add = { { "do", "" }, { "", "end" } },
		},
	},
})
