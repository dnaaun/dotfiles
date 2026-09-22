-- Tree-sitter grammar for syrupy `.ambr` snapshot files, kept in this repo
-- (neovim_plugins/tree-sitter-ambr). Loading the grammar directory as a plugin
-- puts its queries/ambr/*.scm (highlights, folds, indents, and context.scm for
-- nvim-treesitter-context) on the runtimepath. The parser itself is registered
-- with nvim-treesitter in pconfig.treesitter, which also ensures it is built.
return {
	name = "tree-sitter-ambr",
	dir = vim.fn.expand("~/git/dotfiles/neovim_plugins/tree-sitter-ambr"),
	lazy = false,
	init = function()
		vim.filetype.add({ extension = { ambr = "ambr" } })
	end,
}
