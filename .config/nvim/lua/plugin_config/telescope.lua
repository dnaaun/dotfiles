local std2 = require("std2")

require("telescope").setup({
  defaults = {
    layout_strategy = "vertical",
    layout_config = {
      height = 0.6,
      width = 0.99, -- Works better because usually my terminal takes only half my screen
      preview_height = 0.2,
    },
  },
  pickers = {
    buffers = {
      mappings = {
        i = {
          ["<c-d>"] = "delete_buffer",
        },
        n = {
          ["<c-d>"] = "delete_buffer",
        },
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
    },
  },
})

require("telescope").load_extension("fzf")
require("telescope").load_extension("aerial")

-- Mappings
local mapping_opts = { noremap = true }
local mapfunc = std2.mapfunc
local buf_mapfunc = std2.buf_mapfunc

mapfunc("n", "<leader>ff", require("telescope.builtin").fd, { noremap = true })
mapfunc("n", "<leader>fcf", function()
  require("telescope.builtin").fd({ search_dirs = { vim.fn.expand("%:p:h") } })
end, {
  noremap = true,
})
mapfunc("n", "<leader>fcg", function()
  require("telescope.builtin").live_grep({ search_dirs = { vim.fn.expand("%:p:h") } })
end, {
  noremap = true,
})
mapfunc("n", "<leader>fg", require("telescope.builtin").live_grep, { noremap = true })
-- Isn't prefixed with f cuz it's so commonly used
mapfunc("n", "<leader>b", require("telescope.builtin").buffers, { noremap = true })
-- Isn't prefixed with f cuz it's so commonly used
mapfunc("n", "<leader>h", require("telescope.builtin").oldfiles, { noremap = true })
mapfunc("n", "<leader>ft", require("telescope.builtin").help_tags, { noremap = true })
mapfunc("n", "<leader>f:", require("telescope.builtin").command_history, { noremap = true })
mapfunc("n", "<leader>f/", require("telescope.builtin").current_buffer_fuzzy_find, { noremap = true })
mapfunc("n", "<leader>fj", require("telescope.builtin").jumplist, { noremap = true })

local function on_attach()
  buf_mapfunc("n", "ga", require("telescope.builtin").lsp_code_actions, mapping_opts)
  buf_mapfunc("n", "gd", require("telescope.builtin").lsp_definitions, mapping_opts)
  buf_mapfunc("n", "gr", require("telescope.builtin").lsp_references, mapping_opts)
  buf_mapfunc("n", "gi", require("telescope.builtin").lsp_implementations, mapping_opts)
  buf_mapfunc("n", "gD", require("telescope.builtin").lsp_workspace_diagnostics, mapping_opts)
end

table.insert(_G.lsp_config_on_attach_callbacks, on_attach)
