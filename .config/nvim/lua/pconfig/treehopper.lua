return {
	"davidatsurge/nvim-treehopper",
	branch = "add-config-to-specify-parser-for-filetypes",
	keys = { { "m", mode = "v" }, { "m", mode = "o" } },
	config = function()
		local wk = require("which-key")

		-- Operator-pending mode mapping
		wk.register({
			m = { require("tsht").nodes, "Treehopper Nodes" },
		}, {
			mode = "o",
			silent = true,
		})

		-- Visual mode mapping
		wk.register({
			m = { require("tsht").nodes, "Treehopper Nodes" },
		}, {
			mode = "v",
			silent = true,
		})

		require("tsht").config.ft_to_parser.typescriptreact = "tsx"
	end,
}
