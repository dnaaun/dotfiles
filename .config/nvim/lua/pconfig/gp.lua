return {
	"robitx/gp.nvim",

	dependencies = { "folke/which-key.nvim" },
	config = function()
		require("gp").setup({
			agents = {
				{
					name = "ChatGPT4",
					chat = true,
					command = false,
					-- string with model name or table with model name and parameters
					model = { model = "gpt-4-1106-preview", temperature = 1.1, top_p = 1 },
          system_prompt = "You are a general AI assistant. Be as curt as possible.",
					-- system prompt (use this to specify the persona/role of the AI)
					-- system_prompt = "You are a general AI assistant.\n\n"
						-- .. "The user provided the additional info about how they would like you to respond:\n\n"
						-- .. "- If you're unsure don't guess and say you don't know instead.\n"
						-- .. "- Ask question if you need clarification to provide better answer.\n"
						-- .. "- Think deeply and carefully from first principles step by step.\n"
						-- .. "- Zoom out first to see the big picture and then zoom in to details.\n"
						-- .. "- Use Socratic method to improve your thinking and coding skills.\n"
						-- .. "- Don't elide any code from your output if the answer requires coding.\n"
						-- .. "- Take a deep breath; You've got this!\n",
				},
			},
		})

		-- I don't know of an official way to set the default agent on startup, so I use
		-- an undocumented/internal API:
		require("gp")._state.chat_agent = "ChatGPT4"

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
