return {
	"folke/noice.nvim",
	event = "VeryLazy",
	enabled = not vim.g.started_by_firenvim,
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

				-- Sorbet warns about this. I don't know/care what it means.
				{
					filter = {
						find = "Watchman support currently only works when Sorbet is run with a single input directory.",
					},
					opts = { skip = true },
				},
				{
					filter = {
						find = "invalid node type at position",
					},
					opts = { skip = true },
				},

				-- I upgraded Noevim, and something is not jiving with nvim-matchup and the new
				-- treesitter, or something.
				{
					filter = {
						any = {
							{
								find = "in function '_ts_parse_query'",
							},
							{
								find = "matchup#ts_engine#get_delim",
							},
							{
								find = "invalid node type at position",
							},
						},
					},
					opts = { skip = true },
				},
			},
		})
	end,
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		"rcarriga/nvim-notify",
	},
}
