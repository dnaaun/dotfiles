local nvim_set_keymap = vim.api.nvim_set_keymap

-- Mappings must come not in setup/config because of lazy-loading.
for _, mode in pairs({ "n", "v", "i", "t" }) do
	nvim_set_keymap(mode, "<C-j>", "<cmd>:TmuxNavigateDown<CR>", { noremap = true })
	nvim_set_keymap(mode, "<C-k>", "<cmd>:TmuxNavigateUp<CR>", { noremap = true })
	nvim_set_keymap(mode, "<C-h>", "<cmd>:TmuxNavigateLeft<CR>", { noremap = true })
	nvim_set_keymap(mode, "<C-l>", "<cmd>:TmuxNavigateRight<CR>", { noremap = true })
end

return {
	"christoomey/vim-tmux-navigator",
	cmd = {
		"TmuxNavigateDown",
		"TmuxNavigateUp",
		"TmuxNavigateLeft",
		"TmuxNavigateRight",
	},
}
