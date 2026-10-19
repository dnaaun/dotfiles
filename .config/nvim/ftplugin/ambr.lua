vim.keymap.set("n", "gs", function()
	require("syrupy_snapshot").goto_test()
end, { buffer = true, desc = "go to pytest test of syrupy snapshot" })
