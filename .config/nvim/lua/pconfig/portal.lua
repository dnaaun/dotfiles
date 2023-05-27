return {
	"cbochs/portal.nvim",
	keys = {
		"<leader>oi",
		"<leader>od",
		"<leader>ov",
		"<leader>oh",
		"<leader>id",
		"<leader>iv",
		"<leader>ih",
	},
	config = function()
		require("portal").setup({
			query = { "different", "harpoon", "valid" },

			integrations = {
				---ThePrimeagen/harpoon: registers the "harpoon" query item
				harpoon = true,
			},
		})

		local wk = require("which-key")

		---comment
		---@param jump_dir "forward" | "backward"
		---@param query any[]
		local jump_function_factory = function(jump_dir, query)
			if jump_dir == "forward" then
				return function()
					require("portal").jump_forward({ query = query })
				end
			elseif jump_dir == "backward" then
				return function()
					require("portal").jump_backward({ query = query })
				end
			else
				error("`jump_dir` must be one of forward or backward")
			end
		end

		wk.register({
			["<leader>"] = {
				o = {
					name = "jump backward",
					d = {
						jump_function_factory("backward", { "different" }),
						"jump back to last different buffer",
					},
					v = {
						jump_function_factory("backward", { "valid" }),
						"jump back to last valid buffer",
					},
					h = {
						jump_function_factory("backward", { "harpoon" }),
						"jump back to last harpoon buffer",
					},
				},
				i = {
					name = "jump forward",
					d = {
						jump_function_factory("forward", { "different" }),
						"jump forward to different buffer",
					},
					v = {
						jump_function_factory("forward", { "valid" }),
						"jump forward to valid buffer",
					},
					h = {
						jump_function_factory("forward", { "harpoon" }),
						"jump forward to next harpoon buffer",
					},
				},
			},
		})
	end,
	dependencies = {
		"ThePrimeagen/harpoon", -- Optional: provides the "harpoon" query item
	},
}
