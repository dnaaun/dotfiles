return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- event = "CursorHold",
	enabled = not vim.g.started_by_firenvim,
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = true,
				refresh = {
					statusline = 2000,
					tabline = 1000,
					winbar = 1000,
				},
			},
			sections = {
				lualine_a = {},
				lualine_b = {
					-- {
					-- 	function()
					-- 		local handle = io.popen("/Users/davidat/git/bash_prompt/target/release/bash_prompt")
					-- 		local result = handle:read("*a")
					-- 		handle:close()
					-- 		return result
					-- 	end,
					-- },
				},
				lualine_c = {
					"filename",
					{
						"diagnostics",
						sources = { "nvim_workspace_diagnostic" },
					},
				},
				lualine_x = {
					function()
						return require("codeium.virtual_text").status_string()
					end,
					"harpoon2",
					"filetype",
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {
				lualine_a = { "tabs" },
				lualine_z = { "buffers" },
			},
			winbar = {},
			inactive_winbar = {
				-- lualine_c = { "filename" },
			},
			extensions = {},
		})
	end,
}
