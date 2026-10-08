-- GitHub PR review comments as ghost text, edited in floating buffers, for jj
-- repos. The plugin only exposes lua functions; every mapping lives here and
-- starts with <leader>r.
local plugin_dir = vim.fn.expand("~/git/dotfiles/neovim_plugins/jj-gh-review.nvim")

local function review(fn, ...)
	local args = { ... }
	return function()
		require("jj_gh_review")[fn](unpack(args))
	end
end

return {
	name = "jj-gh-review.nvim",
	dir = plugin_dir,
	cmd = { "Review", "ReviewComment", "ReviewClose" },
	keys = {
		{ "<leader>rr", ":Review ", desc = "Review: open PR (type a specifier)" },
		{ "<leader>rc", review("comment"), mode = { "n", "x" }, desc = "Review: new comment on line / selection" },
		{ "<leader>rv", review("view"), desc = "Review: view thread(s) on this line" },
		{ "<leader>rj", review("next"), desc = "Review: next commented line" },
		{ "<leader>rk", review("prev"), desc = "Review: previous commented line" },
		{ "<leader>rl", review("list"), desc = "Review: all threads in quickfix" },
		{ "<leader>rt", review("toggle_resolved"), desc = "Review: toggle resolved" },
		{ "<leader>rd", review("delete_comment"), desc = "Review: delete my comment" },
		{ "<leader>ro", review("open_in_browser"), desc = "Review: open on GitHub" },
		{ "<leader>rS", review("submit_review"), desc = "Review: submit pending review" },
		{ "<leader>rR", review("refresh"), desc = "Review: re-fetch comments" },
		{ "<leader>rs", review("sync"), desc = "Review: push queued changes now" },
		{ "<leader>rx", review("drop_failed"), desc = "Review: drop failed queued changes" },
		{ "<leader>rq", review("close"), desc = "Review: end session (clear ghost text)" },
	},
	config = function()
		require("jj_gh_review").setup()

		-- Buffer-local mappings inside the floating thread/comment buffers.
		vim.api.nvim_create_autocmd("User", {
			group = vim.api.nvim_create_augroup("pconfig_jj_gh_review", { clear = true }),
			pattern = "JjGhReviewThreadBuffer",
			callback = function(args)
				local buf = args.data.buf
				local opts = { buffer = buf, silent = true }
				vim.keymap.set("n", "q", function()
					require("jj_gh_review.ui").close()
				end, vim.tbl_extend("force", opts, { desc = "Review: close float" }))
				vim.keymap.set("n", "<leader>rd", function()
					require("jj_gh_review").delete_comment()
				end, vim.tbl_extend("force", opts, { desc = "Review: delete comment under cursor" }))
				vim.keymap.set("n", "<leader>rt", function()
					require("jj_gh_review").toggle_resolved()
				end, vim.tbl_extend("force", opts, { desc = "Review: toggle resolved" }))
			end,
		})
	end,
}
