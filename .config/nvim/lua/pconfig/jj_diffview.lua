local M = {}

local function has_value(value)
	return value ~= nil and value ~= ""
end

function M.sync_jjsigns(opt)
	local jjsigns = require("jjsigns")

	local function attach(err)
		if err then
			vim.notify("Failed to update jjsigns base: " .. tostring(err), vim.log.levels.ERROR)
		end

		if vim.bo.buftype == "" and vim.api.nvim_buf_get_name(0) ~= "" then
			jjsigns.attach({ bufnr = 0, force = true }, function(attach_err)
				if attach_err then
					vim.notify("Failed to attach jjsigns: " .. tostring(attach_err), vim.log.levels.WARN)
				end
			end)
		end
	end

	if has_value(opt.from) and not has_value(opt.revisions) and not has_value(opt.to) then
		jjsigns.change_base(opt.from, true, attach)
	else
		jjsigns.change_base_to_jj_diff(opt, true, attach)
	end
end

return M
