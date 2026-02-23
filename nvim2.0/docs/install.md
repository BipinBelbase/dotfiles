# Install

## 1) Prerequisites

Install:

- `neovim` (stable)
- `git`
- `ripgrep`
- `fd`
- `node` and `npm`
- `python3` and `pip`
- `rustup` and `cargo`

Python provider:

```bash
python3 -m pip install --user pynvim
```

## 2) Point Neovim to This Config

```bash
ln -sfn ~/dotfiles/nvim ~/.config/nvim
```

Verify:

```bash
ls -ld ~/.config/nvim
```

Expected: symlink target should be `~/dotfiles/nvim`.

## 3) First Launch

```bash
nvim
```

Then run:

```vim
:Lazy restore
:checkhealth
```

## 4) Optional Tools

- `tmux` + `tmux-sessionizer` for `<C-F>` keymap.
- Database tools (`vim-dadbod-ui`) are optional and disabled by default.
