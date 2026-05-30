#!/usr/bin/env bash

# Neovim — Arch Linux installer

set -euo pipefail

NVIM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
info()    { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[OK]${NC} $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

# Check requirements
info "Checking requirements..."

check_cmd() {
  if ! command -v "$1" &>/dev/null; then
    warn "$1 not found. Installing via pacman..."
    sudo pacman -S --noconfirm "$2" 2>/dev/null || warn "Could not install $2 automatically"
  else
    success "$1 found"
  fi
}

check_cmd nvim neovim
check_cmd git git
check_cmd rg ripgrep
check_cmd fd fd
check_cmd make make
check_cmd gcc gcc

# Neovim version check
NVIM_VERSION=$(nvim --version | head -1 | grep -oP 'v\K[0-9]+\.[0-9]+')
NVIM_MAJOR=$(echo "$NVIM_VERSION" | cut -d. -f1)
NVIM_MINOR=$(echo "$NVIM_VERSION" | cut -d. -f2)
if [[ $NVIM_MAJOR -lt 1 && $NVIM_MINOR -lt 10 ]]; then
  error "Neovim 0.10 ou superior necessário (versão $NVIM_VERSION encontrada). Instale: neovim"
fi
success "Neovim v$NVIM_VERSION"

# Rust toolchain
if ! command -v rustup &>/dev/null; then
  warn "rustup not found. Installing..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
  # shellcheck source=/dev/null
  source "$HOME/.cargo/env"
fi

info "Garantir a cadeia de ferramentas 'nightly' para rustfmt..."
rustup toolchain install nightly --component rustfmt 2>/dev/null || true
rustup component add rust-src rust-analyzer clippy rustfmt 2>/dev/null || true
success "Pronto para o conjunto de ferramentas Rust"

# Optional: codelldb from AUR / Mason
if ! command -v codelldb &>/dev/null; then
  warn "O codelldb não foi encontrado em todo o sistema. O Mason irá instalá-lo automaticamente na primeira inicialização do Neovim."
fi

# Optional tools
info "Instalando formatadores opcionais..."
if command -v cargo &>/dev/null; then
  cargo install taplo-cli 2>/dev/null || warn "taplo already installed or failed"
fi
if command -v pipx &>/dev/null; then
  pipx install cmakelang 2>/dev/null || true
fi

# Backup existing config
if [[ -d "$NVIM_DIR" ]]; then
  BACKUP="${NVIM_DIR}.bak.$(date +%Y%m%d_%H%M%S)"
  warn "Configuração nvim existente encontrada. Fazendo backup para $BACKUP"
  mv "$NVIM_DIR" "$BACKUP"
fi

# Copy config
info "Instalando a configuração em $NVIM_DIR..."
cp -r "$SCRIPT_DIR" "$NVIM_DIR"
success "Configuração instalada"

# Launch Neovim to bootstrap
echo ""
echo -e "${GREEN}═══════════════════════════════════════════${NC}"
echo -e "${GREEN}  Instalação concluída! ${NC}"
echo -e "${GREEN}═══════════════════════════════════════════${NC}"
echo ""
echo "  Próximos passos:"
echo "  1. Execute: nvim"
echo "  2. Aguarde até que o lazy.nvim instale todos os plugins. (~2 min)"
echo "  3. Execute :MasonInstall codelldb stylua taplo shfmt"
echo "  4. Abra seu arquivo e aproveite o Neovim!"
echo ""
echo "  Atalhos essenciais para conhecer:"
echo "   <Space>ff    — Find files"
echo "   <Space>rr    — Rust runnables"
echo "   <Space>rd    — Rust debuggables"
echo "   <Space>re    — Expand macro"
echo "   <Space>rh    — Hover actions"
echo "   <Space>xx    — Diagnostics panel"
echo "   <Space>tt    — Float terminal"
echo "   <Space>tn    — Run nearest test"
echo "   <F5>         — Start debugger"
echo "   <Space>ih    — Toggle inlay hints"
echo "   gd           — Go to definition"
echo "   K            — Hover docs"
echo "   <Space>ca    — Code action"
echo ""
