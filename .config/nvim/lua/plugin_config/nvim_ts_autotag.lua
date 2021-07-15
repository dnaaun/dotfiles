local filetypes = {
  'html', 'javascript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'jsx'
}
require('nvim-ts-autotag').setup({
  filetypes = filetypes,
})
