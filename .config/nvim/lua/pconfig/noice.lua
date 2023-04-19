return {
	"folke/noice.nvim",
	config = function()
		require("noice").setup({
			messages = {
				-- view for search count messages.
				view_search = "virtualtext",
			},

			routes = {
				-- Skip these annoying errors that show up when an LSP attaches to a buffer.
				-- Ie, duct tape over underlying errors I should fix.
				{
					filter = {
						find = "_on_attach",
					},
					opts = { skip = true },
				},

				-- When trying to show LSP docs for a symbol that doesn't have any, I get this annoying error
				-- I'd like to disable.
				{
					filter = {
						find = "No information available",
					},
					opts = { skip = true },
				},

				-- When I'm offline, (I believe) copiliot.lua or copilot-cmp keep complaining
				-- about not being able to hit Github servers.
				{
					filter = {
						find = "Request getCompletions failed with message: getaddrinfo ENOTFOUND api.github.com",
					},
					opts = { skip = true },
				},
			},
		})
	end,
	requires = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		"rcarriga/nvim-notify",
	},
}
