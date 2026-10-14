vim.keymap.set("n", "gs", function()
	require("syrupy_snapshot").goto_snapshot()
end, { buffer = true, desc = "go to syrupy snapshot" })
