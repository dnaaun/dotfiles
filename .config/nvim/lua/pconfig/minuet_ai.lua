return {
	"milanglacier/minuet-ai.nvim",
	config = function()
		require("minuet").setup({
			provider = "openai",
			provider_options = {
				openai = {
					model = "gpt-4o-mini",
					stream = true,
					api_key = "OPENAI_API_KEY",
				},
			},

			virtualtext = {
				auto_trigger_ft = { "python" },
				keymap = {
					-- accept whole completion
					accept = "<C-e>",
					-- Cycle to prev completion item, or manually invoke completion
					prev = "<C-[>",
					-- Cycle to next completion item, or manually invoke completion
					next = "<C-]>",
					dismiss = "<A-e>",
				},
			},
		})
	end,
}
