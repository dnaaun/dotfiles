return {
	"nvim-orgmode/orgmode",
	config = function()
		-- Load custom treesitter grammar for org filetype
		require("orgmode").setup_ts_grammar()
		require("orgmode").setup({
			org_agenda_files = { "~/Dropbox/notes/org/**/*" },
      org_todo_keywords = { 
        "TODO", "|", "DONE", "NOT_DONE"
      },
			org_default_notes_file = "~/Dropbox/notes/org/refile.org",
      mappings = {
        prefix = "<leader>x" -- Cuz I want to use <leader>o for portal.nvim, to do something like, but not quite like, what `o` does.last 
      }
		})
	end,
}
