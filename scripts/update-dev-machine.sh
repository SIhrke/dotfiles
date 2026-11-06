#!/usr/bin/env bash
# Run this once on your host dev machine to pick up everything the nvim
# config in this repo now needs: neovim >=0.12 (nvim-treesitter's `main`
# branch API requires it) and the tree-sitter CLI (needed to build parsers -
# apt's tree-sitter-cli is too old). Safe to re-run.
set -euo pipefail

NVIM_VERSION=v0.12.6
TREE_SITTER_VERSION=v0.27.1
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

case "$(uname -m)" in
    x86_64) ARCH=x86_64; TS_ARCH=x64 ;;
    aarch64|arm64) ARCH=arm64; TS_ARCH=arm64 ;;
    *) echo "update-dev-machine: unsupported arch $(uname -m)" >&2; exit 1 ;;
esac

echo "==> installing neovim ${NVIM_VERSION} to ~/.local/opt/nvim"
tmp_nvim="$(mktemp)"
curl -fsSL -o "$tmp_nvim" \
    "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-${ARCH}.tar.gz"
mkdir -p ~/.local/opt
rm -rf ~/.local/opt/nvim
tar -C ~/.local/opt -xzf "$tmp_nvim"
mv "$HOME/.local/opt/nvim-linux-${ARCH}" ~/.local/opt/nvim
mkdir -p ~/.local/bin
ln -sf ~/.local/opt/nvim/bin/nvim ~/.local/bin/nvim
rm -f "$tmp_nvim"

echo "==> installing tree-sitter CLI ${TREE_SITTER_VERSION} to ~/.local/bin/tree-sitter"
# stream through gunzip rather than downloading to a file first - gunzip
# refuses to touch a file without a recognized .gz suffix, and mktemp
# doesn't give us one.
curl -fsSL "https://github.com/tree-sitter/tree-sitter/releases/download/${TREE_SITTER_VERSION}/tree-sitter-linux-${TS_ARCH}.gz" \
    | gunzip > ~/.local/bin/tree-sitter
chmod 755 ~/.local/bin/tree-sitter

# ~/.local/bin only lands on PATH via .zshrc in a *new* shell - make sure
# this script's own `nvim`/`tree-sitter` calls below (and the version
# check) use what was just installed, not whatever was already resolvable.
export PATH="$HOME/.local/bin:$PATH"
hash -r

echo "==> versions now on PATH:"
command -v nvim
nvim --version | head -1
command -v tree-sitter
tree-sitter --version

# the `export PATH` above only affects this script - check what an actual
# interactive zsh (i.e. what you'll really get in a terminal) resolves to.
if command -v zsh >/dev/null 2>&1; then
    real_nvim="$(zsh -ic 'command -v nvim' 2>/dev/null || true)"
    if [ "$real_nvim" != "$HOME/.local/bin/nvim" ]; then
        echo "WARNING: an interactive zsh resolves 'nvim' to '${real_nvim:-<not found>}', not ~/.local/bin/nvim - check PATH order in .zshrc" >&2
    fi
fi

if [ -f "$HOME/.p10k.zsh" ] && [ ! -e "$DOTFILES_DIR/zsh/.p10k.zsh" ]; then
    echo "==> copying ~/.p10k.zsh into dotfiles (needed for the devcontainer symlink)"
    cp "$HOME/.p10k.zsh" "$DOTFILES_DIR/zsh/.p10k.zsh"
fi

echo "==> syncing plugins (forces nvim-treesitter/-textobjects onto the new API commit, compiles parsers - can take a minute on first run)"
nvim --headless "+Lazy! sync" +qa

echo "==> checkhealth nvim-treesitter"
nvim --headless -c 'checkhealth nvim-treesitter' -c 'qa!' 2>&1 | grep -iE 'error' && \
    echo "^ errors found above, check :checkhealth nvim-treesitter interactively" || \
    echo "no errors"

echo "==> done. Open nvim normally to confirm everything looks right."
