
return { 
  "elihunter173/dirbuf.nvim",
  config = function()
    local wk = require("which-key")
    wk.register({
      ["-"] = {
        "<cmd>Dirbuf<CR>",
        "dirbuf",
      },
    })
  end
}
