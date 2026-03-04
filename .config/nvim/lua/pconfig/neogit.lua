return {
	"NeogitOrg/neogit",
	dependencies = "nvim-lua/plenary.nvim",
	config = function()
		require("neogit").setup()

		vim.keymap.set("n", "<leader>nn", require("neogit").open, { desc = "Neogit" })
		vim.keymap.set("n", "<leader>ns", function() require("neogit").open({ "stash" }) end, { desc = "Neogit stash" })
		vim.keymap.set("n", "<leader>nb", function() require("neogit").open({ "branch" }) end, { desc = "Neogit branch" })
		vim.keymap.set("n", "<leader>nh", function() require("neogit").open({ "cherry_pick" }) end, { desc = "Neogit cherry_pick" })
		vim.keymap.set("n", "<leader>nc", function() require("neogit").open({ "commit" }) end, { desc = "Neogit commit" })
		vim.keymap.set("n", "<leader>nd", function() require("neogit").open({ "diff" }) end, { desc = "Neogit diff" })
		vim.keymap.set("n", "<leader>nl", function() require("neogit").open({ "log" }) end, { desc = "Neogit log" })
		vim.keymap.set("n", "<leader>np", function() require("neogit").open({ "pull" }) end, { desc = "Neogit pull" })
		vim.keymap.set("n", "<leader>nu", function() require("neogit").open({ "push" }) end, { desc = "Neogit push" })
		vim.keymap.set("n", "<leader>nr", function() require("neogit").open({ "rebase" }) end, { desc = "Neogit rebase" })
		vim.keymap.set("n", "<leader>nt", function() require("neogit").open({ "reset" }) end, { desc = "Neogit reset" })
	end,
}
