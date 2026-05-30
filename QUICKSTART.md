# ⚡ Quick Start Guide

## Primeira Inicialização (5 minutos)

### 1. Instalar

```bash
# Se tiver config anterior, fazer backup
mv ~/.config/nvim ~/.config/nvim.bak

# Instalar
bash ./install.sh

# Ou manualmente:
nvim  # Vai instalar automaticamente todos os plugins via Lazy
```

**Tempo esperado**: ~1-2 minutos na primeira execução.

---

### 2. Primeiras Ações

```vim
# Dentro do Neovim, execute:
:TSUpdate            " Instalar parsers treesitter
:Mason               " Instalar rust-analyzer, codelldb, etc.
:DiagnosticHealth    " Ver saúde da config
```

---

### 3. Abrir um Projeto Rust

```bash
nvim ~/meu-projeto-rust/src/main.rs

# Ou abrir a pasta inteira:
nvim ~/meu-projeto-rust
# Use `-` para abrir explorador de arquivos
```

---

## Atalhos Essenciais (Cheat Sheet)

> A tecla \<leader\> é o Space


### 🔍 Navegação & Busca

| Tecla / Comando | Ação | Equivalente VSCode |
|-------|------|------|
| `<Space>ff` | Find Files (buscar arquivo no projeto) | `Ctrl+P` |
| `<Space>fg` | Live Grep (buscar palavra em tudo) | `Ctrl+Shift+F` |
| `/` (no modo normal) | Pesquisar palavra no arquivo atual | `Ctrl+F` |
| `:%s/velho/novo/g` | Substituição de texto no arquivo todo | `Ctrl+H` |
| `<Space>e` | Abrir/Focar no Explorador Lateral (NvimTree) | `Ctrl+B` |
| `F` (dentro da NvimTree) | Filtrar arquivos por nome (pesquisa local) | - |
| `<Space>fb` | Listar abas/buffers abertos | - |
| `gd` | Go to Definition (ir para definição) | `F12` |
| `gr` | Go to References (ver referências) | `Shift+F12` |
| `K` | Hover (ver documentação da função/tipo) | Hover Mouse |

### 🦀 Rust Específico

| Tecla | Ação |
|-------|------|
| `<Space>rr` | Runnables (executar função) |
| `<Space>rd` | Debuggables |
| `<Space>re` | Expand Macro |
| `<Space>rh` | Hover Actions |
| `<Space>ra` | Code Action (refactor) |

### 🔨 Cargo & Build

| Comando | Ação |
|---------|------|
| `:RustBuild` | `cargo build` |
| `:RustRun` | `cargo run` |
| `:RustTest` | `cargo test` |
| `:RustCheck` | `cargo check` |
| `:RustClippy` | `cargo clippy` |

### 🐛 Debug (DAP)

| Tecla | Ação |
|-------|------|
| `<F5>` | Continuar / Start debug |
| `<F10>` | Step Over |
| `<F11>` | Step Into |
| `<F12>` | Step Out |
| `<Space>db` | Toggle Breakpoint |
| `<Space>du` | Toggle DAP UI |

### ✅ Testes

| Tecla | Ação |
|-------|------|
| `<Space>tn` | Run nearest test |
| `<Space>tf` | Run file tests |
| `<Space>ta` | Run all tests |
| `<Space>ts` | Toggle test summary |
| `<Space>td` | Debug test |

### 📝 Editing

| Tecla | Ação |
|-------|------|
| `<C-space>` | Autocomplete (insert mode) |
| `<Space>rn` | Rename símbolo |
| `<Space>ca` | Code action |
| `<Space>cf` | Format |
| `<C-j>` / `<C-k>` | Move linha para cima/baixo |
| `jk` | Escape (insert mode) |

### 📁 Explorer & Splits

| Tecla | Ação |
|-------|------|
| `-` | Toggle Oil file explorer |
| `<C-h/j/k/l>` | Navigate entre splits |
| `<C-Up/Down/Left/Right>` | Resize splits |
| `<C-\>` | Float terminal |

### 🔧 UI & Config

| Comando | Ação |
|---------|------|
| `:Mason` | Instalar/gerenciar servidores |
| `:Lazy` | Gerenciar plugins |
| `:Trouble` | Ver diagnostics |
| `:DiagnosticHealth` | Health check |
| `:ZenMode` | Zen mode (foco total) |

---

## Primeiro Workflow Prático

### Criar novo projeto Rust

```bash
cargo new meu-app
cd meu-app
nvim
```

### Dentro do Neovim

```vim
# Abrir main.rs
:edit src/main.rs

# Ver completions (Ctrl+Space)
# Type: println
# <C-space> para ver sugestões

# Ir para definition
gd   (em qualquer função)

# Ver hover
K    (em qualquer símbolo)

# Executar teste
<Space>rr   (vai listar runnables)
```

---

## Perguntas Frequentes

### P: Como deletar uma linha com breakpoint?

R: Use `d` normalmente. O breakpoint será removido automaticamente.

### P: Preciso reinstalar tudo?

R: Não. Execute `:Lazy! sync` para sincronizar plugins.

### P: Posso usar com fzf-lua ao invés de Telescope?

R: Sim! Edite `lua/plugins/tools.lua` e substitua Telescope por fzf-lua.

### P: Posso customizar keymaps?

R: Sim! Edite `lua/config/keymaps.lua`. Mudanças são aplicadas ao reiniciar.

### P: Como ver os snippets disponíveis?

R: Digite parte do snippet (ex: `fn`) em um arquivo .rs e veja com `<C-space>`.

---

## Próximos Passos

1. ✅ Instalar e configurar
2. 📖 Ler `:help nvim-lspconfig` para entender LSP
3. 🎮 Praticar com os keymaps
4. 🦀 Abrir um projeto real e debugar
5. 📚 Customizar conforme necessário

---

## Precisa de Ajuda?

- Ver diagnostics: `:DiagnosticHealth`
- Troubleshooting: Ver arquivo `TROUBLESHOOTING.md`
- Documentação: `:help nvim` (geral), `:help lspconfig` (LSP)
