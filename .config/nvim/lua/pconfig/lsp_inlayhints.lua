-- https://github.com/lvimuser/lsp-inlayhints.nvim#lspattach
vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
vim.api.nvim_create_autocmd("LspAttach", {
	group = "LspAttach_inlayhints",
	callback = function(args)
		if not (args.data and args.data.client_id) then
			return
		end

		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		require("lsp-inlayhints").on_attach(client, bufnr)
	end,
})

return {
	"lvimuser/lsp-inlayhints.nvim",
	module = true,
	branch = "anticonceal",
	config = function()
		local wk = require("which-key")
		wk.add({
			{ "<leader>lh", "<cmd>lua require('lsp-inlayhints').toggle()<CR>", desc = "Toggle inlay hints" },
		})
		require("lsp-inlayhints").setup()
	end,
}
