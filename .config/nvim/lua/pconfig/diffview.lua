local vim = vim

-- Override the mapping for the given key_combo to call DiffviewRefresh
-- after the original mapping is called, if it exists.
-- GPT-4 wrote this with me after I was annoyed at the time gap between
-- me staging/unstaging using `gitsigns` bindings, and diffview updating.
local function override_key_combo(key_combo, mode)
  -- Get the original mapping for the given key_combo
  local original_mapping = vim.fn.maparg(key_combo, mode, false, true)

  -- Create a new function to call the original mapping and DiffviewRefresh
  local function new_function()
    -- Call the original mapping
    if original_mapping and original_mapping.rhs ~= '' then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(original_mapping.rhs, true, true, true), 'n', true)
    end

    -- Run the command DiffviewRefresh
    vim.cmd("DiffviewRefresh")
  end

	-- Create a new mapping for the given key_combo to call the new function
	vim.api.nvim_set_keymap(mode, key_combo, "<cmd>lua new_function()<CR>", {
    silent = original_mapping.silent ~= 0,
    noremap = original_mapping.noremap ~= 0,
    desc = "Override " .. key_combo .. " to call DiffviewRefresh afterwards"
  })
end

-- Normalizes { "c1", { "c2", "n" } } to { { key = "c1", mode = "n" }, { key = "c2", mode = "n" } }
function normalize_key_combos(key_combos)
  local normalized = {}

  for _, item in ipairs(key_combos) do
    if type(item) == "string" then
      table.insert(normalized, {key = item, mode = "n"})
    elseif type(item) == "table" and item[1] and type(item[1]) == "string" then
      table.insert(normalized, {key = item[1], mode = item.mode or "n"})
    end
  end

  return normalized
end

local function override_gitsigns_combos()
  local combos = require("pconfig.gitsigns").keys
  if not combos then
    return
  end

  combos = normalize_key_combos(combos)

  for _, combo in ipairs(combos) do
    override_key_combo(combo.key, combo.mode)
  end
end


return {
	"sindrets/diffview.nvim",
	dependencies =  { 
    "nvim-lua/plenary.nvim",

    -- I add gitsigns because I think loading that first helps with 
    -- overriding the key combos.
    require("pconfig.gitsigns")[1]
  },

	keys = { "<leader>gd", "<leader>gq" },
  cmd = { "DiffviewFileHistory", "DiffviewOpen" },

  -- I think I have to do this to make sure that diffview.nvim loads after
  -- gitsigns.
  event = require("pconfig.gitsigns").event,

	config = function()
		local wk = require("which-key")
		wk.register({
			g = {
				name = "git",
				d = { ":DiffviewOpen<CR>", "Diffview Open" },
				q = { ":tabclose<CR>", "Tab Close" },
			},
		}, { prefix = "<leader>" })

		local cb = require("diffview.config").diffview_callback

		require("diffview").setup({
			key_bindings = {
				file_panel = {
					["<cr>"] = cb("focus_entry"),
				},
			},
		})

    override_gitsigns_combos()
	end,
}
