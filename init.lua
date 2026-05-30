-- ══════════════════════════════════════════════
-- Neovim — Rust Edition 2026
-- ══════════════════════════════════════════════

-- Leader must be set before lazy loads plugins
vim.g.mapleader      = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.diagnostics")
require("config.rust-commands")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")
