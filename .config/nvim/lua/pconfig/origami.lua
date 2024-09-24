return {
	"chrisgrieser/nvim-origami",
	config = function()
		-- default settings
		require("origami").setup({
			keepFoldsAcrossSessions = true,
			pauseFoldsOnSearch = true,
			setupFoldKeymaps = true,

			-- `h` key opens on first column, not at first non-blank character or before
			hOnlyOpensOnFirstColumn = false,
		})
	end,
}
