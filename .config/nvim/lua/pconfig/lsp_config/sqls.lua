return {
	on_attach = function(client, bufnr)
		require("sqls").on_attach(client, bufnr) -- require sqls.nvim
	end,
	settings = {
		sqls = {
			connections = {
				{
					driver = "postgresql",
					dataSourceName = "host=127.0.0.1 port=5432 user=hybrid password=hybrid dbname=hybrid_development",
				},
			},
		},
	},
}
