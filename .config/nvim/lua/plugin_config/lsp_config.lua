-- Keybindings
local setup_mappings = function()
  local opts = { noremap=true, silent=true }
  vim.api.nvim_buf_set_keymap(0, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(0, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(0, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(0, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>lt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(0, 'n', 'gR', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(0, 'n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(0, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(0, 'n', 'gh', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  vim.api.nvim_buf_set_keymap(0, 'n', '[e', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(0, 'n', ']e', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_buf_set_keymap(0, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

-- Allow other files to define callbacks that get called `on_attach`
local on_attach = function(client)
  for _, plugin_custom_attach in pairs(_G.lsp_config_on_attach_callbacks) do
    plugin_custom_attach(client)
  end

  setup_mappings()
end

-- Config for all LSPs
local common_config = {
  on_attach = on_attach
}

-- Configuration for each LSP
local lsp_specific_configs = {
  lua = {
    settings = {
      Lua = {
        runtime = {
          -- LuaJIT in the case of Neovim
          version = 'LuaJIT',
          path = vim.split(package.path, ';'),
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'},
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = {
            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
            [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
          },
        },
      }
    }
  }
}


local lspconfig = require('lspconfig')
for _, lspname in ipairs({'pyright', 'tsserver', 'cssls', 'vimls', 'rls','lua'}) do
  local  config = lsp_specific_configs[lspname]
  if (config ~= nil) then
    config = vim.tbl_extend("force", common_config, config)
  else
    config = common_config
  end
  lspconfig[lspname].setup(config)
end
