-- ══════════════════════════════════════════════
-- Autocommands
-- ══════════════════════════════════════════════

local function augroup(name)
  return vim.api.nvim_create_augroup("nvim_" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group    = augroup("yank_highlight"),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

-- Resize splits on window resize
vim.api.nvim_create_autocmd("VimResized", {
  group    = augroup("resize_splits"),
  callback = function() vim.cmd("tabdo wincmd =") end,
})

-- Close certain windows with q
vim.api.nvim_create_autocmd("FileType", {
  group   = augroup("close_with_q"),
  pattern = {
    "help", "lspinfo", "man", "notify", "qf",
    "spectre_panel", "startuptime", "checkhealth",
    "PlenaryTestPopup",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Auto-format Rust on save via conform
vim.api.nvim_create_autocmd("BufWritePre", {
  group   = augroup("rust_format"),
  pattern = "*.rs",
  callback = function()
    require("conform").format({ bufnr = vim.api.nvim_get_current_buf(), timeout_ms = 3000 })
  end,
})

-- Rust: set commentstring + inlay hints
vim.api.nvim_create_autocmd("FileType", {
  group   = augroup("rust_ft"),
  pattern = "rust",
  callback = function()
    vim.bo.commentstring = "// %s"
    if vim.lsp.inlay_hint then
      vim.lsp.inlay_hint.enable(true, { bufnr = 0 })
    end
  end,
})

-- Cargo.toml: show crates.nvim
vim.api.nvim_create_autocmd("BufRead", {
  group   = augroup("crates_attach"),
  pattern = "Cargo.toml",
  callback = function()
    require("crates").show()
  end,
})

-- Auto-create missing dirs on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group    = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then return end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Restore cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
  group    = augroup("restore_cursor"),
  callback = function()
    local mark   = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Disable diagnostics in .env files
vim.api.nvim_create_autocmd("BufEnter", {
  group   = augroup("no_diag_env"),
  pattern = ".env*",
  callback = function()
    vim.diagnostic.enable(false, { bufnr = 0 })
  end,
})

-- Protect special buffers from modification
vim.api.nvim_create_autocmd("FileType", {
  group   = augroup("protect_buffers"),
  pattern = {
    "lazy", "mason", "dashboard", "alpha", "help",
    "lspinfo", "checkhealth", "notify", "noice", "messages",
  },
  callback = function(event)
    vim.bo[event.buf].modifiable = false
    vim.bo[event.buf].buflisted = false
  end,
})

-- Fix modifiable flag for regular files
vim.api.nvim_create_autocmd("BufEnter", {
  group   = augroup("fix_modifiable"),
  callback = function(event)
    -- Only for regular files that should be modifiable
    if vim.fn.getbufvar(event.buf, "&buftype") == "" then
      vim.bo[event.buf].modifiable = true
    end
  end,
})
