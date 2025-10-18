return {
	cmd = {
		vim.fn.expand("~") .. "/src/kotlin-language-server/server/build/install/server/bin/kotlin-language-server",
	},
	root_dir = function(fname)
		local settings_files = vim.fs.find({ 'settings.gradle.kts', 'settings.gradle' }, {
			path = fname,
			upward = true
		})
		return settings_files[1] and vim.fs.dirname(settings_files[1])
	end,
}