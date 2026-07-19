local M = {}

local directions = {
	h = { nvim = "h", herdr = "left" },
	j = { nvim = "j", herdr = "down" },
	k = { nvim = "k", herdr = "up" },
	l = { nvim = "l", herdr = "right" },
}

local function focus(direction)
	local current_window = vim.api.nvim_get_current_win()
	vim.cmd("wincmd " .. direction.nvim)

	if vim.api.nvim_get_current_win() ~= current_window then
		return
	end

	local pane_id = vim.env.HERDR_PANE_ID
	if not pane_id then
		return
	end

	local herdr = vim.fn.exepath("herdr")
	if herdr == "" then
		herdr = "herdr"
	end

	vim.system({
		herdr,
		"pane",
		"focus",
		"--direction",
		direction.herdr,
		"--pane",
		pane_id,
	}, { text = true }, function(result)
		if result.code ~= 0 then
			vim.schedule(function()
				local message = (result.stderr and result.stderr ~= "") and result.stderr
					or "Could not move to the adjacent Herdr pane"
				vim.notify(message, vim.log.levels.ERROR, { title = "Herdr navigation" })
			end)
		end
	end)
end

function M.setup()
	for key, direction in pairs(directions) do
		vim.keymap.set({ "n", "i" }, "<C-" .. key .. ">", function()
			focus(direction)
		end, { desc = "Move " .. direction.herdr .. " across Neovim and Herdr", silent = true })
	end
end

return M
