return {
	"lewis6991/gitsigns.nvim",
	requires = { "nvim-lua/plenary.nvim" },
	config = function()
		require("gitsigns").setup({

			keymaps = {
				noremap = true,

				["n ]h"] = {
					expr = true,
					"&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'",
				},
				["n [h"] = {
					expr = true,
					"&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'",
				},

				["n <leader>gw"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
				["v <leader>gw"] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
				["n <leader>gu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
				["n <leader>gr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
				["v <leader>gr"] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
				["n <leader>gp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
				["n <leader>gb"] = '<cmd>lua require"gitsigns".blame_line()<CR>',
				["n <leader>gW"] = '<cmd>lua require"gitsigns".stage_buffer()<CR>',

				-- Text objects
				["o ih"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
				["x ih"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
			},
		})
	end,
}
