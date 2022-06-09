return {
	"rcarriga/nvim-notify",
	config = function()
    -- Using this, we can do `require('telescope').extensions.notify.notify(<opts>)` to 
    -- launch telescope and search through notification history.
		require("telescope").load_extension("notify")
	end,
}
