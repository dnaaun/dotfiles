-- NOTE: Btw, this requires a "patched font", and after trying out
-- Iosevka and FiraCode, JetBrainsMono Nerd Font is what worked for me.
return {
	"folke/trouble.nvim",
	requires = "nvim-tree/nvim-web-devicons",
	config = function()

		require("trouble").setup({
			position = "right",
		})
	end,
}
