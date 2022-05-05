return {
	"~/git/coq_nvim",
	config = function()
		vim.g.coq_settings = {
			display = {
				pum = {
					fast_close = false,
					y_max_len = 32,
					y_ratio = 0.6,
				},
				icons = {
					mode = "short",
				},
			},
			keymap = {
				recommended = false,
				jump_to_mark = "<C-g>", -- <c-h> conflicts with my binding for :TmuxNavigateLeft
				eval_snips = "<leader>cr",
				manual_complete = "<C-f>",
				pre_select = true, -- Don't set the noselect option in completeopt (which would mean that the first item is selcted by default out of the autocomplete options)
			},
			auto_start = "shut-up",
			clients = {
				tmux = {
					enabled = false,
				},
				buffers = {
					enabled = true,
					weight_adjust = -2,
				},
				tree_sitter = {
					enabled = true,
					weight_adjust = -1.8,
				},
				lsp = {
					enabled = true,
					weight_adjust = 1.5,
					resolve_timeout = 0.04, -- typescript-language-server doesn't autoimoprt without increasing this val from the default of 0.09. (https://github.com/ms-jpq/coq_nvim/issues/71#issuecomment-902946727)
				},
				snippets = {
					enabled = true,
					weight_adjust = 2,
				},
			},
			match = {
				proximate_lines = 0.0,
				fuzzy_cutoff = 1.0,
				look_ahead = 0,
			},
			weights = {
				edit_distance = 0.0,
				recency = 0.0,
				proximity = 0.0,
			},
		}

		vim.opt.showmode = false
		vim.opt.shortmess = vim.opt.shortmess + { c = true }

		-- Aint nobody got time to figure out the nuances of doing a keybind
		-- with native lua with expr=true
		vim.api.nvim_exec(
			[[
		inoremap <silent><expr> <Esc>   pumvisible() ? "\<C-e><Esc>" : "\<Esc>"
		inoremap <silent><expr> <C-c>   pumvisible() ? "\<C-e><C-c>" : "\<C-c>"
		inoremap <silent><expr> <BS>    pumvisible() ? "\<C-e><BS>"  : "\<BS>"
		inoremap <silent><expr> <CR>    pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"
		inoremap <silent><expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
		inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<BS>"
		]],
			false
		)
	end,
}