return {
	"nvim-orgmode/orgmode",
	config = function()
		require("orgmode").setup({
			org_agenda_files = { "~/Library/CloudStorage/Dropbox/notes/org/**/*" },
			org_capture_templates = {
        t = { description = "Task", template = "* TODO %?\n %u" },
        m = { description = "Musings", template = "* No todo. Just express yourself. \n %u \n %?" },
    },
			org_start_folded = "showeverything",
			org_todo_keywords = {
				"TODO",
				"|",
				"DONE",
				"NOT_DONE",
			},
			org_default_notes_file = "~/Library/CloudStorage/Dropbox/notes/org/refile.org",
			org_agenda_custom_commands = {
				h = {
					description = "High priority todos",
					types = {
						{
							type = "tags_todo",
							match = '+PRIORITY="A"',
							org_agenda_overriding_header = "High Priority TODOs"
						}
					}
				},
				d = {
					description = "Done todos",
					types = {
						{
							type = "todo",
							org_agenda_overriding_header = "Completed TODOs"
						}
					}
				}
			},
			mappings = {
				prefix = "<leader>x", -- Cuz I want to use <leader>o for portal.nvim, to do something like, but not quite like, what `o` does.last
				-- ORG_EDIT_SPECIAL                                        *orgmode-org_edit_special*
				org_edit_special = "<leader>xo",
				global = {
					org_capture = "gC",
				},
			},
		})
	end,
}
