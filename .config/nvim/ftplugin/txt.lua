function override_yank_to_add_metadata()
	-- "Import" stuff from plenary
	local Path = require("plenary.path")

	-- Get current file path
	local cur_file_path = Path:new(vim.fn.expand("%:p"))

  -- Get current file name, except the extension
  local file_basename = vim.fn.expand("%:t:r")

	-- Get the name of the directory that contains the current file path
  local containing_dir = cur_file_path:parent():absolute()

  -- Get the last part of the directory name
  local containing_dir_basename = vim.fn.fnamemodify(containing_dir, ":t")

	-- Get the line number of the beginning of yanking
	local beg_line_number = vim.fn.line("'[")

	-- Get the content at that line
	local beg_line_content = vim.fn.getline(beg_line_number)

	-- If the line is empty, get the content of the next line
	if beg_line_content == "" then
		beg_line_content = vim.fn.getline(beg_line_number + 1)
	end

	-- Get the first word from that
	local beg_line_first_word = vim.fn.matchstr(beg_line_content, "\\w\\+")

	-- Get whatever text was yanked from vim.v.event
	local text_yanked = vim.v.event.regcontents

  -- Trim as many empty lines from the beginning of the list as possible
  while text_yanked[1] == "" do
    table.remove(text_yanked, 1)
  end
  -- Same thing from the other end
  while text_yanked[#text_yanked] == "" do
    table.remove(text_yanked, #text_yanked)
  end

	local new_text_to_yank = vim.list_extend(vim.list_extend({}, {
		 containing_dir_basename .. " " .. file_basename .. ":" .. beg_line_first_word,
		 "" ,
	}), text_yanked)

	-- Copy the text into the register with the name vim.v.event.regname
	vim.fn.setreg(vim.v.event.regname, new_text_to_yank)
end

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  group = vim.api.nvim_create_augroup("OverrideYank", {}),
  pattern = "*.txt",
	callback = override_yank_to_add_metadata,
})

