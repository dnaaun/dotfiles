return {

	"hrsh7th/nvim-cmp",
	config = function()
		-- Setup nvim-cmp.
		local has_words_before = function()
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		end

		local cmp = require("cmp")

		--- We have this so that we can show the completion source in the completion
    --- menu for each item.
		---@param entry cmp.Entry
		---@param vim_item vim.CompletedItem
		---@return vim.CompletedItem
		local function cmp_item_formatting(entry, vim_item)
			vim_item.menu = "[" .. entry.source.name .. "]"
      return vim_item
		end

		cmp.setup({
			experimental = {
				ghost_text = true,
			},
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = {
				["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
				["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
				["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
				["<C-e>"] = cmp.mapping({
					i = cmp.mapping.abort(),
					c = cmp.mapping.close(),
				}),
				["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif has_words_before() then
						cmp.complete()
					else
						fallback()
					end
				end, { "i", "s" }),

				["<C-Space>"] = cmp.mapping.complete({
					config = {
						sources = {
							{ name = "copilot" },
						},
					},
				}),

				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					else
						fallback()
					end
				end, { "i", "s" }),
			},
			enabled = function()
				-- nvim-cmp by defaults disables autocomplete for prompt buffers
				return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
			end,
			sources = {
				{ name = "dap" },
				{ name = "nvim_lsp" },
				{ name = "copilot" },
				{ name = "luasnip", priority = 100 },
				{ name = "path" },
				{
					name = "spell",
					option = {
						keep_all_entries = false,
						-- https://github.com/f3fora/cmp-spell#enable_in_context
						enable_in_context = function()
							return true
							-- return require("cmp.config.context").in_treesitter_capture("spell")
						end,
					},
				},
				{ name = "buffer", keyword_length = 5 },
			},

			comparators = {
				require("copilot_cmp.comparators").prioritize,
				require("copilot_cmp.comparators").score,

				-- Below is the default comparator list and order for nvim-cmp
				cmp.config.compare.offset,
				-- cmp.config.compare.scopes, --this is commented in nvim-cmp too

				-- The original order of the below two was reversed.
				-- I changed it because exact dictionary matches are being
				-- ranked higher than (what I hope are) higher scoring,
				-- luasnip matches.
				cmp.config.compare.score,
				cmp.config.compare.exact,

				cmp.config.compare.recently_used,
				cmp.config.compare.locality,
				cmp.config.compare.kind,
				cmp.config.compare.sort_text,
				cmp.config.compare.length,
				cmp.config.compare.order,
			},

			formatting = {
				format = cmp_item_formatting,
			},
		})
	end,
	after = { "copilot-cmp" },
}
