return {
	"phaazon/hop.nvim",

	ft = { "tex", "latex" },

	config = function()
		local hop = require("hop")
		local wk = require("which-key")

		hop.setup({})
		local mappings = {
			["f"] = {
				function()
					require("hop").hint_char1({ multi_windows = true })
				end,
				"Hop",
			},
		}
    -- NOTE: Until I figure out how to make sure noice.lua doesn't interfere
    -- with the entry that these mappings pull up, I've commented them out.
		-- wk.register(mappings, { mode = "n", silent = true })
		-- wk.register(mappings, { mode = "o", silent = true })
		-- wk.register(mappings, { mode = "x", silent = true })

		-- Create a buffer mapping in an autocmd for latex files.
		vim.api.nvim_create_autocmd({ "BufEnter", "BufCreate" }, {
			pattern = { "*.tex", "*.txt" },
			callback = function(args)
				local wk = require("which-key")
				wk.register({
					["t"] = {
						function()
							require("hop").hint_char2({ multi_windows = true })
						end,
						"Hop",
					},
				}, {
					mode = "n",
					silent = true,
					buffer = args.buf,
				})
			end,
		})
	end,
}
