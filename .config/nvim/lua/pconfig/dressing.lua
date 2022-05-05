return {
	"stevearc/dressing.nvim",
	config = function()
		require("dressing").setup({
    select = {
      enabled = false, -- Gotta figure out some error with telescope
    }})
	end,
}
