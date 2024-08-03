return {
	"NeogitOrg/neogit",
	dependencies = "nvim-lua/plenary.nvim",
	config = function()
		require("neogit").setup()

		local wk = require("which-key")
		wk.add({
			{ "<leader>nn", require("neogit").open, desc = "Neogit" },
			{
				"<leader>ns",
				function()
					require("neogit").open({ "stash" })
				end,
				desc = "Neogit stash",
			},
			{
				"<leader>nb",
				function()
					require("neogit").open({ "branch" })
				end,
				desc = "Neogit branch",
			},
			{
				"<leader>nh",
				function()
					require("neogit").open({ "cherry_pick" })
				end,
				desc = "Neogit cherry_pick",
			},
			{
				"<leader>nc",
				function()
					require("neogit").open({ "commit" })
				end,
				desc = "Neogit commit",
			},
			{
				"<leader>nd",
				function()
					require("neogit").open({ "diff" })
				end,
				desc = "Neogit diff",
			},
			{
				"<leader>nl",
				function()
					require("neogit").open({ "log" })
				end,
				desc = "Neogit log",
			},
			{
				"<leader>np",
				function()
					require("neogit").open({ "pull" })
				end,
				desc = "Neogit pull",
			},
			{
				"<leader>nu",
				function()
					require("neogit").open({ "push" })
				end,
				desc = "Neogit push",
			},
			{
				"<leader>nr",
				function()
					require("neogit").open({ "rebase" })
				end,
				desc = "Neogit rebase",
			},
			{
				"<leader>nt",
				function()
					require("neogit").open({ "reset" })
				end,
				desc = "Neogit reset",
			},
		})
	end,
}
