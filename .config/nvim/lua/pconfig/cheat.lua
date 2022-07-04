return {
	"RishabhRD/popfix",
	requires = "RishabhRD/nvim-cheat.sh",
	config = function()
		vim.keymap.set("n", "<leader>fc", function()
			require("nvim-cheat"):new_cheat(false, vim.bo.filetype .. ' ')
		end)
	end,
}
