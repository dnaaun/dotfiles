return {
	"stevearc/aerial.nvim",
	opts = {},
	config = function()
		-- Call the setup function to change the default behavior
		require("aerial").setup({
      lazy_load = false,
			highlight_mode = "last",
			highlight_on_jump = 100,

      -- Was too unreliable. Will just do treesitter folding everywhere now.
			manage_folds = false,
			-- When you fold code with za, zo, or zc, update the aerial tree as well.
			-- Only works when manage_folds = true
			link_folds_to_tree = false,
			-- Fold code when you open/collapse symbols in the tree.
			-- Only works when manage_folds = true
			link_tree_to_folds = false,

			attach_mode = "global",
			open_automatic = false,


			layout = {
				-- These control the width of the aerial window.
				-- They can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
				-- min_width and max_width can be a list of mixed types.
				-- max_width = {40, 0.2} means "the lesser of 40 columns or 20% of total"
				max_width = { 40, 0.5 },
				width = 40,
				min_width = 10,

				-- key-value pairs of window-local options for aerial window (e.g. winhl)
				win_opts = {
				},

				-- Determines the default direction to open the aerial window. The 'prefer'
				-- options will open the window in the other direction *if* there is a
				-- different buffer in the way of the preferred direction
				-- Enum: prefer_right, prefer_left, right, left, float
				default_direction = "left",

				-- Determines where the aerial window will be opened
				--   edge   - open aerial at the far right/left of the editor
				--   window - open aerial to the right/left of the current window
				placement = "edge",

				-- When the symbols change, resize the aerial window (within min/max constraints) to fit
				resize_to_content = true,

				-- Preserve window size equality with (:help CTRL-W_=)
				preserve_equality = false,
			},
		})
	end,
	-- Optional dependencies
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
}
