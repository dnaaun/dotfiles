-- I don't know why I disabled you, but I must have a pretty good reason.
-- require('impatient') -- Speed up loading things. TOFIXLATER: This will probably (definitely?) break when impatient.nvim is not installed.

local detect_if_in_simple_mode_group = vim.api.nvim_create_augroup("DetectIfWeAreInSimpleMode", {
	clear = true,
})

-- When neovim is opened, detect if the file type is `gitrebase`
vim.api.nvim_create_autocmd({ "VimEnter" }, {
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

-- NOTE: Disabling because I this interfers with a telescope mapping to search files.
-- nvim_set_keymap("n", "<Leader>s", "]s1z=<C-X><C-S>", {})
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
vim.cmd("colorscheme dayfox")

---- Add plugins ----
-- require("plugins")

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
vim.keymap.set("n", "<leader>qo", "<cmd>copen<CR>", {})
vim.keymap.set("n", "]q", "<cmd>cnext<CR>", {})
vim.keymap.set("n", "[q", "<cmd>cprev<CR>", {})
vim.keymap.set("n", "<leader>qq", "<cmd>cclose<CR>", {})

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

local function remove_quickfix_entry_on_current_line_and_move_on()
	local bufnr = vim.api.nvim_get_current_buf()
	local current_line = vim.api.nvim_win_get_cursor(0)[1]

	local qflist = vim.fn.getqflist()
	local qf_index_to_remove = nil

	for i, entry in ipairs(qflist) do
		if entry.bufnr == bufnr and entry.lnum == current_line then
			qf_index_to_remove = i
			break
		end
	end

	if qf_index_to_remove then
		table.remove(qflist, qf_index_to_remove)
		vim.fn.setqflist(qflist)
		print("Removed quickfix entry on current line")

		-- Move to the quickfix item immediately after the removed item, if it exists
		local next_qf_entry = qflist[qf_index_to_remove]
		if next_qf_entry then
			if next_qf_entry.bufnr and next_qf_entry.lnum then
				vim.api.nvim_command("buffer " .. next_qf_entry.bufnr)
				vim.api.nvim_win_set_cursor(0, { next_qf_entry.lnum, next_qf_entry.col })
			elseif next_qf_entry.filename and next_qf_entry.lnum then
				vim.api.nvim_command("edit " .. vim.fn.fnameescape(next_qf_entry.filename))
				vim.api.nvim_win_set_cursor(0, { next_qf_entry.lnum, next_qf_entry.col })
			end
		end
	else
		print("No quickfix entry found on current line")
	end
end

vim.keymap.set("n", "<leader>qa", cur_pos_to_qflist, { desc = "Add current position to quickfix" })
vim.keymap.set(
	"n",
	"<leader>qd",
	remove_quickfix_entry_on_current_line_and_move_on,
	{ desc = "Remove current position from quickfix" }
)
vim.keymap.set("n", "<leader>qD", function()
	vim.fn.setqflist({})
end, { desc = "Clear quickfix" })

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

-- map `<leader>w` to `:silent write<CR>`
-- Otherwise, it will show info about the saved file.
-- Also, two, far away keys (ie,  `<leader>w`) are easier to type than three keys`:w<CR>`
vim.keymap.set("n", "<leader>w", function()
	vim.fn.execute("silent write")
end, { noremap = true, desc = "<CR>silent write" })

--- Bootsrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

-- Some users may want to split their plugin specs in multiple files. Instead of
-- passing a spec table to setup(), you can use a Lua module. The specs from the
-- module and any top-level sub-modules will be merged together in the final
-- spec, so it is not needed to add require calls in your main plugin file to
-- the other files.
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")

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
      if pcall(require, "noice") then
        require("noice").cmd("dismiss")
      end
		end,
		"clear both vim search and LSP reference highlights",
	},
})

