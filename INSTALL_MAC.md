# 📦 Dotfiles Installation Guide (for Mac)

This guide explains how to use the `install_mac.sh` script from [bipinbelbase/dotfiles](https://github.com/BipinBelbase/dotfiles) to set up your Mac development environment with full automation. Follow these steps carefully.

---

## ✅ Prerequisites

Before running the script:

1. **Install Git (if not installed):**

   ```bash
   xcode-select --install
   ```

   This installs command-line developer tools including Git.
2. **Then install download one file and run it just past this and work finished **

```bash
curl -fsSL -o ~/install_mac.sh https://raw.githubusercontent.com/bipinbelbase/dotfiles/main/install_mac.sh && chmod +x ~/install_mac.sh && ~/install_mac.sh```

```

2. **Allow script to run:**

   ```bash
   chmod +x install_mac.sh
   ```

   This makes the script executable.

3. **Run the script:**

   ```bash
   ./install_mac.sh
   ```

   Or run it in dry-run mode (to preview actions):

   ```bash
   ./install_mac.sh --dry-run
   ```

---

## 🔧 What the Script Does (Step-by-Step)

### 1. **Setup Variables**

* `DOTFILES` = `~/dotfiles`
* `BACKUP` = `~/dotfiles.bak`
* `REPO` = GitHub link to dotfiles repo
* `BFILE` = Homebrew `Brewfile`
* `TPM_DIR` = tmux plugin manager path

### 2. **Command-Line Arguments**

* `--dry-run`: Simulates the installation
* `--help` or `-h`: Shows help message

---

## 🚀 Installation Steps

### 🥇 Step 1: Install Homebrew (if not already installed)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then adds it to your shell environment (zsh).

### 🥈 Step 2: Ensure Git is Installed

If not, installs it via:

```bash
brew install git
```

### 🥉 Step 3: Clone Your Dotfiles Repo

* Backs up old `~/dotfiles` as `~/dotfiles.bak`
* Clones fresh from GitHub

### 🍻 Step 4: Brewfile Bundle

Installs apps and CLI tools defined in `homebrew/Brewfile`:

```bash
brew bundle --file="$DOTFILES/homebrew/Brewfile" --no-lock
```

### 🌟 Step 5: Install Oh My Zsh

Skips if already installed. Otherwise:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### 🔌 Step 6: Install Tmux Plugin Manager

* Clones TPM if not present
* Runs `install_plugins.sh` inside a temporary tmux session

### 🔗 Step 7: Create Symlinks

For each config file:

* If existing symlink: updates it
* If file exists: backs it up to `.bak`
* If nothing exists: creates new symlink

Linked files include:

* `~/.zshrc`, `~/.zprofile`, `~/.p10k.zsh`
* `~/.tmux.conf`
* `~/.config/nvim`
* VS Code settings and keybindings
* `~/.config/ghostty/config`

### 🔄 Step 8: Source zsh config

* Automatically sources `~/.zshrc`
* Or prompts you to manually source if shell info is missing

---

## 🧪 Optional: Dry Run Mode

```bash
./install_mac.sh --dry-run
```

Shows all actions without actually executing them.

---

## ✅ Final Notes

* Run:

  ```bash
  p10k configure
  ```

  to set up Powerlevel10k
* Inside tmux, press `Prefix + I` to install TPM plugins
* Open new terminal or run:

  ```bash
  exec $SHELL
  ```

