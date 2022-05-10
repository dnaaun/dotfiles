return {
	"stevearc/dressing.nvim",
	config = function()
		require("dressing").setup({
			select = {
				enabled = true, -- Gotta figure out some error with telescope

        -- Currently the builtin backend is dope, so I don't use this. But when
        -- I do, I need this because my default settings for telescope don't
        -- vibe well with dressing's default settings.
				telescope = {},

				backend = { "builtin" },
			},
		})
	end,
}
