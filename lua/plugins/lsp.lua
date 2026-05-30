-- ══════════════════════════════════════════════
-- LSP — Mason + vim.lsp.config (Neovim 0.11+) + nvim-cmp
-- ══════════════════════════════════════════════

return {
  -- ── Mason ────────────────────────────────────
  {
    "williamboman/mason.nvim",
    lazy = false,
    opts = {
      ui = {
        border = "rounded",
        icons  = {
          package_installed   = "✓",
          package_pending     = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- ── Neoconf (project-local settings like .vscode/settings.json) ──
  {
    "folke/neoconf.nvim",
    cmd = "Neoconf",
  },

  {
    "williamboman/mason-lspconfig.nvim",
    lazy         = false,
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      -- rust_analyzer managed by rustaceanvim
      ensure_installed       = { "lua_ls", "taplo" },
      automatic_installation = false,
    },
  },

  -- ── nvim-lspconfig ───────────────────────────
  -- Used only for server config definitions; setup via vim.lsp.config
  {
    "neovim/nvim-lspconfig",
    event        = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "SmiteshP/nvim-navic",
      "j-hui/fidget.nvim",
      "folke/neoconf.nvim",
    },
    config = function()
      require("neoconf").setup({})

      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      -- Shared on_attach via LspAttach autocmd (recommended pattern for 0.11+)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          local bufnr  = ev.buf
          if not client then return end

          -- Breadcrumbs
          if client.server_capabilities.documentSymbolProvider then
            require("nvim-navic").attach(client, bufnr)
          end

          -- Inlay hints
          if vim.lsp.inlay_hint and client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end

          -- Buffer-local keymaps
          local function map(mode, lhs, rhs, d)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = d, noremap = true, silent = true })
          end
          map("n", "gd",  "<cmd>Telescope lsp_definitions<cr>",      "Go to definition")
          map("n", "gD",  vim.lsp.buf.declaration,                    "Go to declaration")
          map("n", "gr",  "<cmd>Telescope lsp_references<cr>",        "References")
          map("n", "gi",  "<cmd>Telescope lsp_implementations<cr>",   "Implementations")
          map("n", "gy",  "<cmd>Telescope lsp_type_definitions<cr>",  "Type definition")
          map("n", "K",   vim.lsp.buf.hover,                          "Hover")
          map("n", "<C-k>", vim.lsp.buf.signature_help,               "Signature help")
          map("i", "<C-k>", vim.lsp.buf.signature_help,               "Signature help")
          map("n", "<leader>rn", vim.lsp.buf.rename,                  "Rename")
          map("n", "<leader>ca", vim.lsp.buf.code_action,             "Code action")
          map("v", "<leader>ca", vim.lsp.buf.code_action,             "Code action (range)")
        end,
      })

      -- ── Lua ──────────────────────────────────
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime     = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace   = {
              checkThirdParty = false,
              library         = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = { enable = false },
            hint      = { enable = true },
          },
        },
      })

      -- ── TOML (Cargo.toml) ─────────────────────
      vim.lsp.config("taplo", {
        capabilities = capabilities,
      })

      vim.lsp.enable({ "lua_ls", "taplo" })
    end,
  },

  -- ── Fidget (LSP progress) ────────────────────
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      notification = { window = { winblend = 0, border = "none" } },
      progress = {
        display = {
          render_limit  = 6,
          done_ttl      = 2,
          progress_icon = { pattern = "dots" },
        },
      },
    },
  },

  -- ── nvim-cmp ─────────────────────────────────
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
      "saecki/crates.nvim",
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_lua").lazy_load({
        paths = vim.fn.stdpath("config") .. "/lua/snippets",
      })

      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        window = {
          completion    = cmp.config.window.bordered({ border = "rounded" }),
          documentation = cmp.config.window.bordered({ border = "rounded" }),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"]     = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"]     = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
          ["<C-f>"]     = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"]     = cmp.mapping.abort(),
          ["<CR>"]      = cmp.mapping.confirm({ select = false }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp",                priority = 1000 },
          { name = "nvim_lsp_signature_help", priority = 900  },
          { name = "luasnip",                 priority = 750  },
          { name = "crates",                  priority = 700  },
          { name = "buffer",                  priority = 500  },
          { name = "path",                    priority = 250  },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode      = "symbol_text",
            maxwidth  = 50,
            ellipsis_char = "…",
            menu = {
              nvim_lsp                = "[LSP]",
              nvim_lsp_signature_help = "[Sig]",
              luasnip                 = "[Snip]",
              crates                  = "[Crates]",
              buffer                  = "[Buf]",
              path                    = "[Path]",
            },
          }),
        },
        experimental = { ghost_text = { hl_group = "LspCodeLens" } },
      })

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          { { name = "path" } },
          { { name = "cmdline", option = { ignore_cmds = { "Man", "!" } } } }
        ),
      })
    end,
  },

  -- ── LuaSnip ──────────────────────────────────
  {
    "L3MON4D3/LuaSnip",
    build        = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      history             = true,
      delete_check_events = "TextChanged",
      region_check_events = "CursorMoved",
    },
  },
}
