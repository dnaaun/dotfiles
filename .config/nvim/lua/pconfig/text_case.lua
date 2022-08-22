return {
	"johmsalas/text-case.nvim",
	config = function()
		require("textcase").setup({
			prefix = "<leader>c",
		})
		local wk = require("which-key")
		wk.register({
			["<leader>c"] = {
				s = {
					function()
						require("textcase").current_word("to_snake_case")
					end,
					"convert to snake case (manual mapping)",
				},
			},
		})
	end,
}
