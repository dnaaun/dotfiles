require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  documentation = true;
  preselect = "always";

  source = {
    nvim_lsp = true;
    ultisnips = true;
    calc = true;
    path = true;
  };
}

------------ Enable <tab> and <s-tab> to start and jump through completions
function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end


local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

local ultisnips_is_loaded = function()
    return vim.fn.call("exists", {'*UltiSnips#ExpandSnippetOrJump'}) ~= 0
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone - jump to prev/next snippet's placeholder
_G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-n>"
    else

    if ultisnips_is_loaded() then
        vim.fn.call("UltiSnips#ExpandSnippetOrJump", {})
        print("Callling things")
        -- the above call will set the following
        if vim.g.ulti_expand_or_jump_res > 0 then
            return t ""
        end
    end
    if check_back_space() then
      return t "<Tab>"
    else
      return vim.fn['compe#complete']()
    end
  end
end

-- TODO: Finish this.
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    if ultisnips_is_loaded() then
        vim.fn.call("UltiSnips#JumpBackwards ", {})
        if vim.g.ulti_jump_backwards_res == 1 then
            return t ""
        end
    end

    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

-- This is needed for autoimport
vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm('<CR>')", {silent=True, expr = true})
