-- Update this path

-- Normal setup
return {
	"simrat39/rust-tools.nvim",
	after = "nvim-lspconfig", -- otherwise, I get an error when rust-tools tries to access package.preload['lspconfig'] or something like that
	config = function()
		local extension_path = vim.env.HOME .. "/.vscode/extensions/vadimcn.vscode-lldb-1.7.0/"
		local codelldb_path = extension_path .. "adapter/codelldb"
		local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"

		local opts = {
			-- ... other configs
			dap = {
				adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
			},
		}
		require("rust-tools").setup(opts)
	end,
}
