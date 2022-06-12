--- @class Position
--- @field character number
--- @field line number

--- @class LspRange
--- @field start Position
--- @field end Position

--- @class DocumentHighlight
--- @field range LspRange

-- Compare two positions and return 1 if pos1 > pos2.
-- Both pos1 and pos2 must be of the form {lnum, col}.
--- @param range1 LspRange
--- @param range2 LspRange
local function range1_comes_before(range1, range2)
	if range1.start.line > range2.start.line then
		return false
	elseif range1.start.line == range2.start.line then
		if range1.start.character > range2.start.character then
			return false
		elseif range1.start.character == range2.start.character then
			return false
		else
			return true
		end
	else
		return true
	end
end

---This is endpiont inclusive. Ie, is_between(3, 3, 144) is true.
---@param num number
---@param lower number
---@param upper number
local function is_between(num, lower, upper)
	return lower <= num and num <= upper
end

--- This only supports checking ranges that span one line for now.
--- @param range1 LspRange
--- @param range2 LspRange
--- @return boolean
local function do_ranges_overlap(range1, range2)
	-- Each range must be on one line
	if range1.start.line ~= range1["end"].line or range2.start.line ~= range2["end"].line then
		return false
	end

	-- The ranges must be on the same line
	if range1.start.line ~= range2.start.line then
		return false
	end

	return is_between(range1.start.character, range2.start.character, range2["end"].character)
		or is_between(range2.start.character, range1.start.character, range1["end"].character)
end

-- get current position as an lsp-formatted range
---@return LspRange
local function get_cur_pos_as_lsp_range()
	local one_indexed_curpos = vim.fn.getcursorcharpos()
	-- adjust to be zero indexed for easier comparison later
	local cur_pos = { one_indexed_curpos[2] - 1, one_indexed_curpos[3] - 1 }

	-- Make a `LspRange` of width and height 1, to make later code easier
	return {
		start = { line = cur_pos[1], character = cur_pos[2] },
		["end"] = { line = cur_pos[1], character = cur_pos[2] },
	}
end

-- Among a list of `DocumentHighlight` objects, find the position specified by
-- one of the objects that comes after the current cursor position.
-- if `find_prev` is `true`, then we find the position that comes before the
-- current cursor position.
--- @param document_highlights DocumentHighlight[]
--- @param find_prev boolean
--- @return nil | LspRange -- Will return `nil`, or the zero indexed { lnum, col } location of the occurence.
local function find_next_or_prev_occurence(document_highlights, find_prev)
	--- @type LspRange[]
	local ranges = {}
	for _, doc_highlight in ipairs(document_highlights) do
		table.insert(ranges, #ranges + 1, doc_highlight.range)
	end

	-- sort the positions, since the LSP spec doesn't specify that they have to be sorted when they are returned
	if not find_prev then
		table.sort(ranges, range1_comes_before)
	else
		-- sort descendingly if we're trying to find the previous positiion
		table.sort(ranges, function(r1, r2)
			return range1_comes_before(r2, r1)
		end)
	end

	local cur_pos_range = get_cur_pos_as_lsp_range()

	local jump_to = nil
	for _, range in ipairs(ranges) do
		if not do_ranges_overlap(range, cur_pos_range) then
			if find_prev then
				if range1_comes_before(range, cur_pos_range) then
					jump_to = range
					break
				end
			else
				if range1_comes_before(cur_pos_range, range) then
					jump_to = range
					break
				end
			end
		end
	end

	return jump_to
end

--- This makes an LSP handler function
---@param find_prev boolean | nil - defaults to false. Whether the handler should go to the next, or previous occurence.
---@return fun(err: any, result: DocumentHighlight[] | nil, _: any, _: any)
local function make_goto_occurence_handler(find_prev)
	find_prev = find_prev or false

	local handler = function(err, result, _, _)
		if not err and result then
			local jump_to_range = find_next_or_prev_occurence(result, find_prev)
			if jump_to_range then
				vim.fn.setcursorcharpos(jump_to_range.start.line + 1, jump_to_range.start.character + 1)
			end
		end
	end

	return handler
end

--- This is where we'll register which clients we're using for which buffer.
local clients_by_buffer = {}

--- @param prev boolean | nil, defaults to false - whether to go to the previous occurence
local function goto_occurence(prev)
	prev = prev or false
	local client = clients_by_buffer[tostring(vim.fn.bufnr())]
	local pos = vim.lsp.util.make_position_params()
	local params = vim.tbl_extend("force", {}, pos, { textDocument = { uri = vim.uri_from_bufnr(0) } })
	local handler = make_goto_occurence_handler(prev)
	client.request("textDocument/documentHighlight", params, handler)
end

local function on_attach(client, bufnr)
	-- register which client we're using for which server.
	if not client.server_capabilities.documentHighlightProvider then
		return
	end

	clients_by_buffer[tostring(bufnr)] = client

	-- setup mappings
	vim.keymap.set("n", "g*", function()
		vim.lsp.buf.document_highlight()
		goto_occurence(false)
	end, { buffer = true })
	vim.keymap.set("n", "g#", function()
		vim.lsp.buf.document_highlight()
		goto_occurence(true)
	end, { buffer = true })

	-- setup a mapping to clear the highlights
	vim.keymap.set("n", "<leader>lc", function()
		vim.lsp.util.buf_clear_references(0)
	end, {})

	-- use the g-prefixed version to actually mean the previusly g-unprefixed version
	-- vim.keymap.set("n", "g*", "*", { remap = false })
	-- vim.keymap.set("n", "g#", "#", { remap = false })
end

return {
	on_attach = on_attach,
}
