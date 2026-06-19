local M = {}

local function parse_args(args)
	local opt = {}
	local i = 1

	while i <= #args do
		local arg = args[i]
		local key, value = arg:match("^%-%-([%w-]+)=(.*)$")
		local short_key, short_value = arg:match("^%-([rft])=(.*)$")

		if key == "revisions" or short_key == "r" then
			opt.revisions = value or short_value
		elseif key == "from" or short_key == "f" then
			opt.from = value or short_value
		elseif key == "to" or short_key == "t" then
			opt.to = value or short_value
		elseif arg == "--revisions" or arg == "-r" then
			i = i + 1
			opt.revisions = args[i]
		elseif arg == "--from" or arg == "-f" then
			i = i + 1
			opt.from = args[i]
		elseif arg == "--to" or arg == "-t" then
			i = i + 1
			opt.to = args[i]
		elseif not opt.revisions and not opt.from and not opt.to then
			opt.revisions = arg
		end

		i = i + 1
	end

	return opt
end

function M.open(opt)
	if type(opt) == "string" then
		opt = { revisions = vim.trim(opt) ~= "" and opt or "@" }
	else
		opt = opt or { revisions = "@" }
	end

	require("jjsigns").change_base_to_jj_diff(opt, true)
	require("diffview").open_jj_diff(opt)
end

function M.setup_command()
	vim.api.nvim_create_user_command("JjDiffviewOpen", function(ctx)
		M.open(parse_args(ctx.fargs))
	end, {
		nargs = "*",
		desc = "Open diffview and jjsigns for a jj diff",
	})
end

return M
