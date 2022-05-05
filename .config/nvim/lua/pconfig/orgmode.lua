return {
	"nvim-orgmode/orgmode",
	ft = { "org" },
	config = function()
		require("orgmode").setup_ts_grammar()
		require("orgmode").setup({
			org_agenda_files = { "~/git/notes/org/agenda/*" },
			org_default_notes_file = "~/notes/org/agenda/refile.org",
		})
	end,
}
