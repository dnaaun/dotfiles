---comment
---@param jump_dir "forward" | "backward"
---@param query any[]
local jump_function_factory = function(jump_dir, query)
	if jump_dir == "forward" then
		return function()
			require("portal").jump_forward({ query = query })
		end
	elseif jump_dir == "backward" then
		return function()
			require("portal").jump_backward({ query = query })
		end
	else
		error("`jump_dir` must be one of forward or backward")
	end
end

local wk = require("which-key")

wk.add({
	{
		"<leader>o",
		function()
			local jumplist_and_idx = vim.fn.getjumplist()
			local jumplist = jumplist_and_idx[1]
			local idx = jumplist_and_idx[2]

			local cur_bufnr = vim.fn.bufnr()
			P({ "cur_bufnr up top", cur_bufnr })
			while jumplist[idx].bufnr == cur_bufnr do
				idx = idx - 1
				if idx < 1 then
					break
				end
			end

			local loc = jumplist[idx]
			if loc.bufnr ~= cur_bufnr then
				P({ "cur_bufnr", cur_bufnr })
				P(loc)
				vim.api.nvim_set_current_buf(loc.bufnr)
				local pos = {
					loc.bufnr,
					loc.lnum,
					loc.col,
					loc.coladd,
				}
				P({ "pos", pos })
				vim.fn.setpos(".", pos)
			end
		end,
		desc = "jump to prev buffer in jumplist",
	},
})

return {
	"cbochs/portal.nvim",
	module = { "portal", "portal.builtin" },
	config = function()
		require("portal").setup({})
	end,
	dependencies = {
		"ThePrimeagen/harpoon", -- Optional: provides the "harpoon" query item
	},
}
