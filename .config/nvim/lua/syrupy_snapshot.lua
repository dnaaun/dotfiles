-- Jump from a pytest test to the syrupy snapshot(s) it produced.

---@class SyrupySnapshot
---@field name string
---@field filename string
---@field lnum integer

--- Syrupy's name for the test enclosing the cursor, e.g. `TestFoo.test_bar`.
---@return string|nil
local function test_name_at_cursor()
	local parser = vim.treesitter.get_parser(0, "python", { error = false })
	if not parser then
		return nil
	end
	-- get_node() sees nothing until the buffer has been parsed at least once.
	parser:parse()
	local node = vim.treesitter.get_node()
	---@type string[]
	local parts = {}
	local found_test = false
	while node do
		local type = node:type()
		if type == "function_definition" or type == "class_definition" then
			local name_node = node:field("name")[1]
			local name = name_node and vim.treesitter.get_node_text(name_node, 0) or ""
			if type == "function_definition" and vim.startswith(name, "test_") then
				-- Outermost test_ function wins, so drop anything nested inside it.
				parts = { name }
				found_test = true
			elseif type == "class_definition" and found_test then
				table.insert(parts, 1, name)
			end
		end
		node = node:parent()
	end
	return found_test and table.concat(parts, ".") or nil
end

--- Whether `snapshot_name` belongs to `test_name` (`test_x`, `test_x[param]`, `test_x.1`).
---@param snapshot_name string
---@param test_name string
---@return boolean
local function belongs_to(snapshot_name, test_name)
	if snapshot_name == test_name then
		return true
	end
	local next_char = snapshot_name:sub(#test_name + 1, #test_name + 1)
	return vim.startswith(snapshot_name, test_name) and (next_char == "[" or next_char == ".")
end

---@param test_name string
---@return SyrupySnapshot[]
local function find_snapshots(test_name)
	local test_file = vim.api.nvim_buf_get_name(0)
	local snapshot_dir = vim.fn.fnamemodify(test_file, ":h") .. "/__snapshots__"
	local stem = vim.fn.fnamemodify(test_file, ":t:r")
	---@type SyrupySnapshot[]
	local snapshots = {}

	local ambr = snapshot_dir .. "/" .. stem .. ".ambr"
	if vim.uv.fs_stat(ambr) then
		for lnum, line in ipairs(vim.fn.readfile(ambr)) do
			local name = line:match("^# name: (.+)$")
			if name and belongs_to(name, test_name) then
				table.insert(snapshots, { name = name, filename = ambr, lnum = lnum })
			end
		end
	end

	-- Single-file extensions write `__snapshots__/<stem>/<name>.<ext>`.
	for name, type in vim.fs.dir(snapshot_dir .. "/" .. stem) do
		local snapshot_name = vim.fn.fnamemodify(name, ":r")
		if type == "file" and belongs_to(snapshot_name, test_name) then
			table.insert(
				snapshots,
				{ name = snapshot_name, filename = snapshot_dir .. "/" .. stem .. "/" .. name, lnum = 1 }
			)
		end
	end

	return snapshots
end

---@param snapshot SyrupySnapshot
---@return nil
local function jump_to(snapshot)
	vim.cmd("normal! m'")
	vim.cmd.edit(vim.fn.fnameescape(snapshot.filename))
	vim.api.nvim_win_set_cursor(0, { snapshot.lnum, 0 })
	vim.cmd("normal! zt")
end

---@param test_name string
---@param snapshots SyrupySnapshot[]
---@return nil
local function pick(test_name, snapshots)
	local conf = require("telescope.config").values
	require("telescope.pickers")
		.new({}, {
			prompt_title = "Snapshots for " .. test_name,
			finder = require("telescope.finders").new_table({
				results = snapshots,
				---@param snapshot SyrupySnapshot
				entry_maker = function(snapshot)
					return {
						value = snapshot,
						display = snapshot.name,
						ordinal = snapshot.name,
						filename = snapshot.filename,
						lnum = snapshot.lnum,
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			previewer = conf.qflist_previewer({}),
		})
		:find()
end

---@return nil
local function goto_snapshot()
	local test_name = test_name_at_cursor()
	if not test_name then
		vim.notify("Cursor is not inside a test_ function", vim.log.levels.WARN)
		return
	end
	local snapshots = find_snapshots(test_name)
	if #snapshots == 0 then
		vim.notify("No syrupy snapshots for " .. test_name, vim.log.levels.WARN)
	elseif #snapshots == 1 then
		jump_to(snapshots[1])
	else
		pick(test_name, snapshots)
	end
end

return {
	goto_snapshot = goto_snapshot,
}
