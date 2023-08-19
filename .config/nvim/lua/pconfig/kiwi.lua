vim.keymap.set('n', '<leader>ww', function() require("kiwi").open_wiki_index() end, {desc = "kiwi.open_wiki_index"})
vim.keymap.set('n', '<leader>wd', function() require("kiwi").open_diary_index() end, {desc = "kiwi.open_diary_index"})
vim.keymap.set('n', '<leader>wn', function() require("kiwi").open_diary_new() end, {desc = "kiwi.open_diary_new"})
vim.keymap.set('n', '<leader-x>', function() require("kiwi").todo.toggle() end, {desc = "kiwi.todo.toggle"})

return {
	"serenevoid/kiwi.nvim",
  module = "kiwi",
	dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("kiwi").setup({
      {
        name = "everything",
        path = "/Users/davidat/Dropbox/notes/org/"
      }
    })
  end
}

