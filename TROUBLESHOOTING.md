# 🚨 Troubleshooting Guide

## Problemas Comuns e Soluções

### 1. **Treesitter Error: "module 'nvim-treesitter.configs' not found"**

**Causa**: Treesitter não foi compilado ou não carregou corretamente.

**Solução**:

```vim
:TSUpdate          " Reinstalar todos os parsers
:TSInstall rust toml lua markdown  " Instalar parsers específicos
:checkhealth treesitter
```

Se o problema persistir:

```bash
rm -rf ~/.local/share/nvim/lazy/nvim-treesitter
nvim +Lazy! sync +qa
```

---

### 2. **E21: Impossível fazer mudanças, 'modifiable' está desativado**

**Causa**: Buffer não-modificável está ativo quando lazy.nvim tenta fazer operações.

**Solução** (já implementada):

- Autocmds agora protegem buffers especiais (lazy, mason, dashboard, etc)
- Lazy checker desativado (não faz check automático na inicialização)
- Buffer modifiable é restaurado ao entrar em arquivos regulares

Se ainda ocorrer:

```vim
:set modifiable        " Ativar modifiable manualmente
:set buftype=          " Remover tipo de buffer especial
```

---

### 3. **LSP não conecta (rust-analyzer não aparece)**

**Causa**: rust-analyzer não está instalado ou LSP não inicializou.

**Solução**:

1. Abra um arquivo `.rs`
2. Execute `:Mason`
3. Procure por "rust-analyzer" e instale
4. Reinicie o Neovim

```vim
:LspInfo  " Ver status dos LSP
:LspStart " Iniciar LSP manualmente
```

---

### 3. **Debugging não funciona (DAP)**

**Causa**: CodeLLDB não está instalado.

**Solução**:

```vim
:Mason
" Instale: codelldb
```

Ou via terminal:

```bash
cargo install codelldb
```

---

### 4. **Completion (autocomplete) não funciona**

**Solução**:

1. Pressione `<C-Space>` em modo Insert
2. Verifique se LSP está ativo: `:LspInfo`
3. Reinstale nvim-cmp: `:Lazy! sync nvim-cmp`

---

### 5. **Formatação não funciona**

**Causa**: Formatadores não instalados.

**Solução**:

```bash
# Instalar via rustup (padrão)
rustup component add rustfmt

# Instalar nightly rustfmt
rustup toolchain install nightly --component rustfmt

# Instalar Stylua (Lua)
cargo install stylua

# Instalar Taplo (TOML)
cargo install taplo-cli
```

---

### 6. **Tests não rodam**

**Solução**:

```vim
" Executar teste mais próximo
:lua require("neotest").run.run()
" Ou tecla: <Space>tn

" Ver sumário de testes
:lua require("neotest").summary.toggle()
" Ou tecla: <Space>ts
```

---

### 7. **Git integration (Gitsigns) não funciona**

**Solução**:

```vim
:Gitsigns toggle_signs  " Ativar/desativar sinais
:Gitsigns reset_hunk    " Restaura mudança local
```

---

### 8. **Mason não abre ou erro ao instalar**

**Solução**:

```bash
# Reinstalar todas as dependências
rm -rf ~/.local/share/nvim/mason
nvim +Mason +qa

# Ou usar :MasonInstall diretamente
```

---

## Diagnostics

Use o comando customizado para ver saúde da config:

```vim
:DiagnosticHealth
```

Isso mostra:

- ✓ Versão do Neovim
- ✓ Status do Treesitter
- ✓ LSP conectados
- ✓ DAP disponível
- ✓ Completion pronto

---

## Verificar Saúde Geral

```vim
:checkhealth nvim         " Saúde geral do Neovim
:checkhealth treesitter   " Treesitter
:checkhealth lsp          " LSP
:LspInfo                  " Info detalhada dos servidores
:Mason                    " Manager de ferramentas
```

---

## Logs e Debug

Ver logs do Neovim:

```bash
tail -f ~/.cache/nvim/log  # Neovim logs
```

Ver logs de LSP:

```vim
:lua vim.lsp.set_log_level("debug")
" Depois abra um arquivo .rs e veja o log acima
```

---

## Performance

Se Neovim está lento:

```bash
# Profile de startup
nvim --startuptime startup.log
tail -30 startup.log

# Profile da sessão
:verbose set fileencoding?
```

---

## Contacto / Mais Ajuda

- Documentação: `:help nvim`
- Repositórios:
  - `mrcjkb/rustaceanvim` — Rust support
  - `neovim/nvim-lspconfig` — LSP
  - `folke/lazy.nvim` — Plugin manager
