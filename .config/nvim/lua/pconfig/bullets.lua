-- without this, I get a vim error:
-- E120: Using <SID> not in a script context: <SID>insert_new_bullet
-- when pressing enter in orgmode files (with bullets.vim enabled)
-- NOTE: Startup time for orgmode seems to be eaten up here.
-- vim.api.nvim_create_autocmd({ "FileType", "BufEnter", "BufCreate" }, {
-- 	pattern = { "org" },
-- 	group = vim.api.nvim_create_augroup("WorkAroundForBulletsVimBreakingOrgFiles", {}),
-- 	callback = function()
-- 		vim.keymap.set("i", "<CR>", "<cmd>:InsertNewBullet<CR>", { remap = false, buffer = true })
-- 	end,
-- })

vim.g.bullets_enabled_file_types = { "org", "markdown", "text", "gitcommit", "norg" }
vim.g.bullets_set_mappings = 1

return { "dkarter/bullets.vim", ft = vim.g.bullets_enabled_file_types }
