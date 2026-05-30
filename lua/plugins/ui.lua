-- ══════════════════════════════════════════════
-- UI Plugins — 2026
-- ══════════════════════════════════════════════

return {
  -- ── Treesitter ───────────────────────────────
  -- nvim-treesitter v1.x: new API (no more .configs module)
  {
    "nvim-treesitter/nvim-treesitter",
    build        = ":TSUpdate",
    lazy         = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "rust", "toml", "lua", "vim", "vimdoc",
          "bash", "json", "yaml", "markdown",
          "markdown_inline", "regex", "query",
        },
      })

      -- Treesitter v1.x: highlight is enabled per-buffer via vim.treesitter.start()
      -- This autocmd enables it automatically for every buffer
      vim.api.nvim_create_autocmd("FileType", {
        group    = vim.api.nvim_create_augroup("nvim_ts_highlight", { clear = true }),
        callback = function(ev)
          local ok = pcall(vim.treesitter.start, ev.buf)
          if not ok then
            -- Parser not available for this filetype, fall back silently
          end
        end,
      })

      -- Textobjects (still uses its own module, compatible with v1.x)
      local ok_to, to = pcall(require, "nvim-treesitter-textobjects")
      if ok_to and to.setup then to.setup() end
    end,
  },

  -- ── Treesitter context (sticky scope header) ─
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts = {
      enable            = true,
      max_lines         = 3,
      min_window_height = 20,
      trim_scope        = "outer",
      mode              = "cursor",
    },
  },

  -- ── nvim-ufo: modern fold provider ───────────
  -- Replaces the deprecated foldexpr treesitter approach
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event        = "BufReadPost",
    opts = {
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (" 󰁂 %d lines"):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            table.insert(newVirtText, { chunkText, chunk[2] })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end,
    },
    init = function()
      -- UFO requires these specific values
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      -- Use UFO provider keymaps
      vim.keymap.set("n", "zR", function() require("ufo").openAllFolds() end,    { desc = "Open all folds" })
      vim.keymap.set("n", "zM", function() require("ufo").closeAllFolds() end,   { desc = "Close all folds" })
      vim.keymap.set("n", "zr", function() require("ufo").openFoldsExceptKinds() end, { desc = "Open folds except" })
    end,
  },

  -- ── Dashboard ────────────────────────────────
  {
    "nvimdev/dashboard-nvim",
    event        = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      theme = "doom",
      config = {
        header = {
          "",
          "██████╗ ██╗   ██╗███████╗████████╗    ██████╗  ██████╗ ██╗   ██╗███████╗██████╗ ",
          "██╔══██╗██║   ██║██╔════╝╚══██╔══╝    ██╔══██╗██╔═══██╗██║   ██║██╔════╝██╔══██╗",
          "██████╔╝██║   ██║███████╗   ██║       ██████╔╝██║   ██║██║   ██║█████╗  ██████╔╝",
          "██╔══██╗██║   ██║╚════██║   ██║       ██╔══██╗██║   ██║╚██╗ ██╔╝██╔══╝  ██╔══██╗",
          "██║  ██║╚██████╔╝███████║   ██║       ██║  ██║╚██████╔╝ ╚████╔╝ ███████╗██║  ██║",
          "╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝       ╚═╝  ╚═╝ ╚═════╝   ╚═══╝  ╚══════╝╚═╝  ╚═╝",
          "                   🦀  Neovim — Rust Edition 2026                   ",
          "",
        },
        center = {
          { icon = "  ", key = "f",  desc = "Find File",      action = "Telescope find_files" },
          { icon = "  ", key = "r",  desc = "Recent Files",   action = "Telescope oldfiles" },
          { icon = "  ", key = "g",  desc = "Live Grep",      action = "Telescope live_grep" },
          { icon = "  ", key = "e",  desc = "Explorer",       action = "NvimTreeToggle" },
          { icon = "  ", key = "s",  desc = "Restore Session",action = "SessionRestore" },
          { icon = "  ", key = "l",  desc = "Lazy",           action = "Lazy" },
          { icon = "  ", key = "m",  desc = "Mason",          action = "Mason" },
          { icon = "  ", key = "q",  desc = "Quit",           action = "qa" },
        },
        footer = function()
          local v    = vim.version()
          local date = os.date("%A, %B %d")
          return {
            "",
            "  Neovim v" .. v.major .. "." .. v.minor .. "." .. v.patch
            .. "   " .. date,
          }
        end,
      },
    },
  },

  -- ── Bufferline ───────────────────────────────
  {
    "akinsho/bufferline.nvim",
    event        = "VeryLazy",
    dependencies = "nvim-tree/nvim-web-devicons",
    keys = {
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>",            desc = "Pin buffer" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Close unpinned" },
    },
    opts = {
      options = {
        mode                     = "buffers",
        numbers                  = "none",
        close_command            = "bdelete! %d",
        indicator                = { icon = "▎", style = "icon" },
        buffer_close_icon        = "󰅖",
        modified_icon            = "●",
        close_icon               = "",
        left_trunc_marker        = "",
        right_trunc_marker       = "",
        max_name_length          = 30,
        diagnostics              = "nvim_lsp",
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = { error = " ", warning = " " }
          local ret = (diag.error and icons.error .. diag.error .. " " or "")
                   .. (diag.warning and icons.warning .. diag.warning or "")
          return vim.trim(ret)
        end,
        separator_style          = "slant",
        always_show_bufferline   = true,
        offsets = {
          { filetype = "oil", text = "File Explorer", highlight = "Directory", separator = true },
        },
      },
    },
  },

  -- ── Lualine ──────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    event        = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons", "SmiteshP/nvim-navic" },
    config = function()
      local navic = require("nvim-navic")

      local function rust_mode()
        return vim.bo.filetype == "rust" and "🦀 Rust" or ""
      end

      local function macro_recording()
        local reg = vim.fn.reg_recording()
        return reg ~= "" and "󰑋 @" .. reg or ""
      end

      require("lualine").setup({
        options = {
          theme              = "vscode",
          globalstatus       = true,
          disabled_filetypes = { statusline = { "dashboard", "lazy", "alpha" } },
          component_separators = { left = "", right = "" },
          section_separators   = { left = "", right = "" },
        },
        sections = {
          lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
          lualine_b = {
            "branch",
            { "diff", symbols = { added = " ", modified = " ", removed = " " } },
          },
          lualine_c = {
            { "filename", path = 1, symbols = { modified = " ●", readonly = "  " } },
            { macro_recording, color = { fg = "#ff9e3b" } },
            { navic.get_location, cond = navic.is_available, color = { fg = "#6A9955" } },
          },
          lualine_x = {
            { rust_mode, color = { fg = "#CE422B" } },
            { "diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = " " } },
            "encoding", "fileformat",
            { "filetype", icon_only = false },
          },
          lualine_y = { "progress" },
          lualine_z = { { "location", separator = { right = "" }, left_padding = 2 } },
        },
        extensions = { "oil", "trouble", "lazy", "toggleterm", "nvim-dap-ui" },
      })
    end,
  },

  -- ── Navic (breadcrumbs) ───────────────────────
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    opts = {
      lsp       = { auto_attach = false },
      highlight = true,
      separator = "  ",
      depth_limit = 5,
      safe_output = true,
    },
  },

  -- ── Noice ────────────────────────────────────
  {
    "folke/noice.nvim",
    event        = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"]                = true,
          ["cmp.entry.get_documentation"]                  = true,
        },
        hover     = { enabled = true },
        signature = { enabled = true },
        progress  = { enabled = false },
      },
      routes = {
        { filter = { event = "msg_show", kind = "",           find = "written" }, opts = { skip = true } },
        { filter = { event = "msg_show", kind = "search_count" },                 opts = { skip = true } },
        { filter = { event = "msg_show", min_height = 10 }, view = "split" },
      },
      presets = {
        bottom_search         = true,
        command_palette       = true,
        long_message_to_split = true,
        inc_rename            = true,
        lsp_doc_border        = true,
      },
    },
  },

  -- ── nvim-notify ──────────────────────────────
  {
    "rcarriga/nvim-notify",
    lazy = true,
    opts = {
      render  = "wrapped-compact",
      stages  = "fade",
      timeout = 3000,
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      max_width  = function() return math.floor(vim.o.columns * 0.75) end,
    },
  },

  -- ── Trouble ──────────────────────────────────
  {
    "folke/trouble.nvim",
    cmd          = "Trouble",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      modes = {
        symbols = {
          desc = "Document Symbols",
          mode = "lsp_document_symbols",
          focus = false,
          win  = { position = "right", size = 0.3 },
        },
      },
    },
  },

  -- ── Which-key ────────────────────────────────
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      delay  = 400,
      spec = {
        { "<leader>r",   group = "Rust"           },
        { "<leader>c",   group = "Cargo"          },
        { "<leader>C",   group = "Crates"         },
        { "<leader>d",   group = "Debug"          },
        { "<leader>f",   group = "Find/Telescope" },
        { "<leader>g",   group = "Git"            },
        { "<leader>t",   group = "Test/Terminal"  },
        { "<leader>x",   group = "Diagnostics"   },
        { "<leader>u",   group = "UI Toggles"    },
        { "<leader>S",   group = "Sessions"       },
        { "<leader>b",   group = "Buffers"        },
        { "<leader><tab>", group = "Tabs"         },
      },
    },
  },

  -- ── Indent guides ────────────────────────────
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main  = "ibl",
    opts = {
      indent = { char = "│", tab_char = "│" },
      scope  = {
        enabled   = true,
        show_start = true,
        show_end   = false,
        highlight  = { "Function", "Label" },
        priority   = 500,
      },
      exclude = {
        filetypes = { "help", "alpha", "dashboard", "lazy", "mason", "notify", "toggleterm" },
      },
    },
  },

  -- ── nvim-highlight-colors ────────────────────
  -- Replaces NvChad/nvim-colorizer.lua (deprecated/broken)
  {
    "brenoprata10/nvim-highlight-colors",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      render             = "background",
      enable_named_colors = false,
      enable_tailwind    = false,
    },
  },

  -- ── Devicons ─────────────────────────────────
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- ── Zen mode ─────────────────────────────────
  {
    "folke/zen-mode.nvim",
    cmd  = "ZenMode",
    opts = { window = { backdrop = 0.95, width = 120, height = 1 } },
  },

  -- ── Smooth scrolling ─────────────────────────
  {
    "karb94/neoscroll.nvim",
    event = "BufReadPost",
    opts  = { mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" } },
  },

  -- ── Nvim-tree ────────────────────────────────
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      hijack_netrw = true,
      sync_root_with_cwd = true,
      view = {
        width = 30,
        side = "left",
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = false,
      },
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)

      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function(data)
          local no_args    = data.file == "" or data.file == nil
          local directory  = vim.fn.isdirectory(data.file) == 1
          local is_real_file = not no_args and not directory
              and vim.fn.filereadable(data.file) == 1

          -- If a real file was passed, just open tree in the background
          if is_real_file then
            require("nvim-tree.api").tree.open({ find_file = true, focus = false })
            return
          end

          if directory then
            -- Started with `nvim .` or `nvim /some/dir`
            vim.cmd.cd(data.file)
            vim.cmd("enew")
            vim.cmd("bwipeout " .. data.buf)
          end

          -- Both `nvim` and `nvim .` → open tree focused
          require("nvim-tree.api").tree.open()
        end,
      })
    end,
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle NvimTree" },
    },
  },
}