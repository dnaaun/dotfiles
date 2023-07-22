local wk = require("which-key")
wk.register({
  ["-"] = {
    "<cmd>Dirbuf<CR>",
    "dirbuf",
  },
})

return { 
  "elihunter173/dirbuf.nvim",
  cmd = "Dirbuf",
  module = "dirbuf",
}
