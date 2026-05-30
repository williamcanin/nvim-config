-- ══════════════════════════════════════════════
-- Options
-- ══════════════════════════════════════════════

local opt = vim.opt
local g   = vim.g

-- Disable netrw (we use oil.nvim)
g.loaded_netrw       = 1
g.loaded_netrwPlugin = 1

-- Enable project-local .nvim.lua files
opt.exrc = true

-- ── Appearance ──────────────────────────────
opt.termguicolors  = true
opt.number         = true
opt.relativenumber = true
opt.signcolumn     = "yes:2"
opt.cursorline     = true
opt.cursorcolumn   = false
opt.colorcolumn    = "100"
opt.showmode       = false
opt.laststatus     = 3
opt.cmdheight      = 1
opt.pumheight      = 12
opt.scrolloff      = 8
opt.sidescrolloff  = 8
opt.wrap           = false
opt.linebreak      = true
opt.breakindent    = true
opt.list           = true
opt.listchars      = { tab = "→ ", trail = "·", nbsp = "␣" }
opt.fillchars      = {
  eob      = " ",
  fold     = " ",
  foldopen = "▾",
  foldclose = "▸",
  foldsep  = " ",
  diff     = "╱",
}

-- ── Editing ──────────────────────────────────
opt.expandtab    = true
opt.shiftwidth   = 4
opt.tabstop      = 4
opt.softtabstop  = 4
opt.smartindent  = true
opt.shiftround   = true
opt.clipboard    = "unnamedplus"
opt.mouse        = "a"
opt.undofile     = true
opt.undolevels   = 10000
opt.updatetime   = 200
opt.timeoutlen   = 300
opt.virtualedit  = "block"
opt.inccommand   = "nosplit"
opt.confirm      = true

-- ── Search ───────────────────────────────────
opt.ignorecase   = true
opt.smartcase    = true
opt.hlsearch     = true
opt.incsearch    = true
opt.grepprg      = "rg --vimgrep --smart-case"
opt.grepformat   = "%f:%l:%c:%m"

-- ── Splits ───────────────────────────────────
opt.splitbelow   = true
opt.splitright   = true
opt.splitkeep    = "screen"

-- ── Folds (nvim-ufo handles these) ───────────
opt.foldlevel    = 99
opt.foldlevelstart = 99
opt.foldenable   = true

-- ── Completion ───────────────────────────────
opt.completeopt  = { "menu", "menuone", "noselect" }
opt.shortmess:append("c")

-- ── Performance ──────────────────────────────
opt.lazyredraw   = false
opt.synmaxcol    = 300
opt.redrawtime   = 10000

-- ── Diagnostics ──────────────────────────────
vim.diagnostic.config({
  virtual_text = {
    spacing  = 4,
    prefix   = "●",
    severity = { min = vim.diagnostic.severity.HINT },
  },
  virtual_lines = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN]  = " ",
      [vim.diagnostic.severity.HINT]  = " ",
      [vim.diagnostic.severity.INFO]  = " ",
    },
  },
  underline        = true,
  update_in_insert = false,
  severity_sort    = true,
  float = {
    focusable = true,
    style     = "minimal",
    border    = "rounded",
    source    = "always",
    header    = "",
    prefix    = "",
  },
})
