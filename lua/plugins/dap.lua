-- ══════════════════════════════════════════════
-- DAP — nvim-dap + nvim-dap-ui + CodeLLDB
-- ══════════════════════════════════════════════

return {
  -- ── mason-nvim-dap ───────────────────────────
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    event        = "VeryLazy",
    opts = {
      ensure_installed       = { "codelldb" },
      automatic_installation = true,
      handlers               = {},
    },
  },

  -- ── Core DAP ─────────────────────────────────
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    config = function()
      local dap = require("dap")

      vim.fn.sign_define("DapBreakpoint",          { text = "", texthl = "DiagnosticError", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticWarn",  linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected",  { text = "", texthl = "DiagnosticHint",  linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint",            { text = "󰆤", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped",             { text = "▶", texthl = "DiagnosticOk",  linehl = "DapStoppedLine", numhl = "" })

      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      require("nvim-dap-virtual-text").setup({
        enabled                     = true,
        enabled_commands            = true,
        highlight_changed_variables = true,
        highlight_new_as_changed    = true,
        show_stop_reason            = true,
        commented                   = false,
        virt_text_pos               = "eol",
        display_callback = function(variable, _, _, _, options)
          if options.virt_text_pos == "inline" then
            return " = " .. variable.value
          else
            return variable.name .. " = " .. variable.value
          end
        end,
      })
    end,
  },

  -- ── DAP virtual text ─────────────────────────
  {
    "theHamsta/nvim-dap-virtual-text",
    lazy         = true,
    dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
  },

  -- ── DAP UI ───────────────────────────────────
  {
    "rcarriga/nvim-dap-ui",
    lazy         = true,
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      dapui.setup({
        icons    = { expanded = "", collapsed = "", current_frame = "" },
        mappings = { expand = { "<CR>", "<2-LeftMouse>" }, open = "o", remove = "d", edit = "e", repl = "r", toggle = "t" },
        expand_lines = true,
        force_buffers = true,
        floating = { max_height = 0.9, max_width = 0.85, border = "rounded", mappings = { close = { "q", "<Esc>" } } },
        render   = { indent = 1, max_value_lines = 100 },
        layouts  = {
          {
            elements = {
              { id = "scopes",      size = 0.40 },
              { id = "breakpoints", size = 0.20 },
              { id = "stacks",      size = 0.20 },
              { id = "watches",     size = 0.20 },
            },
            size = 45, position = "left",
          },
          {
            elements = { { id = "repl", size = 0.5 }, { id = "console", size = 0.5 } },
            size = 15, position = "bottom",
          },
        },
      })

      dap.listeners.before.attach.dapui_config           = function() dapui.open() end
      dap.listeners.before.launch.dapui_config           = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config     = function() dapui.close() end
    end,
  },
}
