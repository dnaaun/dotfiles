if vim.g.loaded_jj_gh_review then
	return
end
vim.g.loaded_jj_gh_review = true

vim.api.nvim_create_user_command("Review", function(opts)
	require("jj_gh_review").open(opts.args)
end, {
	nargs = "?",
	complete = function(arg_lead)
		return require("jj_gh_review").complete(arg_lead)
	end,
	desc = "Review a GitHub PR (any `gh pr view` specifier) with inline comments",
})

vim.api.nvim_create_user_command("ReviewComment", function(opts)
	require("jj_gh_review").comment({ line1 = opts.line1, line2 = opts.line2 })
end, { range = true, desc = "Start a review comment on the given line range" })

vim.api.nvim_create_user_command("ReviewClose", function()
	require("jj_gh_review").close()
end, { desc = "End the active review session" })
