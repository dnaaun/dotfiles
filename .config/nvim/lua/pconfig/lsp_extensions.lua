return {
	"nvim-lua/lsp_extensions.nvim",
	ft = { "rust" },
  event = "CursorHold",
	config = function()
		local g = vim.api.nvim_create_augroup("RustInLayHints", {})
		vim.api.nvim_create_autocmd({
			"CursorHold",
			"CursorHoldI",
		}, {
			group = g,
			pattern = "*.rs",
			callback = function()
				require("lsp_extensions").inlay_hints()
			end,
		})
	end,
}
