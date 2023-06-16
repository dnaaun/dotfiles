return {
	"folke/which-key.nvim",
	config = function()
    -- I already gate in plugins.lua hoping to avoid loading this and
    -- other plugins in PAGER_MODE, but since that's not working,
    if _G.PAGER_MODE then
      return
    end


		-- Set timeout to zero so that which-key thing shows up super quickly
		vim.opt.timeoutlen = 0

		-- How to disable some operators? (like v)
		local presets = require("which-key.plugins.presets")
		presets.operators["v"] = nil
    

		require("which-key").setup({
			layout = {
				height = { min = 4, max = 200 },
				width = { min = 20, max = 200 }, -- min and max width of the columns
			},
      disable = {
        filetypes = {
          -- I added this here I use neovim as a pager for pgcli (and maybe other things),
          -- and I set `nomodifiable` there (also `nowrap`, but I think that's irrelevant),
          -- and I believe that is preventing which-key from working, which means that
          -- even basic things like yanking text are erroring out.
          "terminal"
        }
      }
		})
	end,
}
