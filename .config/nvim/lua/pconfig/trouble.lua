-- NOTE: Btw, this requires a "patched font", and after trying out
-- Iosevka and FiraCode, JetBrainsMono Nerd Font is what worked for me.
return {
	"folke/trouble.nvim",
	dependencies = "nvim-tree/nvim-web-devicons",
  cmd = { "Trouble" },
	config = function()

		require("trouble").setup({
			position = "right",

      -- Trouble gives out a lot of errors when this is on.
      -- https://github.com/folke/trouble.nvim/issues/125#issuecomment-1023980225
      auto_preview = false
		})
	end,
}
