return {
	"johmsalas/text-case.nvim",
  keys = { "<leader>c" },
	config = function()
		require("textcase").setup({
			prefix = "<leader>c",
		})
		local wk = require("which-key")
		wk.add({
        {"<leader>cs" ,
					function()
						require("textcase").current_word("to_snake_case")
					end,
				desc = 	"convert_to_snake_case (manual mapping)",
				},
				{"<leader>cS",
					function()
						require("textcase").lsp_rename("to_snake_case")
					end,
				desc =	"LSP convert_to_snake_case (manual mapping)",
				},
			})
	end,
}
