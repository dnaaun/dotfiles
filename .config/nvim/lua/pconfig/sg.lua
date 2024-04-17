return {
  {
    "sourcegraph/sg.nvim",
    cmd = { "CodyAsk"}, -- TODO: Add the others when you use Cody.
    dependencies = { "nvim-lua/plenary.nvim" },

    -- If you have a recent version of lazy.nvim, you don't need to add this!
    build = "nvim -l build/init.lua",
  },
}
