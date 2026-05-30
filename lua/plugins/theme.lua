-- ══════════════════════════════════════════════
-- Theme — VSCode Dark Modern
-- ══════════════════════════════════════════════

return {
  {
    "Mofiqul/vscode.nvim",
    lazy     = false,
    priority = 1000,
    opts = {
      style           = "dark",
      transparent     = false,
      italic_comments = true,
      color_overrides = {
        vscBack       = "#1e1e1e",
        vscTabCurrent = "#1e1e1e",
        vscTabOther   = "#2d2d2d",
        vscTabOutside = "#252526",
      },
      group_overrides = {
        LspInlayHint              = { fg = "#6A9955", italic = true, bg = "#1e1e1e" },
        ["@variable"]             = { fg = "#9CDCFE" },
        ["@function"]             = { fg = "#DCDCAA" },
        ["@keyword"]              = { fg = "#569CD6", bold = true },
        ["@type"]                 = { fg = "#4EC9B0" },
        ["@macro"]                = { fg = "#C586C0" },
        ["@lsp.type.macro.rust"]     = { fg = "#C586C0" },
        ["@lsp.type.lifetime.rust"]  = { fg = "#569CD6", italic = true },
        ["@lsp.type.attribute.rust"] = { fg = "#C586C0" },
        ["@lsp.type.typeParameter"]  = { fg = "#4EC9B0", italic = true },
        DiagnosticVirtualTextError   = { fg = "#F44747", italic = true },
        DiagnosticVirtualTextWarn    = { fg = "#CCA700", italic = true },
        DiagnosticVirtualTextInfo    = { fg = "#75BEFF", italic = true },
        DiagnosticVirtualTextHint    = { fg = "#6A9955", italic = true },
      },
    },
    config = function(_, opts)
      require("vscode").setup(opts)
      vim.cmd.colorscheme("vscode")
    end,
  },
}
