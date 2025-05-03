return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
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

    -- This was an attempt to remove the codium source for specific file types. Didn't work.
		codium_source = {
			{ name = "codeium", keyword_length = 0 },
		}
		all_sources_except_codium = {
			{
				{ name = "otter" },
			},
			{
				{ name = "copilot", keyword_length = 0 },
				{ name = "git" },
			},
			{
				{ name = "luasnip", priority = 100, keyword_length = 0 },
			},
			{
				{ name = "dap" },
				{ name = "nvim_lsp", priority = 100, keyword_length = 2 },
				{ name = "path" },
				-- { name = "orgmode" },
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
		}

		all_sources = {}
    vim.list_extend(all_sources, codium_source)
    vim.list_extend(all_sources, all_sources_except_codium)

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
				["<CR>"] = cmp.mapping.confirm({
					select = true,
					behavior = cmp.ConfirmBehavior.Replace,
				}), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif has_words_before() then
						cmp.complete()
					else
						fallback()
					end
				end, { "i", "s" }),

				["<C-j>"] = cmp.mapping.complete({
					config = {
						sources = {
							{ name = "codium", keyword_length = 0 },
						},
					},
				}),

				["<C-Space>"] = cmp.mapping.complete({}),

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
				-- check if the cmp_dap module is loaded in lua
				local cmp_dap_loaded = pcall(require, "cmp_dap")
				-- if cmp_dap is loaded, check if the current buffer is a dap buffer
				local is_dap_buffer = cmp_dap_loaded and require("cmp_dap").is_dap_buffer()
				return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or is_dap_buffer
			end,

			sources = cmp.config.sources(unpack(all_sources)),

			comparators = {
				-- Disabling these for now because, while migraitng to lazzy.nvim, I noticed the lines
				-- below imply a dependency cycle between cmp-copilot (or copilot-cmp, idk) and nvim-cmp.
				-- require("copilot_cmp.comparators").prioritize,
				-- require("copilot_cmp.comparators").score,

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

			-- Attempt to get nvim-cmp to trigger on InsertEnter.
			-- This is currently not working.
			completion = {
				completeopt = "menu,menuone,noinsert,noselect",
				autocomplete = {
					cmp.TriggerEvent.TextChanged,
					cmp.TriggerEvent.InsertEnter,
				},

				keyword_length = 0,
			},
		})


		for _, ft in ipairs({ "tex", "latex" }) do
			cmp.setup.filetype(filetype, {
				sources = cmp.config.sources(unpack(all_sources_except_codium)),
			})
		end

		-- Another attempt to get nvim-cmp to trigger on InsertEnter.
		-- This is currently not working.
		require("cmp.utils.autocmd").subscribe({ "InsertEnter" }, function()
			if require("cmp.config").enabled() then
				cmp.core:on_change("TextChanged")
			end
		end)
	end,
}
