local std2 = require("std2")

require("telescope").setup({
  defaults = {
    layout_strategy = "vertical",
    layout_config = {
      height = 0.99,
      width = 0.99, -- Works better because usually my terminal takes only half my screen
      preview_height = 0.6,
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

if not pcall(function() require("telescope").load_extension("fzf") end) then
  print("FZF extension for telescope not installed.")
end
if not pcall(function() require("telescope").load_extension("aerial") end) then
  print("Aerial extension for telescope not installed.")
end

-- Mappings
local mapping_opts = { noremap = true }
local mapfunc = std2.mapfunc
local buf_mapfunc = std2.buf_mapfunc

mapfunc("n", "<leader>fw", require("telescope.builtin").grep_string, { noremap = true })
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
mapfunc("n", "<leader>f.", require("telescope.builtin").resume, { noremap = true })
mapfunc("n", "<leader>gg", require("telescope.builtin").git_status, { noremap = true })
local function on_attach()
  buf_mapfunc("n", "<leader>la", require("telescope.builtin").lsp_code_actions, mapping_opts)

  buf_mapfunc("n", "gd", function() require("telescope.builtin").lsp_definitions({jump_type="jump"}) end, mapping_opts)

  -- Open definition in horizontal splits with gsd
  buf_mapfunc("n", "gsd", function() require("telescope.builtin").lsp_definitions({jump_type="split"}) end, mapping_opts)

  -- Open definition in vertical splits with gad.
  buf_mapfunc("n", "gad", function() require("telescope.builtin").lsp_definitions({jump_type="vsplit"}) end, mapping_opts)



  -- Repeat the same story with splits and going to references as with splits and going to definitions above.
  buf_mapfunc("n", "gr", function() require("telescope.builtin").lsp_references({jump_type="jump"}) end, mapping_opts)
  buf_mapfunc("n", "gsr", function() require("telescope.builtin").lsp_references({jump_type="split"}) end, mapping_opts)
  buf_mapfunc("n", "gar", function() require("telescope.builtin").lsp_references({jump_type="jump"}) end, mapping_opts)


  buf_mapfunc("n", "<leader>li", require("telescope.builtin").lsp_implementations, mapping_opts)
  buf_mapfunc("n", "<leader>le", require("telescope.builtin").lsp_workspace_diagnostics, mapping_opts)
end

table.insert(_G.lsp_config_on_attach_callbacks, on_attach)
