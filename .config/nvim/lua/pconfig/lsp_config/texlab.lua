return {
	settings = {
		texlab = {
			rootDirectory = ".",
			bibtexFormatter = "texlab",
			chktex = {
				onEdit = false,
				onOpenAndSave = true,
			},
			diagnosticsDelay = 300,
			formatterLineLength = 80,
			forwardSearch = {
				executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
				args = {
					"-g", -- don't bring skim into foreground
					"-b", -- indicate line using reading bar
					"%l",
					"%p",
					"%f",
				},
			},
			latexFormatter = "latexindent",
			latexindent = {
				modifyLineBreaks = true,
			},

			build = {
				args = { "--synctex", "%f" },
				executable = "tectonic",
				forwardSearchAfter = false,
				onSave = true,
			},
		},
	},
}
