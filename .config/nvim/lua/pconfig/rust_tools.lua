-- Update this path

-- Normal setup
return {
	"simrat39/rust-tools.nvim",
	dependencies = "nvim-lspconfig", -- otherwise, I get an error when rust-tools tries to access package.preload['lspconfig'] or something like that
  ft = "rust",
	config = function()
		local extension_path = vim.env.HOME .. "/.vscode/extensions/vadimcn.vscode-lldb-1.7.0/"
		local codelldb_path = extension_path .. "adapter/codelldb"
		local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"

		local opts = {
			-- ... other configs
			dap = {
				adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
			},

      -- https://github.com/lvimuser/lsp-inlayhints.nvim#rust
      tools = {
        inlay_hints = {
            auto = false
        }
    }
		}
		require("rust-tools").setup(opts)
	end,
}
