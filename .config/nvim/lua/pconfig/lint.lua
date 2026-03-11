return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPost", "BufWritePost", "InsertLeave" },
	config = function()
		require("lint").linters_by_ft = {
			ruby = { "rubocop" },
		}

		vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "BufReadPost" }, {
			callback = function() require("lint").try_lint() end,
		})
	end,
}
