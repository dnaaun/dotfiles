local root_pattern = require("lspconfig").util.root_pattern;

return {
	cmd = {
		vim.fn.expand("~") .. "/src/kotlin-language-server/server/build/install/server/bin/kotlin-language-server",
	},
	root_dir = root_pattern("settings.gradle.kts") or root_pattern("settings.gradle"),
}
