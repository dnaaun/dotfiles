return {
	"wbthomason/packer.nvim",

	config = function()
		vim.api.nvim_exec(
			[[
autocmd FileType vim,lua nnoremap <buffer> <leader>ci :source %<bar>PackerInstall<CR>
autocmd FileType vim,lua nnoremap <buffer> <leader>cc :source %<CR>
]],
			false
		)
	end,
}
