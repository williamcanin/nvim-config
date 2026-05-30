-- ══════════════════════════════════════════════
-- Custom Rust Commands & Utilities
-- ══════════════════════════════════════════════

local M = {}

-- Format entire project
vim.api.nvim_create_user_command("RustFormat", function()
  vim.cmd("silent !cargo fmt")
  vim.notify("✓ Formatted with cargo fmt", vim.log.levels.INFO)
end, { desc = "Format entire project with cargo fmt" })

-- Clippy check
vim.api.nvim_create_user_command("RustClippy", function()
  vim.cmd("silent !cargo clippy -- -D warnings")
  vim.notify("✓ Clippy check complete", vim.log.levels.INFO)
end, { desc = "Run clippy linter" })

-- Build project
vim.api.nvim_create_user_command("RustBuild", function()
  vim.cmd("TermExec cmd='cargo build'")
end, { desc = "Build project" })

-- Run project
vim.api.nvim_create_user_command("RustRun", function()
  vim.cmd("TermExec cmd='cargo run'")
end, { desc = "Run project" })

-- Run tests
vim.api.nvim_create_user_command("RustTest", function()
  vim.cmd("TermExec cmd='cargo test'")
end, { desc = "Run all tests" })

-- Test with output
vim.api.nvim_create_user_command("RustTestAll", function()
  vim.cmd("TermExec cmd='cargo test -- --nocapture'")
end, { desc = "Run tests with output" })

-- Check project
vim.api.nvim_create_user_command("RustCheck", function()
  vim.cmd("TermExec cmd='cargo check'")
end, { desc = "Check project for errors" })

-- Doc tests
vim.api.nvim_create_user_command("RustDocTest", function()
  vim.cmd("TermExec cmd='cargo test --doc'")
end, { desc = "Run documentation tests" })

-- Expand macros at cursor
vim.api.nvim_create_user_command("RustExpandMacro", function()
  if vim.fn.exists(":RustLsp") == 2 then
    vim.cmd("RustLsp expandMacro")
  else
    vim.notify("rustaceanvim not ready", vim.log.levels.WARN)
  end
end, { desc = "Expand macro at cursor" })

-- Open Rust documentation for crate
vim.api.nvim_create_user_command("RustDocs", function()
  if vim.fn.exists(":RustLsp") == 2 then
    vim.cmd("RustLsp openDocs")
  else
    vim.notify("rustaceanvim not ready", vim.log.levels.WARN)
  end
end, { desc = "Open docs.rs for crate" })

-- Show crate graph (visual dependency graph)
vim.api.nvim_create_user_command("RustCrateGraph", function()
  if vim.fn.exists(":RustLsp") == 2 then
    vim.cmd("RustLsp crateGraph")
  else
    vim.notify("rustaceanvim not ready", vim.log.levels.WARN)
  end
end, { desc = "Show crate dependency graph" })

-- View Cargo.toml
vim.api.nvim_create_user_command("RustCargoToml", function()
  vim.cmd("edit Cargo.toml")
end, { desc = "Open Cargo.toml" })

-- Re-compile after dependency changes
vim.api.nvim_create_user_command("RustRebuildProcMacros", function()
  if vim.fn.exists(":RustLsp") == 2 then
    vim.cmd("RustLsp rebuildProcMacros")
  else
    vim.notify("rustaceanvim not ready", vim.log.levels.WARN)
  end
end, { desc = "Rebuild procedural macros" })

return M
