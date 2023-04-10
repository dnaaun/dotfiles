-- I don't know why I disabled you, but I must have a pretty good reason.
-- require('impatient') -- Speed up loading things. TOFIXLATER: This will probably (definitely?) break when impatient.nvim is not installed.

local detect_if_in_simple_mode_group = vim.api.nvim_create_augroup("DetectIfWeAreInSimpleMode", {
	clear = true,
})

-- When neovim is opened, detect if the file type is `gitrebase`
vim.api.nvim_create_autocmd( { "VimEnter"}, {
  group = detect_if_in_simple_mode_group,
	callback = function(args)
		local in_simple_mode = false

    local bufnr = args.buf
    local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
		if filetype == "gitrebase" then
			in_simple_mode = true
		end

		_G.IN_SIMPLE_MODE = in_simple_mode
	end,
})

--- Easy debugging
function _G.P(table)
	vim.notify(vim.inspect(table))
end

local g = vim.g
local opt = vim.opt

g.loaded_matchparen = 1
g.loaded_matchit = 1
g.loaded_logiPat = 1
g.loaded_rrhelper = 1
g.loaded_tarPlugin = 1
g.loaded_man = 1
g.loaded_gzip = 1
g.loaded_zipPlugin = 1
g.loaded_2html_plugin = 1
g.loaded_shada_plugin = 1
g.loaded_spellfile_plugin = 1
-- let g:loaded_netrw             = 1
-- let g:loaded_netrwPlugin       = 1
g.loaded_tutor_mode_plugin = 1
g.loaded_remote_plugins = 1

-- _G.lsp_config_on_attach_callbacks = {}

local nvim_set_keymap = vim.api.nvim_set_keymap

--- not filetype-specific, or plugin-specific
opt.number = true
-- Prevent wierd de-endentation when writing python
opt.indentkeys:remove({ ":" })

opt.matchpairs:append({ "<:>" })
opt.scrollback = 100000 -- Lines to keep in neovim's terminal emulator
opt.spell = false
opt.conceallevel = 2 -- for neorg to hide links right now.
opt.splitbelow = true
opt.splitright = true
opt.hlsearch = true
opt.incsearch = true -- Incremental search highlight
opt.completeopt = { "longest", "preview", "noinsert" }
-- Enable backspace on everything
opt.backspace = { "indent", "eol", "start" }
opt.mouse = "a" -- Resize vim splists with a mouse when inside tmux
opt.colorcolumn:append({ "+1" }) -- Draw a line at wrapwidth
opt.grepprg = "rg -nH" -- Use ripgrep as a grep program

-- Less verbose notifications (especailly now that I'm using nvim-notify/noice).
opt.shortmess:append("s") -- don't give "search hit BOTTOM, continuing at TOP", etc, messages.
opt.shortmess:append("W") -- don't give "written" or "[w]" when writing a file

g.mapleader = ","
g.maplocalleader = ","

-- WHen in visual/select/operator mode, I want searching with / to be an inclusive
-- motion. This is acheived by doing /pattern/e, but I don't wanna have to type
-- that /e everytime so:
nvim_set_keymap("v", "/", "//e<Left><Left>", {})
nvim_set_keymap("o", "/", "//e<Left><Left>", {})

-- ]s means go to next spelling error.
nvim_set_keymap("n", "<Leader>s", "]s1z=<C-X><C-S>", {})
-- https://castel.dev/post/lecture-notes-1/#correcting-spelling-mistakes-on-the-fly
-- Insert mode, correct last error.
nvim_set_keymap("i", "<C-v>", "<Esc>[s1z=``a", {})

opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

if vim.loop.os_uname().sysname == "Darwin" then
	g.python3_host_prog = "/usr/local/bin/python3"
else
	print("Umm, not sure what platform(MacOS/linux) I'm on, so won't guess the location of the python binary.")
end

-- This section must come before loading nvim-dap for it not to mess up
-- nvim-dap colors.
-- checks if your terminal has 24-bit color support
g.tokyonight_style = "day"
-- g.snazzybuddy_icons = true
-- g.vscode_style = "light"

-- vim.cmd("colorscheme tokyonight-day")
-- vim.cmd("colorscheme github_dark")
vim.cmd("colorscheme nightfox")

---- Add plugins ----
require("plugins")

---- lnvimrc.vim ----
---- Local vimrc
g.localvimrc_debug = 1
g.localvimrc_name = { ".lnvimrc" }
-- Whitelist everything in home directory
-- https://stackoverflow.com/a/48519356
g.localvimrc_whitelist = { vim.fn.fnamemodify("~", ":p") }
-- Disable "sandbox" mode
g.localvimrc_sandbox = 0

-- Have one global status line
opt.laststatus = 3
-- Have a thin line separating the splits
vim.cmd([[highlight WinSeparator guifg=None guifg=#aaa]])

-- Trying to get neovim's colorscheme to appear identical inside and outside of
-- tmux (inside is messed up a bit right now)
if vim.fn.has("termguicolors") then
	vim.o.termguicolors = true
end

-- Show only errors in virtual text
-- vim.diagnostic.config({
-- 	virtual_text = {
-- 		severity = { min = vim.diagnostic.severity.ERROR },
-- 	},
-- })

-- Quickfix shortcuts
vim.keymap.set("n", "<leader>qo", ":copen<CR>", {})
vim.keymap.set("n", "]q", ":cnext<CR>", {})
vim.keymap.set("n", "[q", ":cprev<CR>", {})
vim.keymap.set("n", "<leader>qq", ":cclose<CR>", {})

-- Add current position to quicklist
local function cur_pos_to_qflist()
	local pos = vim.fn.getpos(".")
	local dict = {
		bufnr = vim.fn.bufnr("%"),
		lnum = pos[2],
		col = pos[3],
		text = vim.api.nvim_get_current_line(),
	}
	vim.fn.setqflist({ dict }, "a")
end

-- Remove quickfix items that match the current *line*
local function remove_curpos_from_qflist()
	local pos = vim.fn.getpos(".")
	local lnum = pos[2]
	local bufnr = vim.fn.bufnr("%")

	local is_not_about_cur_line = function(qflist_item)
		return qflist_item.bufnr ~= bufnr or qflist_item.lnum ~= lnum
	end

	local filtered = require("std2").list_filter(vim.fn.getqflist(), is_not_about_cur_line)
	vim.fn.setqflist(filtered)
end

vim.keymap.set("n", "<leader>qa", cur_pos_to_qflist, {})
vim.keymap.set("n", "<leader>qd", remove_curpos_from_qflist, {})
vim.keymap.set("n", "<leader>qD", function()
	vim.fn.setqflist({})
end, {})

local wk = require("which-key")

wk.register({
	["<leader><C-g>"] = {
		function()
			-- Get absolute file of current file
			local file = vim.fn.expand("%:p")
			-- Copy the above to the system clipboard register
			vim.fn.setreg("+", file)
		end,
		"copy current file path to clipboard register",
	},
})
-- Neovim win!
-- I disabled that because (I belive) the which-key key plugin messes up my "gg" movement
-- because it tries to show a message, but cmdheight=0 prevents it, or something like that.
-- vim.o.cmdheight = 0

-- exercute neovim
wk.register({
	["<leader>lr"] = {
		function()
			local text = vim.fn.join(require("std2").get_visual_selection_text(0), "\n")
			vim.fn.luaeval(text)
		end,
		"source the visual (hopefully lua code) selection into neovim",
	},
}, { mode = "v" })

wk.register({
	["<leader>lc"] = {
		function()
			vim.cmd("nohlsearch")
			vim.lsp.util.buf_clear_references(0)
		end,
		"clear both vim search and LSP reference highlights",
	},
})
-- Highlight what I yanked
---Highlight yanked text
--
local ag = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd
au("TextYankPost", {
	group = ag("yank_highlight", {}),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 100 })
	end,
})
