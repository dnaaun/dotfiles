

------------ Enable <tab> and <s-tab> to start and jump through completions
function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end


local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local preceded_by_space = function()
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

    if ultisnips_is_loaded() and vim.fn.call("UltiSnips#CanExpandSnippet", {}) == 1 then
        vim.fn.call("UltiSnips#ExpandSnippet", {})
        return t ""
    end

    if preceded_by_space() then
      return t "<tab>"
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

local on_attach = function()
require'compe'.setup {
  enabled = true;
  autocomplete = false;
  debug = false;
  min_length = 1;
  documentation = true;
  preselect = "always";

  source = {
    nvim_lsp = {
      priority = 10;
    },
    path = {
      priority = 5;
    },
    calc = {
      priority = 0
    }
  };
}
vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

-- This is needed for autoimport
vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm('<CR>')", {silent=true, expr = true})
end

table.insert(_G.lsp_config_on_attach_callbacks, on_attach)

