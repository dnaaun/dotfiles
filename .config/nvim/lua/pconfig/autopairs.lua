return {
	"windwp/nvim-autopairs",
	after = "nvim-cmp", -- might not be necessary, but we do require('cmp') in config() below.

	config = function()
		require("nvim-autopairs").setup({})
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp = require("cmp")
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

		local Rule = require("nvim-autopairs.rule")
		local npairs = require("nvim-autopairs")

		local always = function()
			return true
		end

		npairs.add_rules({
			Rule("~", "~", { "org" }):with_move(always),
		})
	end,
}
