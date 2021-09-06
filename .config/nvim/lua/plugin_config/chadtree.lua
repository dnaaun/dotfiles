vim.g.chadtree_settings = {
  profiling = false,
  ignore = {
    name_exact = {
      ".DS_Store",
      ".directory",
      ".git",
      "thumbs.db"
    },
    name_glob = {},
    path_glob = {}
  },
  keymap = {
    bigger = { },
    change_dir = {
      "b"
    },
    change_focus = {
      "c"
    },
    change_focus_up = {
      "-", "C"
    },
    clear_filter = {
      "F"
    },
    clear_selection = {
      "S"
    },
    collapse = {
      "<s-tab>",
      "`"
    },
    copy = {
      "p"
    },
    copy_basename = {
      "Y"
    },
    copy_name = {
      "y"
    },
    cut = {
      "x"
    },
    delete = {
      "d"
    },
    filter = {
      "f"
    },
    h_split = {
      "<c-x>"
    },
    jump_to_current = {
      "J"
    },
    new = {
      "a"
    },
    open_sys = {
      "o"
    },
    primary = {
      "<enter>"
    },
    quit = {
      "q"
    },
    refocus = {
      "~"
    },
    refresh = {
      "<c-r>"
    },
    rename = {
      "r"
    },
    secondary = {
      "<tab>",
      "<2-leftmouse>"
    },
    select = {
      "s"
    },
    smaller = { },
    stat = {
      "K"
    },
    tertiary = {
      "<m-enter>",
      "<middlemouse>"
    },
    toggle_follow = {},
    toggle_hidden = {
      "."
    },
    toggle_version_control = {},
    trash = {
      "t"
    },
    v_split = {
      "<c-v>"
    }
  },
  options = {
    close_on_open = false,
    follow = true,
    lang = null,
    mimetypes = {
      allow_exts = {
        ".ts"
      },
      warn = {
        "audio",
        "font",
        "image",
        "video"
      }
    },
    page_increment = 5,
    polling_rate = 2,
    session = true,
    show_hidden = false,
    version_control = {
      enable = true
    }
  },
  theme = {
    icon_glyph_set = "devicons",
    text_colour_set = "solarized_dark",
    icon_colour_set = "github",
    highlights = {
      ignored = "Comment",
      quickfix = "Label",
      version_control = "Comment"
    },
    discrete_colour_map = {
      black = "#202020",
      red = "#ff4c41",
      green = "#96bc00",
      yellow = "#f6a311",
      blue = "#4eb5e0",
      magenta = "#f587c5",
      cyan = "#52bcaf",
      white = "#feffff",
      bright_black = "#000000",
      bright_red = "#ff8883",
      bright_green = "#8dc437",
      bright_yellow = "#ffa84f",
      bright_blue = "#58c7ff",
      bright_magenta = "#ffa3cc",
      bright_cyan = "#5ac8a9",
      bright_white = "#feffff"
    }
  },
  view = {
    open_direction = "left",
    sort_by = {
      "is_folder",
      "ext",
      "file_name"
    },
    time_format = "%Y-%m-%d %H:%M",
    width = 40,
    window_options = {
      cursorline = true,
      foldenable = false,
      number = false,
      relativenumber = false,
      signcolumn = "no",
      winfixwidth = true,
      wrap = false
    }
  },
  xdg = false
}

vim.api.nvim_buf_set_keymap(0, 'n', '-', '<cmd>CHADopen<CR>', {noremap=true, silent=true})
