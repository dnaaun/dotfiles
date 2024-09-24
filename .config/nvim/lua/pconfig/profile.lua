_G.toggle_profile = function()
	local prof = require("profile")
	if prof.is_recording() then
		prof.stop()
		vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" }, function(filename)
			if filename then
				prof.export(filename)
				vim.notify(string.format("Wrote %s", filename))
			end
		end)
	else
		prof.start("*")
	end
end

vim.keymap.set("", "<f1>", _G.toggle_profile, { desc = "toggle_profile" })

return {
	"stevearc/profile.nvim",
	config = function() end,
}
