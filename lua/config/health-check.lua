-- ══════════════════════════════════════════════
-- Health Check Test Suite
-- ══════════════════════════════════════════════

local M = {}

function M.run_tests()
  local results = {}

  -- Test 1: Neovim version
  local v = vim.version()
  table.insert(results, {
    name = "Neovim Version",
    pass = v.major == 0 and v.minor >= 11,
    msg = ("v%d.%d.%d - %s"):format(v.major, v.minor, v.patch,
      v.major == 0 and v.minor >= 11 and "✓ OK" or "✗ Needs 0.11+")
  })

  -- Test 2: Treesitter
  local ts_ok = pcall(require, "nvim-treesitter.configs")
  table.insert(results, {
    name = "Treesitter Config",
    pass = ts_ok,
    msg = ts_ok and "✓ Loaded" or "✗ Failed to load"
  })

  -- Test 3: Lazy.nvim
  local lazy_ok = pcall(require, "lazy")
  table.insert(results, {
    name = "Lazy.nvim",
    pass = lazy_ok,
    msg = lazy_ok and "✓ Loaded" or "✗ Failed to load"
  })

  -- Test 4: Mason
  local mason_ok = pcall(require, "mason")
  table.insert(results, {
    name = "Mason",
    pass = mason_ok,
    msg = mason_ok and "✓ Available" or "✗ Not available"
  })

  -- Test 5: Modifiable flag
  local modifiable_ok = vim.bo.modifiable or vim.fn.getbufvar(0, "&modifiable") == 1
  table.insert(results, {
    name = "Buffer Modifiable",
    pass = modifiable_ok,
    msg = modifiable_ok and "✓ OK" or "✗ Not modifiable (run :set modifiable)"
  })

  -- Test 6: LSP config
  local lsp_ok = pcall(require, "lspconfig")
  table.insert(results, {
    name = "LSP Config",
    pass = lsp_ok,
    msg = lsp_ok and "✓ Available" or "✗ Failed to load"
  })

  -- Test 7: Completion
  local cmp_ok = pcall(require, "cmp")
  table.insert(results, {
    name = "nvim-cmp",
    pass = cmp_ok,
    msg = cmp_ok and "✓ Available" or "✗ Failed to load"
  })

  -- Test 8: DAP
  local dap_ok = pcall(require, "dap")
  table.insert(results, {
    name = "DAP (Debugger)",
    pass = dap_ok,
    msg = dap_ok and "✓ Available" or "✗ Failed to load"
  })

  return results
end

function M.print_results()
  local results = M.run_tests()
  local passed = 0
  local failed = 0

  print("\n" .. string.rep("=", 50))
  print("  🔍 Health Check Results")
  print(string.rep("=", 50) .. "\n")

  for _, result in ipairs(results) do
    local icon = result.pass and "✓" or "✗"
    print(("  %s %-25s %s"):format(icon, result.name, result.msg))
    if result.pass then
      passed = passed + 1
    else
      failed = failed + 1
    end
  end

  print("\n" .. string.rep("=", 50))
  print(("  Results: %d passed, %d failed"):format(passed, failed))
  print(string.rep("=", 50) .. "\n")

  if failed == 0 then
    print("  ✓ All checks passed! Your config is ready.")
  else
    print("  ✗ Some checks failed. See TROUBLESHOOTING.md for help.")
  end
  print("")
end

return M
