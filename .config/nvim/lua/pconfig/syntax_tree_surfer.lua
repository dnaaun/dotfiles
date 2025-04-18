return {
	"ziontee113/syntax-tree-surfer",
  event = "VeryLazy",
	config = function()
		require("syntax-tree-surfer")

		-- Syntax Tree Surfer
		local opts = { noremap = true, silent = true }

		-- Normal Mode Swapping:
		-- Swap The Master Node relative to the cursor with it's siblings, Dot Repeatable
		vim.keymap.set("n", "vD", function()
			vim.opt.opfunc = "v:lua.STSSwapUpNormal_Dot"
			return "g@l"
		end, { silent = true, expr = true, desc = "STS Swap Master Up" })
		vim.keymap.set("n", "vU", function()
			vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"
			return "g@l"
		end, { silent = true, expr = true, desc = "STS Swap Master Down" })

		-- Swap Current Node at the Cursor with it's siblings, Dot Repeatable
		vim.keymap.set("n", "vd", function()
			vim.opt.opfunc = "v:lua.STSSwapCurrentNodeNextNormal_Dot"
			return "g@l"
		end, { silent = true, expr = true, desc = "STS Swap Current Next" })
		vim.keymap.set("n", "vu", function()
			vim.opt.opfunc = "v:lua.STSSwapCurrentNodePrevNormal_Dot"
			return "g@l"
		end, { silent = true, expr = true, desc = "STS Swap Current Prev" })

		-- Visual Selection from Normal Mode
		vim.keymap.set("n", "vx", "<cmd>STSSelectMasterNode<cr>", opts)
		vim.keymap.set("n", "vn", "<cmd>STSSelectCurrentNode<cr>", opts)

		-- Select Nodes in Visual Mode
		vim.keymap.set("x", "J", "<cmd>STSSelectNextSiblingNode<cr>", opts)
		vim.keymap.set("x", "K", "<cmd>STSSelectPrevSiblingNode<cr>", opts)
		vim.keymap.set("x", "H", "<cmd>STSSelectParentNode<cr>", opts)
		vim.keymap.set("x", "L", "<cmd>STSSelectChildNode<cr>", opts)

		-- Swapping Nodes in Visual Mode
		vim.keymap.set("x", "vj", "<cmd>STSSwapNextVisual<cr>", opts)
		vim.keymap.set("x", "vk", "<cmd>STSSwapPrevVisual<cr>", opts)
	end,
}
