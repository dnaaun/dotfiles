-- nvim-treesitter `main` branch: it only manages parser/query installation and
-- ships queries. Highlighting, folding, and injections come from Neovim itself,
-- so the old module system (`nvim-treesitter.configs`) is gone. See :h
-- nvim-treesitter for the commands (:TSInstall, :TSUpdate, :TSLog, ...).
local ensure_installed = {
	"tsx",
	"html",
	"lua",
	"ruby",
	"python",
	"rust",
	"markdown",
	"markdown_inline",
	"sql",
	"swift",
	"yaml",
	"ambr",
}

-- Local grammar for syrupy .ambr snapshot files; see pconfig.tree_sitter_ambr
-- for the queries. `path` makes nvim-treesitter compile straight from that
-- directory. The parsers table is reloaded on :TSUpdate, so this has to be
-- (re-)applied from the `User TSUpdate` autocmd as well as up front.
local function register_ambr()
	require("nvim-treesitter.parsers").ambr = {
		install_info = {
			path = vim.fn.expand("~/git/dotfiles/neovim_plugins/tree-sitter-ambr"),
		},
	}
end

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false, -- main does not support lazy-loading
	build = ":TSUpdate",
	config = function()
		vim.treesitter.language.register("tsx", {
			"javascript",
			"typescript",
			"tsx",
			"jsx",
			"javascriptreact",
			"typescriptreact",
		})

		vim.treesitter.language.register("latex", {
			"tex",
			"latex",
		})

		local group = vim.api.nvim_create_augroup("pconfig_treesitter", { clear = true })

		vim.api.nvim_create_autocmd("User", { group = group, pattern = "TSUpdate", callback = register_ambr })
		register_ambr()

		-- Async, and a no-op for parsers that are already installed.
		require("nvim-treesitter").install(ensure_installed)

		-- Highlighting for every buffer whose filetype has an installed parser
		-- (what the old `highlight = { enable = true }` module did).
		vim.api.nvim_create_autocmd("FileType", {
			group = group,
			callback = function(args)
				pcall(vim.treesitter.start, args.buf)
			end,
		})

		vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.opt.foldtext = ""
	end,
}
