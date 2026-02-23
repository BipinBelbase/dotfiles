#!/usr/bin/env sh
set -eu

PACK_ROOT="${HOME}/.vim/pack/user/start"
mkdir -p "${PACK_ROOT}"

clone_or_update() {
  repo="$1"
  dest="$2"

  if [ -d "${dest}/.git" ]; then
    git -C "${dest}" pull --ff-only
  else
    git clone --depth=1 "${repo}" "${dest}"
  fi
}

clone_or_update "https://github.com/junegunn/fzf.git" "${PACK_ROOT}/fzf"
if [ -x "${PACK_ROOT}/fzf/install" ]; then
  "${PACK_ROOT}/fzf/install" --bin
fi
clone_or_update "https://github.com/junegunn/fzf.vim.git" "${PACK_ROOT}/fzf.vim"

if [ -d "${PACK_ROOT}/coc.nvim/.git" ]; then
  git -C "${PACK_ROOT}/coc.nvim" fetch --depth=1 origin release
  git -C "${PACK_ROOT}/coc.nvim" checkout release
  git -C "${PACK_ROOT}/coc.nvim" pull --ff-only origin release
else
  git clone --depth=1 --branch release "https://github.com/neoclide/coc.nvim.git" "${PACK_ROOT}/coc.nvim"
fi

clone_or_update "https://github.com/sheerun/vim-polyglot.git" "${PACK_ROOT}/vim-polyglot"
clone_or_update "https://github.com/airblade/vim-gitgutter.git" "${PACK_ROOT}/vim-gitgutter"
clone_or_update "https://github.com/mbbill/undotree.git" "${PACK_ROOT}/undotree"
clone_or_update "https://github.com/jiangmiao/auto-pairs.git" "${PACK_ROOT}/auto-pairs"
clone_or_update "https://github.com/tpope/vim-commentary.git" "${PACK_ROOT}/vim-commentary"
clone_or_update "https://github.com/vim-airline/vim-airline.git" "${PACK_ROOT}/vim-airline"
clone_or_update "https://github.com/vim-airline/vim-airline-themes.git" "${PACK_ROOT}/vim-airline-themes"
clone_or_update "https://github.com/ghifarit53/tokyonight-vim.git" "${PACK_ROOT}/tokyonight-vim"

if [ "${ENABLE_DADBOD:-0}" = "1" ]; then
  clone_or_update "https://github.com/tpope/vim-dadbod.git" "${PACK_ROOT}/vim-dadbod"
  clone_or_update "https://github.com/kristijanhusak/vim-dadbod-ui.git" "${PACK_ROOT}/vim-dadbod-ui"
  clone_or_update "https://github.com/kristijanhusak/vim-dadbod-completion.git" "${PACK_ROOT}/vim-dadbod-completion"
fi

echo "Native packages installed/updated in ${PACK_ROOT}."
echo "Restart Vim."
