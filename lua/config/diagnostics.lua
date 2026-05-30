-- ══════════════════════════════════════════════
-- Health check & diagnostics
-- ══════════════════════════════════════════════

local M = {}

function M.show_health()
  local report = {}

  table.insert(report, "🔍 Neovim Configuration Diagnostic Report")
  table.insert(report, "==========================================\n")

  -- Neovim version
  local v = vim.version()
  table.insert(report, ("✓ Neovim v%d.%d.%d"):format(v.major, v.minor, v.patch))

  -- Treesitter
  local ts_ok = pcall(require, "nvim-treesitter.configs")
  table.insert(report, ts_ok and "✓ Treesitter loaded" or "✗ Treesitter failed to load")

  -- LSP
  local lsp_clients = vim.lsp.get_clients()
  table.insert(report, ("✓ LSP: %d active client(s)"):format(#lsp_clients))

  -- Mason
  local mason_ok = pcall(require, "mason")
  if mason_ok then
    table.insert(report, "✓ Mason available")
  else
    table.insert(report, "✗ Mason not available")
  end

  -- Rust analyzer
  local rust_clients = vim.lsp.get_clients({ name = "rust_analyzer" })
  if #rust_clients > 0 then
    table.insert(report, "✓ rust-analyzer connected")
  else
    table.insert(report, "⚠ rust-analyzer not connected (normal if no .rs file open)")
  end

  -- DAP
  local dap_ok = pcall(require, "dap")
  table.insert(report, dap_ok and "✓ DAP available" or "✗ DAP not available")

  -- nvim-cmp
  local cmp_ok = pcall(require, "cmp")
  table.insert(report, cmp_ok and "✓ Completion ready" or "✗ Completion not available")

  -- Modifiable flag
  local modifiable_ok = vim.bo.modifiable
  table.insert(report, modifiable_ok and "✓ Buffer modifiable" or "✗ Buffer not modifiable (run :set modifiable)")

  table.insert(report, "")
  table.insert(report, "Tips:")
  table.insert(report, "• Run :TSUpdate to rebuild treesitter parsers")
  table.insert(report, "• Run :Mason to manage language servers")
  table.insert(report, "• Run :checkhealth nvim to check Neovim health")
  table.insert(report, "• Open a .rs file to activate rust-analyzer")
  table.insert(report, "• Run :HealthCheck for extended tests")

  return report
end

function M.print_health()
  local report = M.show_health()
  for _, line in ipairs(report) do
    print(line)
  end
end

-- Extended health check with all tests
function M.run_extended_health()
  require("config.health-check").print_results()
end

-- Auto-show on startup if there are errors
vim.api.nvim_create_user_command("DiagnosticHealth", function()
  M.print_health()
end, { desc = "Show diagnostic health check" })

vim.api.nvim_create_user_command("HealthCheck", function()
  M.run_extended_health()
end, { desc = "Run extended health check tests" })
