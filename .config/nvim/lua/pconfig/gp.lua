local CODING_SYSTEM_PROMPT =
	"You are a coding AI assistant. Unless the user explicitly asks a question that, in no way shape or form, can be answered by a code snippet performing what the user asks for, PLEASE PROVIDE YOUR ANSWER  ONLY (I REPEAT, ONLY) IN A MARKDOWN CODE BLOCK, WITH NO OTHER SURROUNDING TEXT. PLEASE ASSUME THIS IS THE CASE UNLESS IT'S CLEAR, BEYOND A SHADOW OF  DOUBT, THAT THE USER WANTS EXPOSITORY/NON-CODE interaction.\n\n"
return {
	"robitx/gp.nvim",
	dependencies = { "folke/which-key.nvim" },
	-- keys = { "<leader>z" },
	config = function()
		-- VISUAL mode mappings
		vim.keymap.set("v", "<leader>zn", ":<C-u>'<,'>GpChatNew<cr>", { desc = "Visual Chat New" })
		vim.keymap.set("v", "<leader>zz", ":<C-u>'<,'>GpChatToggle<cr>", { desc = "Visual Popup Chat" })
		vim.keymap.set("v", "<leader>zr", ":<C-u>'<,'>GpChatPaste<cr>", { desc = "Visual Chat Paste" })
		vim.keymap.set("v", "<leader>zx", ":'<,'>GpChatNew split<CR>", { desc = "Visual Chat New split" })
		vim.keymap.set("v", "<leader>zv", ":'<,'>GpChatNew vsplit<CR>", { desc = "Visual Chat New vsplit" })
		vim.keymap.set("v", "<leader>zw", ":<C-u>'<,'>GpRewrite<cr>", { desc = "Visual Rewrite" })
		vim.keymap.set("v", "<leader>za", ":<C-u>'<,'>GpAppend<cr>", { desc = "Visual Append" })
		vim.keymap.set("v", "<leader>zb", ":<C-u>'<,'>GpPrepend<cr>", { desc = "Visual Prepend" })
		vim.keymap.set("v", "<leader>ze", ":<C-u>'<,'>GpEnew<cr>", { desc = "Visual Enew" })
		vim.keymap.set("v", "<leader>zp", ":<C-u>'<,'>GpPopup<cr>", { desc = "Visual Popup" })
		vim.keymap.set("v", "<leader>zs", "<cmd>GpStop<cr>", { desc = "Stop" })

		-- NORMAL mode mappings
		vim.keymap.set("n", "<leader>zn", "<cmd>GpChatNew<cr>", { desc = "New Chat" })
		vim.keymap.set("n", "<leader>zz", "<cmd>GpChatToggle<cr>", { desc = "Toggle Popup Chat" })
		vim.keymap.set("n", "<leader>zf", "<cmd>GpChatFinder<cr>", { desc = "Chat Finder" })
		vim.keymap.set("n", "<leader>zx", "<cmd>GpChatNew split<cr>", { desc = "New Chat split" })
		vim.keymap.set("n", "<leader>zv", "<cmd>GpChatNew vsplit<cr>", { desc = "New Chat vsplit" })
		vim.keymap.set("n", "<leader>zw", "<cmd>GpRewrite<cr>", { desc = "Inline Rewrite" })
		vim.keymap.set("n", "<leader>za", "<cmd>GpAppend<cr>", { desc = "Append" })
		vim.keymap.set("n", "<leader>zb", "<cmd>GpPrepend<cr>", { desc = "Prepend" })
		vim.keymap.set("n", "<leader>ze", "<cmd>GpEnew<cr>", { desc = "Enew" })
		vim.keymap.set("n", "<leader>zp", "<cmd>GpPopup<cr>", { desc = "Popup" })
		vim.keymap.set("n", "<leader>zs", "<cmd>GpStop<cr>", { desc = "Stop" })

		require("gp").setup({
			providers = {
				openai = {
					endpoint = "https://api.openai.com/v1/chat/completions",
					secret = os.getenv("OPENAI_API_KEY"),
				},

				-- azure = {...},

				copilot = {
					endpoint = "https://api.githubcopilot.com/chat/completions",
					secret = {
						"bash",
						"-c",
						"cat ~/.config/github-copilot/hosts.json | sed -e 's/.*oauth_token...//;s/\".*//'",
					},
				},

				pplx = {
					endpoint = "https://api.perplexity.ai/chat/completions",
					secret = os.getenv("PPLX_API_KEY"),
				},

				ollama = {
					endpoint = "http://localhost:11434/v1/chat/completions",
				},

				googleai = {
					endpoint = "https://generativelanguage.googleapis.com/v1beta/models/{{model}}:streamGenerateContent?key={{secret}}",
					secret = os.getenv("GOOGLEAI_API_KEY"),
				},

				anthropic = {
					endpoint = "https://api.anthropic.com/v1/messages",
					secret = os.getenv("ANTHROPIC_API_KEY"),
				},
			},

			agents = {
				{
					provider = "anthropic",
					name = "Sonnet35",
					chat = true,
					command = false,
					-- string with model name or table with model name and parameters
					model = { model = "claude-3-5-sonnet-20240620" },
					-- system prompt (use this to specify the persona/role of the AI)
					system_prompt = require("gp.defaults").chat_system_prompt,
				},
				{
					name = "Sonnet37",
					provider = "anthropic",
					chat = true,
					command = true,
					model = { model = "claude-3-7-sonnet-20250219" },
					system_prompt = "You're a coding assistant. Lean towards being brief (e.g., providing a code snippet answer only) if the question can at all be answered in a brief way. Don't be afraid to be not brief if the question clearly beckons a wider exploration.",
				},
				{
					name = "GPT4O",
					provider = "openai",
					chat = true,
					command = true,
					model = { model = "gpt-4o" },
					system_prompt = "You're a coding assistant. Lean towards being brief (e.g., providing a code snippet answer only) if the question can at all be answered in a brief way. Don't be afraid to be not brief if the question clearly beckons a wider exploration.",
				},
				{
					name = "GPT4OMini",
					provider = "openai",
					chat = true,
					command = true,
					model = { model = "gpt-4o-mini-2024-07-18" },
					system_prompt = "You're a coding assistant. Lean towards being brief (e.g., providing a code snippet answer only) if the question can at all be answered in a brief way. Don't be afraid to be not brief if the question clearly beckons a wider exploration.",
				},
			},
		})

		-- I don't know of an official way to set the default agent on startup, so I use
		-- an undocumented/internal API:
		require("gp")._state.chat_agent = "GPT4O"

		-- VISUAL mode mappings
		-- s, x, v modes are handled the same way by which_key
	end,
}
