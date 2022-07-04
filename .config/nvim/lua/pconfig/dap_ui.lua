return {
	"rcarriga/nvim-dap-ui",
	after = { "nvim-dap" },
	config = function()
		require("dapui").setup()
	end,
}
