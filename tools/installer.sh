#!/usr/bin/env sh

# Neovim — Arch Linux requirements installer

set -eu

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info() {
	printf "${BLUE}[INFO]${NC} %s\n" "$*"
}

success() {
	printf "${GREEN}[OK]${NC} %s\n" "$*"
}

warn() {
	printf "${YELLOW}[WARN]${NC} %s\n" "$*"
}

error() {
	printf "${RED}[ERROR]${NC} %s\n" "$*"
	exit 1
}

install_pkg() {
	cmd="$1"
	pkg="$2"

	if command -v "$cmd" >/dev/null 2>&1; then
		success "$cmd found"
	else
		warn "$cmd not found. Installing $pkg..."
		sudo pacman -S --needed --noconfirm "$pkg" ||
			warn "Failed to install $pkg"
	fi
}

info "Checking requirements..."

install_pkg nvim neovim
install_pkg git git
install_pkg rg ripgrep
install_pkg fd fd
install_pkg gcc gcc
install_pkg make make
install_pkg cargo rust

NVIM_VERSION="$(nvim --version | sed -n '1s/.*v\([0-9]*\.[0-9]*\).*/\1/p')"

if [ -z "$NVIM_VERSION" ]; then
	error "Could not detect Neovim version"
fi

success "Neovim v$NVIM_VERSION detected"

if ! command -v rustup >/dev/null 2>&1; then
	warn "rustup not found. Installing..."

	curl --proto '=https' --tlsv1.2 -sSf \
		https://sh.rustup.rs |
		sh -s -- -y --default-toolchain stable

	# shellcheck disable=SC1091
	. "$HOME/.cargo/env"
fi

info "Installing Rust components..."

rustup toolchain install nightly >/dev/null 2>&1 || true

rustup component add \
	rust-src \
	rust-analyzer \
	clippy \
	rustfmt >/dev/null 2>&1 || true

rustup component add \
	--toolchain nightly \
	rustfmt >/dev/null 2>&1 || true

success "Rust toolchain ready"

if ! command -v codelldb >/dev/null 2>&1; then
	warn "codelldb not found. Mason can install it automatically."
fi

info "Installing optional formatters..."

if command -v cargo >/dev/null 2>&1; then
	cargo install taplo-cli >/dev/null 2>&1 || true
fi

if command -v pipx >/dev/null 2>&1; then
	pipx install cmakelang >/dev/null 2>&1 || true
fi

# Launch Neovim to bootstrap
echo ""
success "Requirements installed successfully"
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
