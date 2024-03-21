return {
	cmd = { "/home/davidat/.local/share/nvim/mason/bin/efm-langserver", "-logfile", "/tmp/efm.log", "-loglevel", "5" },
	initOptions = {
		initializationOptions = {
			documentFormatting = true,
			documentRangeFormatting = true,
			hover = true,
			documentSymbol = true,
			codeAction = true,
			completion = true,
		},
	},
	settings = {
		rootMarkers = { ".git/", ".root" },
		languages = {
			sql = {
				{
					lintCommand = "pgsanity",
					lintStdin = true,
					lintFormats = {
						"line %l: %tRROR: %m",
					},
				},
			},
		},
		filetypes = { "sql" },
	},
}
