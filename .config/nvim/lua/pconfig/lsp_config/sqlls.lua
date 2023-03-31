return {
	root_dir = require("lspconfig").util.root_pattern(".sqllsrc.json", ".git") or vim.loop.os_homedir(),
	cmd = { "sql-language-server", "up", "--method", "stdio" },
}
