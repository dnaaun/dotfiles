return {
	"michaelb/sniprun",
	build = "sh install.sh",
	config = function()
		require("sniprun").setup({
			display = { "TerminalWithCode" },
		})
	end,
}
