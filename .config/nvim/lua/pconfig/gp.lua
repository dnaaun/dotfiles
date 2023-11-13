return {
	"robitx/gp.nvim",

	dependencies = { "folke/which-key.nvim" },
	config = function()
		require("gp").setup()

		-- VISUAL mode mappings
		-- s, x, v modes are handled the same way by which_key
		require("which-key").register({
			-- ...
			["<leader>z"] = {
				n = { ":<C-u>'<,'>GpChatNew<cr>", "Visual Chat New" },
				z = { ":<C-u>'<,'>GpChatToggle<cr>", "Visual Popup Chat" },
				r = { ":<C-u>'<,'>GpChatPaste<cr>", "Visual Chat Paste" },

				x = { ":'<,'>GpChatNew split<CR>", "Visual Chat New split" },
				v = { ":'<,'>GpChatNew vsplit<CR>", "Visual Chat New vsplit" },

				w = { ":<C-u>'<,'>GpRewrite<cr>", "Visual Rewrite" },
				a = { ":<C-u>'<,'>GpAppend<cr>", "Visual Append" },
				b = { ":<C-u>'<,'>GpPrepend<cr>", "Visual Prepend" },
				e = { ":<C-u>'<,'>GpEnew<cr>", "Visual Enew" },
				p = { ":<C-u>'<,'>GpPopup<cr>", "Visual Popup" },
				s = { "<cmd>GpStop<cr>", "Stop" },

				-- optional Whisper commands
				-- w = { ":<C-u>'<,'>GpWhisper<cr>", "Whisper" },
				-- R = { ":<C-u>'<,'>GpWhisperRewrite<cr>", "Whisper Visual Rewrite" },
				-- A = { ":<C-u>'<,'>GpWhisperAppend<cr>", "Whisper Visual Append" },
				-- B = { ":<C-u>'<,'>GpWhisperPrepend<cr>", "Whisper Visual Prepend" },
				-- E = { ":<C-u>'<,'>GpWhisperEnew<cr>", "Whisper Visual Enew" },
				-- P = { ":<C-u>'<,'>GpWhisperPopup<cr>", "Whisper Visual Popup" },
			},
			-- ...
		}, {
			mode = "v", -- VISUAL mode
			prefix = "",
			buffer = nil,
			silent = true,
			noremap = true,
			nowait = true,
		})

		-- NORMAL mode mappings
		require("which-key").register({
			-- ...
			["<leader>z"] = {
				n = { "<cmd>GpChatNew<cr>", "New Chat" },
				z = { "<cmd>GpChatToggle<cr>", "Toggle Popup Chat" },
				f = { "<cmd>GpChatFinder<cr>", "Chat Finder" },

				x = { "<cmd>GpChatNew split<cr>", "New Chat split" },
				v = { "<cmd>GpChatNew vsplit<cr>", "New Chat vsplit" },

				w = { "<cmd>GpRewrite<cr>", "Inline Rewrite" },
				a = { "<cmd>GpAppend<cr>", "Append" },
				b = { "<cmd>GpPrepend<cr>", "Prepend" },
				e = { "<cmd>GpEnew<cr>", "Enew" },
				p = { "<cmd>GpPopup<cr>", "Popup" },
				s = { "<cmd>GpStop<cr>", "Stop" },
			},
		}, {
			mode = "n", -- NORMAL mode
			prefix = "",
			buffer = nil,
			silent = true,
			noremap = true,
			nowait = true,
		})

		-- INSERT mode mappings
		require("which-key").register({
			-- ...
			["<C-g>"] = {
				c = { "<cmd>GpChatNew<cr>", "New Chat" },
				z = { "<cmd>GpChatToggle<cr>", "Toggle Popup Chat" },
				f = { "<cmd>GpChatFinder<cr>", "Chat Finder" },

				x = { "<cmd>GpChatNew split<cr>", "New Chat split" },
				v = { "<cmd>GpChatNew vsplit<cr>", "New Chat vsplit" },

				w = { "<cmd>GpRewrite<cr>", "Inline Rewrite" },
				a = { "<cmd>GpAppend<cr>", "Append" },
				b = { "<cmd>GpPrepend<cr>", "Prepend" },
				e = { "<cmd>GpEnew<cr>", "Enew" },
				p = { "<cmd>GpPopup<cr>", "Popup" },
				s = { "<cmd>GpStop<cr>", "Stop" },

				-- optional Whisper commands
				-- w = { "<cmd>GpWhisper<cr>", "Whisper" },
				-- R = { "<cmd>GpWhisperRewrite<cr>", "Whisper Inline Rewrite" },
				-- A = { "<cmd>GpWhisperAppend<cr>", "Whisper Append" },
				-- B = { "<cmd>GpWhisperPrepend<cr>", "Whisper Prepend" },
				-- E = { "<cmd>GpWhisperEnew<cr>", "Whisper Enew" },
				-- P = { "<cmd>GpWhisperPopup<cr>", "Whisper Popup" },
			},
			-- ...
		}, {
			mode = "i", -- INSERT mode
			prefix = "",
			buffer = nil,
			silent = true,
			noremap = true,
			nowait = true,
		})
	end,
}
