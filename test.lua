return {
	"vim-test/vim-test",
	requires = { "tpope/vim-dispatch" },
	ft = { "ruby" },
	config = function()
		vim.g["test#strategy"] = "dispatch"
		vim.g["test#ruby#rspec#executable"] = "bundle exec rspec"
		-- vim.g["test#ruby#rspec#options"] = "--force-color"
	end,
}
