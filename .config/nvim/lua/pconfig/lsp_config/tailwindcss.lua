return {
	filetypes = vim.list_extend({ "rust" }, require("consts").javascripty_filetypes),
	init_options = {
    -- Disable cuz my regexes are messed up
		-- userLanguages = {
		-- 	rust = "html",
		-- 	["*.rs"] = "html",
		-- },
	},
	settings = {
		-- tailwindCSS = {
		-- 	includeLanguages = {
		-- 		-- rust = "html",
		-- 		-- ["*.rs"] = "html",
		-- 	},
		-- 	experimental = {
		-- 		classRegex = {
		-- 			-- Start autocompletion when `class("...")`
		-- 			-- This is useful for Leptos/sycamore.
		-- 			-- { [[\.class\(([^\)]*)\)]], '"([^"]*)"' },
		-- 			-- { [[\.classes\(([^\)]*)\)]], '"([^"]*)"' },
		-- 		},
		-- 	},
		-- 	emmetCompletions = true,
		-- 	classAttributes = { "class", "className", "classList", "ngClass" },
		-- 	lint = {},
		-- 	validate = true,
		-- },
	},
}
