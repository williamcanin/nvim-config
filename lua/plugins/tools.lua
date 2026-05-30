-- ══════════════════════════════════════════════
-- Tools — 2026
-- ══════════════════════════════════════════════

return {
  -- ── Telescope ────────────────────────────────
  {
    "nvim-telescope/telescope.nvim",
    cmd          = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local telescope = require("telescope")
      local actions   = require("telescope.actions")

      telescope.setup({
        defaults = {
          prompt_prefix    = "   ",
          selection_caret  = " ",
          path_display     = { "truncate" },
          sorting_strategy = "ascending",
          layout_config    = {
            horizontal     = { prompt_position = "top", preview_width = 0.55 },
            width          = 0.87,
            height         = 0.80,
            preview_cutoff = 120,
          },
          vimgrep_arguments = {
            "rg", "--color=never", "--no-heading", "--with-filename",
            "--line-number", "--column", "--smart-case", "--hidden",
            "--glob=!.git",
          },
          file_ignore_patterns = { "^.git/", "^target/", "^%.cargo/", "%.lock", "node_modules" },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-c>"] = actions.close,
              ["<esc>"] = actions.close,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            },
            n = { ["q"] = actions.close },
          },
        },
        extensions = {
          fzf = {
            fuzzy                   = true,
            override_generic_sorter = true,
            override_file_sorter    = true,
            case_mode               = "smart_case",
          },
          ["ui-select"] = { require("telescope.themes").get_dropdown() },
        },
      })

      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")
    end,
  },

  -- ── Oil.nvim ─────────────────────────────────
  {
    "stevearc/oil.nvim",
    lazy         = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      default_file_explorer = false,
      columns               = { "icon", "permissions", "size", "mtime" },
      delete_to_trash       = true,
      watch_for_changes     = true,
      view_options = {
        show_hidden    = true,
        natural_order  = true,
        sort = { { "type", "asc" }, { "name", "asc" } },
      },
      float = { border = "rounded", max_width = 80, max_height = 40, win_options = { winblend = 0 } },
      keymaps = {
        ["g?"]    = "actions.show_help",
        ["<CR>"]  = "actions.select",
        ["<C-v>"] = { "actions.select", opts = { vertical   = true } },
        ["<C-s>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["-"]     = "actions.parent",
        ["_"]     = "actions.open_cwd",
        ["gs"]    = "actions.change_sort",
        ["gx"]    = "actions.open_external",
        ["g."]    = "actions.toggle_hidden",
        ["g\\"]   = "actions.toggle_trash",
      },
    },
  },

  -- ── ToggleTerm ───────────────────────────────
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event   = "VeryLazy",
    opts = {
      size = function(term)
        if term.direction == "horizontal" then return 15
        elseif term.direction == "vertical" then return vim.o.columns * 0.4
        end
      end,
      open_mapping    = [[<c-\>]],
      hide_numbers    = true,
      direction       = "float",
      close_on_exit   = true,
      shell           = vim.o.shell,
      float_opts = {
        border   = "curved",
        winblend = 0,
        width    = function() return math.floor(vim.o.columns * 0.85) end,
        height   = function() return math.floor(vim.o.lines   * 0.80) end,
      },
    },
  },

  -- ── Gitsigns ─────────────────────────────────
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
      },
      signs_staged_enable     = true,
      current_line_blame      = false,
      current_line_blame_opts = {
        virt_text = true, virt_text_pos = "eol", delay = 1000,
      },
    },
  },

  -- ── Conform (formatter) ──────────────────────
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd   = "ConformInfo",
    opts = {
      formatters_by_ft = {
        rust = { "rustfmt" },
        lua  = { "stylua" },
        toml = { "taplo" },
        sh   = { "shfmt" },
        ["*"] = { "trim_whitespace" },
      },
      format_on_save = false,  -- triggered manually in autocmds.lua
      formatters = {
        rustfmt = {
          command = "rustfmt",
          args    = { "--edition", "2021", "--emit", "stdout" },
          stdin   = true,
        },
        stylua = {
          command = "stylua",
          args    = { "--indent-type", "Spaces", "--indent-width", "2", "-" },
          stdin   = true,
        },
      },
      notify_on_error = true,
    },
  },

  -- ── nvim-lint (clippy) ───────────────────────
  -- Note: rust-analyzer already runs clippy; this adds belt-and-suspenders
  -- null_ls is NOT used — nvim-lint is the modern replacement
  {
    "mfussenegger/nvim-lint",
    event = { "BufWritePost" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = { rust = { "clippy" } }

      lint.linters.clippy = {
        name            = "clippy",
        cmd             = "cargo",
        stdin           = false,
        append_fname    = false,
        args            = {
          "clippy", "--message-format=json", "--quiet",
          "--all-targets", "--all-features", "--", "-W", "clippy::pedantic",
        },
        stream          = "stdout",
        ignore_exitcode = true,
        parser = require("lint.parser").from_errorformat("%f:%l:%c: %t%*[^:]: %m", {
          source   = "clippy",
          severity = {
            ["error"]   = vim.diagnostic.severity.ERROR,
            ["warning"] = vim.diagnostic.severity.WARN,
            ["note"]    = vim.diagnostic.severity.INFO,
            ["help"]    = vim.diagnostic.severity.HINT,
          },
        }),
      }

      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern  = "*.rs",
        callback = function() lint.try_lint() end,
      })
    end,
  },

  -- ── auto-session ─────────────────────────────
  {
    "rmagatti/auto-session",
    lazy = false,
    config = function()
      require("auto-session").setup({
        suppressed_dirs             = { "~/", "~/Projects", "~/Downloads", "/" },
        auto_restore_enabled        = true,
        auto_save_enabled           = true,
        auto_session_use_git_branch = true,

        -- Re-trigger treesitter highlight on all buffers after session restore
        post_restore_cmds = {
          function()
            -- Give plugins a tick to finish loading before re-attaching
            vim.schedule(function()
              for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_loaded(buf) then
                  local ft = vim.bo[buf].filetype
                  if ft and ft ~= "" then
                    -- Retrigger FileType event so treesitter/LSP re-attaches
                    vim.api.nvim_buf_call(buf, function()
                      vim.cmd("filetype detect")
                    end)
                  end
                end
              end
            end)
          end,
        },
      })
    end,
  },

  -- ── Surround ─────────────────────────────────
  { "kylechui/nvim-surround", version = "*", event = "VeryLazy", opts = {} },

  -- ── Comments ─────────────────────────────────
  -- ts-comments replaces Comment.nvim with treesitter-aware commenting
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts  = {},
  },

  -- ── better-escape ─────────────────────────────
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    opts  = { timeout = 200, mappings = { i = { j = { k = "<Esc>" } } } },
  },

  -- ── Autopairs ────────────────────────────────
  {
    "windwp/nvim-autopairs",
    event        = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      local autopairs     = require("nvim-autopairs")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      autopairs.setup({
        check_ts  = true,
        ts_config = {
          lua  = { "string" },
          rust = { "string", "raw_string" },
        },
        fast_wrap = {
          map     = "<M-e>",
          chars   = { "{", "[", "(", '"', "'" },
          pattern = [=[[%'%"%>%]%)%}%,]]=],
          keys    = "qwertyuiopzxcvbnmasdfghjkl",
        },
      })
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- ── Todo comments ────────────────────────────
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event        = { "BufReadPost", "BufNewFile" },
    opts = {
      keywords = {
        FIX  = { icon = " ", color = "error",   alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning", alt = { "SAFETY", "CLIPPY" } },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint",    alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test",   alt = { "TESTING", "PASSED", "FAILED" } },
      },
    },
  },

  -- ── Markdown Preview ─────────────────────────
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },

  -- ── Plenary ──────────────────────────────────
  { "nvim-lua/plenary.nvim", lazy = true },
}
