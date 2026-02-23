# Neovim (LazyVim) Configuration

Stable, low-maintenance LazyVim setup for Python, TypeScript/React, and Rust workflows.

## Docs

- [docs/overview.md](docs/overview.md)
- [docs/install.md](docs/install.md)
- [docs/update.md](docs/update.md)
- [docs/troubleshooting.md](docs/troubleshooting.md)
- [docs/keymaps.md](docs/keymaps.md)

## Dependencies

- `neovim` (latest stable at update time; no nightly required)
- `git`
- `ripgrep` (`rg`)
- `fd`
- `node` + `npm`
- `python3` + `pip` + `pynvim` (`python3 -m pip install --user pynvim`)
- `rustup` + `cargo` (for Rust workflow)

Optional:

- `tmux` + `tmux-sessionizer` (used by `<C-F>` mapping)

## Install

1. Clone this dotfiles repo.
2. Point Neovim config to this folder:
   - `ln -sfn ~/dotfiles/nvim ~/.config/nvim`
3. Start Neovim:
   - `nvim`
4. Verify plugin lock restore:
   - `:Lazy restore`

## Yearly Safe Update (Quick)

1. Update OS packages and Neovim stable.
2. Open `nvim` and run `:Lazy restore` first.
3. Run `:checkhealth`.
4. Run `:Lazy update` only when ready to refresh pins.
5. Commit `lazy-lock.json` with config changes.

Detailed flow: [docs/update.md](docs/update.md)

## Troubleshooting

See [docs/troubleshooting.md](docs/troubleshooting.md).
