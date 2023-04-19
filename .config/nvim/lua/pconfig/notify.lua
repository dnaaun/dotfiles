return {
	"rcarriga/nvim-notify",
	config = function()
		-- Using this, we can do `require('telescope').extensions.notify.notify(<opts>)` to
		-- launch telescope and search through notification history.
		require("telescope").load_extension("notify")

		local notify = require("notify")
    notify.setup({
      render = "minimal",
      stages = {},
    })

		local wk = require("which-key")
		wk.register({
			["<Leader>n"] = {
				name = "notifications",
				d = { notify.dismiss, "dismiss notifictions" },
				f = { require("telescope").extensions.notify.notify, "show past notifications" },
			},
		})
	end,
}
