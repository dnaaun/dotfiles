return {
	"windwp/nvim-autopairs",
  event = "InsertEnter",
	dependencies = {
    -- might not be necessary, but we do require('cmp') in
    -- config() below.
    "hrsh7th/nvim-cmp"
  },
	config = function()
		-- TODO:
		-- This is probably very unideal, in that starting vim with a markdown mode means
		-- this plugin is never setup for any other file types either.
		if vim.opt_local.filetype == "markdown" then
			return
		end
		require("nvim-autopairs").setup({})
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp = require("cmp")
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

		local Rule = require("nvim-autopairs.rule")
		local npairs = require("nvim-autopairs")

		local always = function()
			return true
		end
		-- local cond = require("nvim-autopairs.conds")

		npairs.add_rules({
			Rule("~", "~", { "org" }):with_move(always),
		})
	end,
}
