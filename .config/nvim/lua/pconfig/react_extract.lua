-- I want to have these maps only for react-y files only,
-- but I don't have enough knowledgetime to accomplish that.
vim.keymap.set({ "v" }, "<Leader>le", function()
	require("react-extract").extract_to_new_file()
end, { desc = "(React) extract to new file" })
vim.keymap.set({ "v" }, "<Leader>lc", function()
	require("react-extract").extract_to_current_file()
end, { desc = "(React) extract to current file" })

return {
	"napmn/react-extract.nvim",
	module = "react-extract",
	config = function()
		-- Using setup function with default values
		require("react-extract").setup({
			ts_type_property_template = "[INDENT][PROPERTY]: any\n",
			ts_template_before = "type [COMPONENT_NAME]Props = {\n[TYPE_PROPERTIES]}\n[EMPTY_LINE]\n"
				.. "export const [COMPONENT_NAME]: React.FC<[COMPONENT_NAME]Props> = "
				.. "([PROPERTIES]) => {\n"
				.. "[INDENT]return (\n",
			ts_template_after = "[INDENT])\n}",
			js_template_before = "export const [COMPONENT_NAME] = " .. "([PROPERTIES]) => {\n" .. "[INDENT]return (\n",
			js_template_after = "[INDENT])\n}",
			jsx_indent_level = 2,
			use_class_props = false,
			use_autoimport = true,
			autoimport_defer_ms = 350,
			local_extract_strategy = "BEFORE",
		})
	end,
}
