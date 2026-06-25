local M = {}

local function has_value(value)
	return value ~= nil and value ~= ""
end

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
			opt.from = arg
		end

		i = i + 1
	end

	return opt
end

local function change_jjsigns_base(opt, callback)
	if has_value(opt.from) and not has_value(opt.revisions) and not has_value(opt.to) then
		require("jjsigns").change_base(opt.from, true, callback)
		return
	end

	require("jjsigns").change_base_to_jj_diff(opt, true, callback)
end

local function attach_jjsigns(callback)
	if vim.bo.buftype ~= "" or vim.api.nvim_buf_get_name(0) == "" then
		callback()
		return
	end

	require("jjsigns").attach({ bufnr = 0, force = true }, callback)
end

function M.open(opt)
	if type(opt) == "string" then
		opt = { from = vim.trim(opt) ~= "" and opt or "@" }
	else
		opt = opt or { from = "@" }
	end

	change_jjsigns_base(opt, function(err)
		if err then
			vim.notify("Failed to update jjsigns base: " .. tostring(err), vim.log.levels.ERROR)
		end

		attach_jjsigns(function(attach_err)
			if attach_err then
				vim.notify("Failed to attach jjsigns: " .. tostring(attach_err), vim.log.levels.WARN)
			end

			require("diffview").open_jj_diff(opt)
		end)
	end)
end

function M.open_from(revset)
	revset = vim.trim(revset or "")
	if revset == "" then
		vim.notify("JjDiffviewOpenFrom requires a jj revset", vim.log.levels.ERROR)
		return
	end

	M.open({ from = revset })
end

function M.setup_command()
	vim.api.nvim_create_user_command("JjDiffviewOpen", function(ctx)
		local args = vim.trim(ctx.args or "")
		if args == "" or not args:match("^%-") then
			M.open(args)
			return
		end

		M.open(parse_args(ctx.fargs))
	end, {
		nargs = "*",
		desc = "Open diffview and jjsigns from a jj revset",
	})

	vim.api.nvim_create_user_command("JjDiffviewOpenFrom", function(ctx)
		M.open_from(ctx.args)
	end, {
		nargs = "+",
		desc = "Open diffview and jjsigns from a jj revset",
	})
end

return M
