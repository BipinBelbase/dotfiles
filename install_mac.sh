#!/usr/bin/env zsh
set -euo pipefail
IFS=$'\n\t'

# === CONFIG ===
DOTFILES="${0:A:h}"
BFILE="$DOTFILES/packages/Brewfile"
TPM_DIR="$HOME/.tmux/plugins/tpm"
TPM_PARENT="$(dirname "$TPM_DIR")"
typeset -A FILES
FILES=(
    .zshrc "stow/zsh/.zshrc"
    .zprofile "stow/zsh/.zprofile"
    .p10k.zsh "stow/zsh/.p10k.zsh"
    .bashrc "stow/bash/.bashrc"
    .ideavimrc "stow/ideavim/.ideavimrc"
    .tmux.conf "stow/tmux/.tmux.conf"
    .local/bin/tmux-sessionizer "stow/tmux/.local/bin/tmux-sessionizer"
    .local/bin/tmux_sessionizer.sh "stow/tmux/.local/bin/tmux-sessionizer"
    .config/nvim "stow/nvim/.config/nvim"
    .config/skhd "stow/skhd/.config/skhd"
    .skhdrc "stow/skhd/.skhdrc"
    .config/yabai "stow/yabai/.config/yabai"
    .yabairc "stow/yabai/.yabairc"
    "Library/Application Support/Code/User/settings.json" "stow/vscode/Library/Application Support/Code/User/settings.json"
    "Library/Application Support/Code/User/keybindings.json" "stow/vscode/Library/Application Support/Code/User/keybindings.json"
    .config/ghostty "stow/ghostty/.config/ghostty"
)

# === FLAGS ===
DRY_RUN=false
SHOW_HELP=false
FROM_STEP=homebrew
STARTED_FROM_STEP=false

for arg in "$@"; do
    case "$arg" in
    --dry-run)
        DRY_RUN=true
        ;;
    --help | -h)
        SHOW_HELP=true
        ;;
    --from=*)
        FROM_STEP="${arg#--from=}"
        ;;
    *)
        echo "❌ Unknown option: $arg"
        exit 1
        ;;
    esac
done

if $SHOW_HELP; then
    cat <<EOF
Usage: ./install_mac.sh [options]

Options:
  --dry-run       Show what would be done, without making any changes.
  --from=STEP     Resume at: homebrew, git, clone, packages, zsh, tmux, links.
  --help, -h      Show this help message and exit.

Example:
  ./install_mac.sh --dry-run
  ./install_mac.sh --from=packages
EOF
    exit 0
fi

run() {
    if $DRY_RUN; then
        echo "🧪 [Dry Run] $*"
    else
        eval "$@"
    fi
}

should_run_step() {
    local step="$1"
    if $STARTED_FROM_STEP; then
        CURRENT_STEP="$step"
        echo "▶ STEP: $step"
        return 0
    fi
    if [[ "$step" == "$FROM_STEP" ]]; then
        STARTED_FROM_STEP=true
        CURRENT_STEP="$step"
        echo "▶ STEP: $step"
        return 0
    fi
    return 1
}

case "$FROM_STEP" in
    homebrew | git | clone | packages | zsh | tmux | links) ;;
    *) echo "❌ Unknown step: $FROM_STEP"; exit 1 ;;
esac

# Fail before installing anything if launched from an unreviewed location.
if [[ "$DOTFILES" != "${HOME:A}/dotfiles" ]]; then
    echo "❌ Install the reviewed checkout at ~/dotfiles on the separate test Mac."
    echo "This script will not install from $DOTFILES."
    exit 1
fi
if [[ "$(uname -s)" != Darwin ]]; then
    echo "❌ This installer supports macOS only."
    exit 1
fi
if [[ "$(uname -m)" != arm64 ]]; then
    echo "❌ The preserved window-manager configuration currently requires Apple Silicon."
    exit 1
fi
[[ -f "$BFILE" ]] || { echo "❌ Missing Brewfile: $BFILE"; exit 1; }
for target in ${(k)FILES}; do
    [[ -e "$DOTFILES/${FILES[$target]}" ]] || {
        echo "❌ Missing configuration source: ${FILES[$target]}"
        exit 1
    }
done
CURRENT_STEP=homebrew
TRAPZERR() {
    local exit_code=$?
    echo "❌ Setup stopped in stage: $CURRENT_STEP (exit $exit_code)" >&2
    echo "Inspect the error, then resume with: ./install_mac.sh --from=$CURRENT_STEP" >&2
    return "$exit_code"
}

# Preserve existing paths without overwriting an earlier backup.
backup_path() {
    local original="$1"
    local stamp candidate
    integer suffix=1

    stamp="$(date '+%Y%m%d-%H%M%S')"
    candidate="${original}.bak.${stamp}"
    while [ -e "$candidate" ] || [ -L "$candidate" ]; do
        candidate="${original}.bak.${stamp}.${suffix}"
        (( suffix += 1 ))
    done
    echo "$candidate"
}

echo "🚀 Starting Mac setup..."

    sleep 1

echo "Let's go!"
sleep 3

clear
cat <<EOF

███████╗████████╗ █████╗ ██████╗ ████████╗██╗███╗   ██╗ ██████╗                      
██╔════╝╚══██╔══╝██╔══██╗██╔══██╗╚══██╔══╝██║████╗  ██║██╔════╝                      
███████╗   ██║   ███████║██████╔╝   ██║   ██║██╔██╗ ██║██║  ███╗                     
╚════██║   ██║   ██╔══██║██╔══██╗   ██║   ██║██║╚██╗██║██║   ██║                     
███████║   ██║   ██║  ██║██║  ██║   ██║   ██║██║ ╚████║╚██████╔╝    ██╗    ██╗    ██╗
╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝     ╚═╝    ╚═╝    ╚═╝
                                                                                     

EOF
sleep 4

cat <<EOF

███╗   ███╗ █████╗  ██████╗     ██████╗ ███████╗    ███████╗███████╗████████╗██╗   ██╗██████╗ ███████╗
████╗ ████║██╔══██╗██╔════╝    ██╔═══██╗██╔════╝    ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗██╔════╝
██╔████╔██║███████║██║         ██║   ██║███████╗    ███████╗█████╗     ██║   ██║   ██║██████╔╝███████╗
██║╚██╔╝██║██╔══██║██║         ██║   ██║╚════██║    ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ ╚════██║
██║ ╚═╝ ██║██║  ██║╚██████╗    ╚██████╔╝███████║    ███████║███████╗   ██║   ╚██████╔╝██║     ███████║
╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝     ╚═════╝ ╚══════╝    ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝     ╚══════╝
                                                                                                      

EOF

sleep 8
clear
cat <<EOF

██████╗ 
╚════██╗
 █████╔╝
 ╚═══██╗
██████╔╝
╚═════╝ 
        


EOF
sleep 4

cat <<EOF

██████╗ 
╚════██╗
 █████╔╝
██╔═══╝ 
███████╗
╚══════╝
        


EOF
sleep 3

cat <<EOF

 ██╗
███║
╚██║
 ██║
 ██║
 ╚═╝
    


EOF
sleep 3
clear
cat <<EOF

 
      ██╗    ██╗███████╗██╗      ██████╗ ██████╗ ███╗   ███╗███████╗
      ██║    ██║██╔════╝██║     ██╔════╝██╔═══██╗████╗ ████║██╔════╝
      ██║ █╗ ██║█████╗  ██║     ██║     ██║   ██║██╔████╔██║█████╗
      ██║███╗██║██╔══╝  ██║     ██║     ██║   ██║██║╚██╔╝██║██╔══╝
      ╚███╔███╔╝███████╗███████╗╚██████╗╚██████╔╝██║ ╚═╝ ██║███████╗
       ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝
  ██████╗ ██████╗  ██████╗ ███████╗███████╗███████╗███████╗ ██████╗ ██████╗
  ██╔══██╗██╔══██╗██╔═══██╗██╔════╝██╔════╝██╔════╝██╔════╝██╔═══██╗██╔══██╗
  ██████╔╝██████╔╝██║   ██║█████╗  █████╗  ███████╗███████╗██║   ██║██████╔╝
  ██╔═══╝ ██╔══██╗██║   ██║██╔══╝  ██╔══╝  ╚════██║╚════██║██║   ██║██╔══██╗
  ██║     ██║  ██║╚██████╔╝██║     ███████╗███████║███████║╚██████╔╝██║  ██║
  ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚══════╝╚══════╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝


EOF
sleep 12
clear

cat <<EOF
██╗    ██╗    ██╗ █████╗ ███████╗    ██╗    ██╗ █████╗ ██╗████████╗██╗███╗   ██╗ ██████╗     ███████╗ ██████╗ ██████╗     
██║    ██║    ██║██╔══██╗██╔════╝    ██║    ██║██╔══██╗██║╚══██╔══╝██║████╗  ██║██╔════╝     ██╔════╝██╔═══██╗██╔══██╗    
██║    ██║ █╗ ██║███████║███████╗    ██║ █╗ ██║███████║██║   ██║   ██║██╔██╗ ██║██║  ███╗    █████╗  ██║   ██║██████╔╝    
██║    ██║███╗██║██╔══██║╚════██║    ██║███╗██║██╔══██║██║   ██║   ██║██║╚██╗██║██║   ██║    ██╔══╝  ██║   ██║██╔══██╗    
██║    ╚███╔███╔╝██║  ██║███████║    ╚███╔███╔╝██║  ██║██║   ██║   ██║██║ ╚████║╚██████╔╝    ██║     ╚██████╔╝██║  ██║    
╚═╝     ╚══╝╚══╝ ╚═╝  ╚═╝╚══════╝     ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝   ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝     ╚═╝      ╚═════╝ ╚═╝  ╚═╝    
        ██╗   ██╗ ██████╗ ██╗   ██╗                                                                                       
        ╚██╗ ██╔╝██╔═══██╗██║   ██║                                                                                       
         ╚████╔╝ ██║   ██║██║   ██║                                                                                       
          ╚██╔╝  ██║   ██║██║   ██║                                                                                       
           ██║   ╚██████╔╝╚██████╔╝                                                                                       
           ╚═╝    ╚═════╝  ╚═════╝                                                                                        
██╗     ███████╗████████╗███████╗    ██████╗  █████╗ ███╗   ██╗ ██████╗     ██╗████████╗                                  
██║     ██╔════╝╚══██╔══╝██╔════╝    ██╔══██╗██╔══██╗████╗  ██║██╔════╝     ██║╚══██╔══╝                                  
██║     █████╗     ██║   ███████╗    ██████╔╝███████║██╔██╗ ██║██║  ███╗    ██║   ██║                                     
██║     ██╔══╝     ██║   ╚════██║    ██╔══██╗██╔══██║██║╚██╗██║██║   ██║    ██║   ██║                                     
███████╗███████╗   ██║   ███████║    ██████╔╝██║  ██║██║ ╚████║╚██████╔╝    ██║   ██║                                     
╚══════╝╚══════╝   ╚═╝   ╚══════╝    ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝     ╚═╝   ╚═╝                                     
 █████╗  ██████╗  █████╗ ██╗███╗   ██╗    ██╗██╗██╗                                                                       
██╔══██╗██╔════╝ ██╔══██╗██║████╗  ██║    ██║██║██║                                                                       
███████║██║  ███╗███████║██║██╔██╗ ██║    ██║██║██║                                                                       
██╔══██║██║   ██║██╔══██║██║██║╚██╗██║    ╚═╝╚═╝╚═╝                                                                       
██║  ██║╚██████╔╝██║  ██║██║██║ ╚████║    ██╗██╗██╗                                                                       
╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝    ╚═╝╚═╝╚═╝                                                                       
EOF

sleep 9
clear
echo "lets install "

cat <<EOF
██╗  ██╗ ██████╗ ███╗   ███╗███████╗    ██████╗ ██████╗ ███████╗██╗    ██╗
██║  ██║██╔═══██╗████╗ ████║██╔════╝    ██╔══██╗██╔══██╗██╔════╝██║    ██║
███████║██║   ██║██╔████╔██║█████╗      ██████╔╝██████╔╝█████╗  ██║ █╗ ██║
██╔══██║██║   ██║██║╚██╔╝██║██╔══╝      ██╔══██╗██╔══██╗██╔══╝  ██║███╗██║
██║  ██║╚██████╔╝██║ ╚═╝ ██║███████╗    ██████╔╝██║  ██║███████╗╚███╔███╔╝
╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝ ╚══╝╚══╝ 
                                                                                                                                                              

EOF

sleep 4
# === STEP 1: Homebrew ===
if should_run_step homebrew; then
if ! command -v brew &>/dev/null; then
    echo "🍺 Installing Homebrew..."
    sleep 3
    run '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    if [[ -d /opt/homebrew ]]; then
        eval "$('/opt/homebrew/bin/brew' shellenv)"
    elif [[ -d /usr/local/Homebrew ]]; then
        eval "$('/usr/local/bin/brew' shellenv)"
    fi
else
    sleep 3
    echo "🍺 Homebrew already installed"
fi
fi


sleep 7

clear
cat <<EOF
 ██████╗ ██╗████████╗     ██████╗ ██╗████████╗     ██████╗ ██╗████████╗    
██╔════╝ ██║╚══██╔══╝    ██╔════╝ ██║╚══██╔══╝    ██╔════╝ ██║╚══██╔══╝    
██║  ███╗██║   ██║       ██║  ███╗██║   ██║       ██║  ███╗██║   ██║       
██║   ██║██║   ██║       ██║   ██║██║   ██║       ██║   ██║██║   ██║       
╚██████╔╝██║   ██║       ╚██████╔╝██║   ██║       ╚██████╔╝██║   ██║       
 ╚═════╝ ╚═╝   ╚═╝        ╚═════╝ ╚═╝   ╚═╝        ╚═════╝ ╚═╝   ╚═╝       
                                                                           

EOF
sleep 3
# === STEP 2: Git ===
if should_run_step git; then
if ! command -v git &>/dev/null; then
    echo "🔧 Installing Git..."
    sleep 3
    run "brew install git"
else
    echo "🔧 Git already installed"
    sleep 3
fi
fi
 
sleep 4

clear
cat <<EOF
 ██████╗██╗      ██████╗ ███╗   ██╗██╗███╗   ██╗ ██████╗     ██╗██╗
██╔════╝██║     ██╔═══██╗████╗  ██║██║████╗  ██║██╔════╝     ██║██║
██║     ██║     ██║   ██║██╔██╗ ██║██║██╔██╗ ██║██║  ███╗    ██║██║
██║     ██║     ██║   ██║██║╚██╗██║██║██║╚██╗██║██║   ██║    ╚═╝╚═╝
╚██████╗███████╗╚██████╔╝██║ ╚████║██║██║ ╚████║╚██████╔╝    ██╗██╗
 ╚═════╝╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝ ╚═════╝     ╚═╝╚═╝
                                                                   

EOF
sleep 8
# === STEP 3: Clone dotfiles ===
if should_run_step clone; then
if [ -d "$DOTFILES/.git" ] || [ -f "$DOTFILES/.git" ]; then
    echo "✅ Using the existing dotfiles checkout at $DOTFILES"
elif [ -e "$DOTFILES" ]; then
    echo "❌ $DOTFILES exists but is not a Git checkout. Nothing was moved or removed."
    exit 1
else
    echo "❌ Clone the reviewed branch into ~/dotfiles before running this installer."
    exit 1
fi
fi

sleep 3

clear

cat <<EOF
██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ██╗███╗   ██╗ ██████╗                 
██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██║████╗  ██║██╔════╝                 
██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     ██║██╔██╗ ██║██║  ███╗                
██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██║██║╚██╗██║██║   ██║                
██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗██║██║ ╚████║╚██████╔╝                
╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝                 
                                                                                            
██████╗ ██████╗ ███████╗██╗    ██╗                                                          
██╔══██╗██╔══██╗██╔════╝██║    ██║                                                          
██████╔╝██████╔╝█████╗  ██║ █╗ ██║                                                          
██╔══██╗██╔══██╗██╔══╝  ██║███╗██║                                                          
██████╔╝██║  ██║███████╗╚███╔███╔╝                                                          
╚═════╝ ╚═╝  ╚═╝╚══════╝ ╚══╝╚══╝                                                           
                                                                                            
██████╗  █████╗  ██████╗██╗  ██╗ █████╗  ██████╗ ███████╗███████╗                           
██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██╔══██╗██╔════╝ ██╔════╝██╔════╝                           
██████╔╝███████║██║     █████╔╝ ███████║██║  ███╗█████╗  ███████╗                           
██╔═══╝ ██╔══██║██║     ██╔═██╗ ██╔══██║██║   ██║██╔══╝  ╚════██║                           
██║     ██║  ██║╚██████╗██║  ██╗██║  ██║╚██████╔╝███████╗███████║                           
╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝                           
                                                                                            
 █████╗ ██╗     ██╗     ██╗     ██╗     ██╗     ██╗     ██╗     ██╗     ██╗     ██╗██╗██╗██╗
██╔══██╗██║     ██║     ██║     ██║     ██║     ██║     ██║     ██║     ██║     ██║██║██║██║
███████║██║     ██║     ██║     ██║     ██║     ██║     ██║     ██║     ██║     ██║██║██║██║
██╔══██║██║     ██║     ██║     ██║     ██║     ██║     ██║     ██║     ██║     ╚═╝╚═╝╚═╝╚═╝
██║  ██║███████╗███████╗███████╗███████╗███████╗███████╗███████╗███████╗███████╗██╗██╗██╗██╗
╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚═╝╚═╝╚═╝╚═╝
                                                                                            
EOF
# === STEP 4: Install Brew Packages ===
if should_run_step packages; then
if [ -f "$BFILE" ]; then
    echo "🍻 Installing Brew packages from Brewfile..."
    sleep 3
    run "brew bundle --file='$BFILE' --no-lock"
    # Replacing these binaries can invalidate macOS Accessibility/Input Monitoring approvals.
    run "brew pin skhd yabai"
    sleep 1
else
    echo "❌ Brewfile not found: $BFILE"
    exit 1
fi
fi

sleep 3
clear

cat <<EOF
 ██████╗ ██╗  ██╗    ███╗   ███╗██╗   ██╗    ███████╗███████╗██╗  ██╗██╗
██╔═══██╗██║  ██║    ████╗ ████║╚██╗ ██╔╝    ╚══███╔╝██╔════╝██║  ██║██║
██║   ██║███████║    ██╔████╔██║ ╚████╔╝       ███╔╝ ███████╗███████║██║
██║   ██║██╔══██║    ██║╚██╔╝██║  ╚██╔╝       ███╔╝  ╚════██║██╔══██║╚═╝
╚██████╔╝██║  ██║    ██║ ╚═╝ ██║   ██║       ███████╗███████║██║  ██║██╗
 ╚═════╝ ╚═╝  ╚═╝    ╚═╝     ╚═╝   ╚═╝       ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝
                                                                        

EOF

sleep 6
# === STEP 5: Oh My Zsh ===
if should_run_step zsh; then
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "🌟 Installing Oh My Zsh..."
    sleep 3 
    run "RUNZSH=no KEEP_ZSHRC=yes sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
else
    echo "🌟 Oh My Zsh already installed"
    sleep 2
fi
# The configuration names this custom OMZ plugin; Homebrew alone does not
# place it in OMZ's plugin search directory.
VI_MODE_DIR="$HOME/.oh-my-zsh/custom/plugins/zsh-vi-mode"
if [[ ! -d "$VI_MODE_DIR" ]]; then
    run "git clone https://github.com/jeffreytse/zsh-vi-mode '$VI_MODE_DIR'"
    # Preserve the custom plugin revision observed on the source Mac.
    run "git -C '$VI_MODE_DIR' checkout f82c4c8f4b2bdd9c914653d8f21fbb32e7f2ea6c"
fi
fi


sleep 6
clear

# === STEP 6: Tmux Plugin Manager ===

cat <<EOF
████████╗███╗   ███╗██╗   ██╗██╗  ██╗        ██╗  ██╗██╗  ██╗██╗  ██╗
╚══██╔══╝████╗ ████║██║   ██║╚██╗██╔╝        ╚██╗██╔╝╚██╗██╔╝╚██╗██╔╝
   ██║   ██╔████╔██║██║   ██║ ╚███╔╝          ╚███╔╝  ╚███╔╝  ╚███╔╝ 
   ██║   ██║╚██╔╝██║██║   ██║ ██╔██╗          ██╔██╗  ██╔██╗  ██╔██╗ 
   ██║   ██║ ╚═╝ ██║╚██████╔╝██╔╝ ██╗███████╗██╔╝ ██╗██╔╝ ██╗██╔╝ ██╗
   ╚═╝   ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝
                                                                     

EOF
sleep 5

# === STEP 6: Tmux Plugin Manager ===
if should_run_step tmux; then
if command -v tmux &>/dev/null; then
    if [ ! -d "$TPM_DIR" ]; then
        echo "🔌 Installing tmux plugin manager..."
        sleep 3
        run "mkdir -p '$TPM_PARENT'"
        run "git clone https://github.com/tmux-plugins/tpm '$TPM_DIR'"
    else
        echo "🔄 TPM already installed. Updating TPM..."
        sleep 3
        run "git -C '$TPM_DIR' pull origin master"
    fi

    echo "✨ Plugin downloads will run after the candidate config is linked."

else
    if ! $DRY_RUN; then
        echo "❌ tmux is missing. Complete the packages stage first."
        exit 1
    fi
fi
fi

sleep 6
clear

cat <<EOF
██╗     ██╗███╗   ██╗██╗  ██╗██╗███╗   ██╗ ██████╗                           
██║     ██║████╗  ██║██║ ██╔╝██║████╗  ██║██╔════╝                           
██║     ██║██╔██╗ ██║█████╔╝ ██║██╔██╗ ██║██║  ███╗█████╗    █████╗    █████╗
██║     ██║██║╚██╗██║██╔═██╗ ██║██║╚██╗██║██║   ██║╚════╝    ╚════╝    ╚════╝
███████╗██║██║ ╚████║██║  ██╗██║██║ ╚████║╚██████╔╝                          
╚══════╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝                           
                                                                        

EOF
sleep 8
# === STEP 7: Symlinks ===
if should_run_step links; then
echo "🔗 Creating symlinks for dotfiles..."

for target in ${(k)FILES}; do
    source="$DOTFILES/${FILES[$target]}"
    dest="$HOME/$target"
    dest_dir="$(dirname "$dest")"

    run "mkdir -p \"$dest_dir\""

    if [ -L "$dest" ]; then
        if [ "$(readlink "$dest")" = "$source" ]; then
            echo "✔ $target already linked"
            sleep 2
            continue
        else
            backup="$(backup_path "$dest")"
            echo "⚠ Preserving existing symlink $target at $backup"
            sleep 3
            run "mv \"$dest\" \"$backup\""
        fi
    elif [ -e "$dest" ]; then
        backup="$(backup_path "$dest")"
        echo "⚠ Backing up $target to $backup"
        sleep 2
        run "mv \"$dest\" \"$backup\""
    fi

    echo "🔗 Linking: $target"
    sleep 2
    run "ln -s \"$source\" \"$dest\""
done

# TPM's command-line installer reads ~/.tmux.conf and returns download failures.
# Run synchronously after linking; never terminate downloads on a timer.
CURRENT_STEP=links
echo "✨ Installing configured tmux plugins (waiting for completion)..."
run "'$TPM_DIR/bin/install_plugins'"
fi

sleep 4
clear


cat <<EOF
███████╗ ██████╗ ██╗   ██╗██████╗  ██████╗███████╗    ███████╗███████╗██╗  ██╗██╗██╗██╗
██╔════╝██╔═══██╗██║   ██║██╔══██╗██╔════╝██╔════╝    ╚══███╔╝██╔════╝██║  ██║██║██║██║
███████╗██║   ██║██║   ██║██████╔╝██║     █████╗        ███╔╝ ███████╗███████║██║██║██║
╚════██║██║   ██║██║   ██║██╔══██╗██║     ██╔══╝       ███╔╝  ╚════██║██╔══██║╚═╝╚═╝╚═╝
███████║╚██████╔╝╚██████╔╝██║  ██║╚██████╗███████╗    ███████╗███████║██║  ██║██╗██╗██╗
╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚══════╝    ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝╚═╝╚═╝
                                                                                       

EOF
# === STEP 9: Source ZSH ===
echo "ℹ️ Open a new terminal to load ~/.zshrc and its interactive shortcuts."
sleep 4

sleep 5
clear

cat <<EOF
███╗   ███╗██╗███████╗███████╗██╗ ██████╗ ███╗   ██╗    ██╗                                 
████╗ ████║██║██╔════╝██╔════╝██║██╔═══██╗████╗  ██║    ██║                                 
██╔████╔██║██║███████╗███████╗██║██║   ██║██╔██╗ ██║    ██║                                 
██║╚██╔╝██║██║╚════██║╚════██║██║██║   ██║██║╚██╗██║    ╚═╝                                 
██║ ╚═╝ ██║██║███████║███████║██║╚██████╔╝██║ ╚████║    ██╗                                 
╚═╝     ╚═╝╚═╝╚══════╝╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝    ╚═╝                                 
                                                                                            
 ██████╗ ██████╗ ███╗   ███╗██████╗ ██╗     ███████╗████████╗███████╗██████╗     ██╗        
██╔════╝██╔═══██╗████╗ ████║██╔══██╗██║     ██╔════╝╚══██╔══╝██╔════╝██╔══██╗    ██║        
██║     ██║   ██║██╔████╔██║██████╔╝██║     █████╗     ██║   █████╗  ██║  ██║    ██║        
██║     ██║   ██║██║╚██╔╝██║██╔═══╝ ██║     ██╔══╝     ██║   ██╔══╝  ██║  ██║    ╚═╝        
╚██████╗╚██████╔╝██║ ╚═╝ ██║██║     ███████╗███████╗   ██║   ███████╗██████╔╝    ██╗        
 ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═════╝     ╚═╝        
                                                                                            
██████╗ ██████╗  ██████╗ ███████╗███████╗███████╗███████╗ ██████╗ ██████╗ ██╗██╗██╗██╗██╗██╗
██╔══██╗██╔══██╗██╔═══██╗██╔════╝██╔════╝██╔════╝██╔════╝██╔═══██╗██╔══██╗██║██║██║██║██║██║
██████╔╝██████╔╝██║   ██║█████╗  █████╗  ███████╗███████╗██║   ██║██████╔╝██║██║██║██║██║██║
██╔═══╝ ██╔══██╗██║   ██║██╔══╝  ██╔══╝  ╚════██║╚════██║██║   ██║██╔══██╗╚═╝╚═╝╚═╝╚═╝╚═╝╚═╝
██║     ██║  ██║╚██████╔╝██║     ███████╗███████║███████║╚██████╔╝██║  ██║██╗██╗██╗██╗██╗██╗
╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚══════╝╚══════╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝╚═╝╚═╝╚═╝╚═╝
                                                                                            

EOF

sleep 18
# === DONE ===
echo "✅ Setup complete!"
sleep 2 
echo "• Press Prefix(ctrl+space)+I inside tmux to install plugins via TPM"
echo "🔚 All done! Please open a new terminal window (or run 'exec \$SHELL') to finalize."

sleep 4

clear
cat <<EOF
██████╗ ██╗   ██╗███████╗    ██████╗  █████╗ ██████╗ ██╗   ██╗    ██╗██╗██╗
██╔══██╗╚██╗ ██╔╝██╔════╝    ██╔══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ██║██║██║
██████╔╝ ╚████╔╝ █████╗      ██████╔╝███████║██████╔╝ ╚████╔╝     ██║██║██║
██╔══██╗  ╚██╔╝  ██╔══╝      ██╔══██╗██╔══██║██╔══██╗  ╚██╔╝      ╚═╝╚═╝╚═╝
██████╔╝   ██║   ███████╗    ██████╔╝██║  ██║██████╔╝   ██║       ██╗██╗██╗
╚═════╝    ╚═╝   ╚══════╝    ╚═════╝ ╚═╝  ╚═╝╚═════╝    ╚═╝       ╚═╝╚═╝╚═╝
███╗   ███╗██╗███████╗███████╗    ██╗   ██╗ ██████╗ ██╗   ██╗    ██╗██╗██╗ 
████╗ ████║██║██╔════╝██╔════╝    ╚██╗ ██╔╝██╔═══██╗██║   ██║    ██║██║██║ 
██╔████╔██║██║███████╗███████╗     ╚████╔╝ ██║   ██║██║   ██║    ██║██║██║ 
██║╚██╔╝██║██║╚════██║╚════██║      ╚██╔╝  ██║   ██║██║   ██║    ╚═╝╚═╝╚═╝ 
██║ ╚═╝ ██║██║███████║███████║       ██║   ╚██████╔╝╚██████╔╝    ██╗██╗██╗ 
╚═╝     ╚═╝╚═╝╚══════╝╚══════╝       ╚═╝    ╚═════╝  ╚═════╝     ╚═╝╚═╝╚═╝ 
███████╗ ██████╗     ███╗   ███╗██╗   ██╗ ██████╗██╗  ██╗    ██╗██╗██╗     
██╔════╝██╔═══██╗    ████╗ ████║██║   ██║██╔════╝██║  ██║    ██║██║██║     
███████╗██║   ██║    ██╔████╔██║██║   ██║██║     ███████║    ██║██║██║     
╚════██║██║   ██║    ██║╚██╔╝██║██║   ██║██║     ██╔══██║    ╚═╝╚═╝╚═╝     
███████║╚██████╔╝    ██║ ╚═╝ ██║╚██████╔╝╚██████╗██║  ██║    ██╗██╗██╗     
╚══════╝ ╚═════╝     ╚═╝     ╚═╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝    ╚═╝╚═╝╚═╝     
██╗      ██████╗ ██╗   ██╗███████╗    ██╗   ██╗ ██████╗ ██╗   ██╗██╗██╗██╗ 
██║     ██╔═══██╗██║   ██║██╔════╝    ╚██╗ ██╔╝██╔═══██╗██║   ██║██║██║██║ 
██║     ██║   ██║██║   ██║█████╗       ╚████╔╝ ██║   ██║██║   ██║██║██║██║ 
██║     ██║   ██║╚██╗ ██╔╝██╔══╝        ╚██╔╝  ██║   ██║██║   ██║╚═╝╚═╝╚═╝ 
███████╗╚██████╔╝ ╚████╔╝ ███████╗       ██║   ╚██████╔╝╚██████╔╝██╗██╗██╗ 
╚══════╝ ╚═════╝   ╚═══╝  ╚══════╝       ╚═╝    ╚═════╝  ╚═════╝ ╚═╝╚═╝╚═╝ 
                                                                        
EOF
sleep 16
echo "bye"
sleep 2
