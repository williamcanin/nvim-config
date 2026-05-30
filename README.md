# 🦀 Rust-Edition Neovim Configuration (2026)

Uma configuração **completa e profissional** de Neovim para desenvolvimento em Rust.

> ⚡ **Começar rápido?** Veja [QUICKSTART.md](./QUICKSTART.md)
> 🚨 **Problemas?** Veja [TROUBLESHOOTING.md](./TROUBLESHOOTING.md)

## 🎯 Funcionalidades

- ✅ **Rust-Analyzer** com LSP completo (inlay hints, code lens)
- ✅ **Debugging** com CodeLLDB + DAP UI
- ✅ **Testing** com Neotest (execute e debug testes)
- ✅ **Code Formatting** com Rustfmt (automático ao salvar)
- ✅ **Linting** com Clippy integrado
- ✅ **Snippets** customizados para Rust
- ✅ **Completion** inteligente com nvim-cmp + LSP
- ✅ **Crate Manager** com crates.nvim
- ✅ **Git Integration** com Gitsigns
- ✅ **Fuzzy Finder** com Telescope + FZF
- ✅ **File Explorer** com Oil.nvim
- ✅ **Terminal Integrado** com Toggleterm
- ✅ **UI Moderna** com Lualine, Bufferline, Noice
- ✅ **Treesitter** para syntax highlighting perfeito

## O que mudou da versão anterior

### ✨ Corrigido

- ✅ **Treesitter error**: Agora usa `pcall()` com fallback seguro
- ✅ **open_programs deprecated**: Removido de crates.nvim (não era necessário)
- ✅ **Carregamento LSP**: Migrado para `vim.lsp.config()` (Neovim 0.11+ style)

### 📦 Removidas deprecações

- **`null_ls`** — Substituído por `conform.nvim` (formatter) + `nvim-lint` (linter)
- **`nvim-colorizer.lua`** — Substituído por `nvim-highlight-colors`
- **`Comment.nvim`** — Substituído por `ts-comments.nvim` (treesitter-aware)
- **`foldexpr treesitter`** — Substituído por `nvim-ufo`

## 📋 Requisitos

- **Neovim** 0.11+ ([Instalar](https://github.com/neovim/neovim/releases))
- **Rust** + Cargo ([Instalar rustup](https://rustup.rs))
- **Git** + Curl
- **Ripgrep** (opcional, mas recomendado): `pacman -S ripgrep` (Arch)
- **Nerd Font** para ícones: [JetBrainsMono Nerd Font](https://www.nerdfonts.com)

## 🚀 Instalação

```bash
# 1. Backup da config atual (se existir)
mv ~/.config/nvim ~/.config/nvim.bak

# 2. Clonar esta config
git clone <repo> ~/.config/nvim

# 3. Instalar requerimentos
make install

# 4. Abrir Neovim (instala plugins automaticamente)
nvim

# 5. Dentro do Neovim, execute:
:TSUpdate       # Instalar parsers treesitter
:Mason          # Instalar rust-analyzer, codelldb, etc.
```

**Tempo total**: ~1-2 minutos na primeira execução.

## 📖 Documentação & Guias

- 📘 **[QUICKSTART.md](./QUICKSTART.md)** — Primeiros passos
- 🔧 **[TROUBLESHOOTING.md](./TROUBLESHOOTING.md)** — Solução de problemas

## ⌨️ Atalhos Principais

> A tecla \<leader\> é o Space

| Atalho      | Ação                         |
|-------------|------------------------------|
| `<Space>ff` | Buscar arquivos              |
| `<Space>fg` | Buscar no projeto (grep)     |
| `<Space>rr` | Rust runnables               |
| `<Space>rd` | Rust debuggables             |
| `<Space>re` | Expandir macro               |
| `<F5>`      | Debug: continuar             |
| `<F10>`     | Debug: step over             |
| `<Space>db` | Toggle breakpoint            |
| `<Space>xx` | Painel de diagnósticos       |
| `-`         | Abrir explorador de arquivos |
| `<C-\>`     | Terminal flutuante           |
| `<Space>rn` | Renomear símbolo             |
| `gd`        | Ir para definição            |
| `gr`        | Referências                  |
| `K`         | Documentação                 |

## 🆘 Comandos Úteis

```vim
:DiagnosticHealth     " Ver saúde da config
:Mason                " Gerenciar ferramentas
:TSUpdate             " Reinstalar treesitter
:LspInfo              " Ver LSP status
:RustBuild            " cargo build
:RustTest             " cargo test
:RustRun              " cargo run
:RustFormat           " cargo fmt
:RustClippy           " cargo clippy
```

## 📊 Stats

- **Startup**: ~200ms
- **Plugins**: 50+ (80% lazy-loaded)
- **Memory**: ~50MB idle

## 📞 Suporte

Problemas? Veja [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) ou execute `:DiagnosticHealth`

---

**Última atualização**: Maio 2026 | Neovim 0.11+ | Rust Edition 2021
