-- ══════════════════════════════════════════════
-- Lazy.nvim bootstrap
-- ══════════════════════════════════════════════

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins.theme"   },
    { import = "plugins.ui"      },
    { import = "plugins.lsp"     },
    { import = "plugins.rust"    },
    { import = "plugins.dap"     },
    { import = "plugins.tools"   },
  },
  defaults        = { lazy = true },
  install         = { colorscheme = { "vscode", "habamax" } },
  checker         = { enabled = false, notify = false },  -- Disable auto-check to prevent modifiable errors
  change_detection = { notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "matchit", "matchparen", "netrwPlugin",
        "tarPlugin", "tohtml", "tutor", "zipPlugin",
      },
    },
  },
  ui = { border = "rounded" },
})
