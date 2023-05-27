return {
	"rcarriga/nvim-dap-ui",
	dependencies = { "nvim-dap" },

  -- Lazy load with the same keys as pconfig/dap.lua
  keys = require("pconfig.dap").keys,

	config = function()
		require("dapui").setup()
	end,
}
