" Vim 8+ port of the nvim2.0 configuration.

scriptencoding utf-8

if &compatible
  set nocompatible
endif

let mapleader = ' '
let maplocalleader = '\'

set hidden
set shortmess-=I
if has('termguicolors')
  set termguicolors
endif
set noswapfile
if has('persistent_undo')
  set undofile
  let s:undo_dir = expand('~/.vim/undodir')
  if !isdirectory(s:undo_dir)
    call mkdir(s:undo_dir, 'p', 0700)
  endif
  let &undodir = s:undo_dir
endif
set timeoutlen=300
set updatetime=250
set scrolloff=4
set nowrap
set nocursorline
set number
set numberwidth=2
if exists('+signcolumn')
  set signcolumn=yes
endif
if exists('+foldcolumn')
  set foldcolumn=0
endif
set title
set titlestring=%t%(\ %M%)%(\ (%{expand('%:~:h')})%)%a\ (vim)
set formatoptions-=o
set splitbelow
set splitright
set ignorecase
set smartcase
set incsearch
set hlsearch
set mouse=a
set wildmode=longest:full,full
set completeopt=menuone,noinsert,noselect

if has('clipboard')
  set clipboard+=unnamedplus
endif

filetype plugin indent on
syntax enable
runtime! macros/matchit.vim

let g:enable_dadbod = get(g:, 'enable_dadbod', 0)

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 28
let g:netrw_keepdir = 0

if empty(glob('~/.vim/autoload/plug.vim'))
  if executable('curl')
    silent execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs ' .
          \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    augroup plug_bootstrap
      autocmd!
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    augroup END
  else
    echohl WarningMsg
    echom 'vim-plug is missing and curl is not available; install vim-plug manually.'
    echohl None
  endif
endif

if exists('*plug#begin')
  call plug#begin('~/.vim/plugged')
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'sheerun/vim-polyglot'
  Plug 'airblade/vim-gitgutter'
  Plug 'mbbill/undotree'
  Plug 'jiangmiao/auto-pairs'
  Plug 'tpope/vim-commentary'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'ghifarit53/tokyonight-vim'

  if g:enable_dadbod
    Plug 'tpope/vim-dadbod'
    Plug 'kristijanhusak/vim-dadbod-ui'
    Plug 'kristijanhusak/vim-dadbod-completion'
  endif
  call plug#end()
endif

let g:tokyonight_style = 'moon'
let g:airline_powerline_fonts = 1
let g:airline_theme = 'tokyonight'
let g:airline_left_sep = '|'
let g:airline_right_sep = '|'
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#coc#enabled = 1

let g:gitgutter_sign_added = '|'
let g:gitgutter_sign_modified = '|'
let g:gitgutter_sign_removed = '>'
let g:gitgutter_sign_removed_first_line = '>'
let g:gitgutter_sign_modified_removed = '|'

if g:enable_dadbod
  let g:db_ui_use_nerd_fonts = 1
endif

let g:coc_global_extensions = [
      \ 'coc-json',
      \ 'coc-tsserver',
      \ 'coc-pyright',
      \ 'coc-rust-analyzer',
      \ 'coc-lua',
      \ 'coc-eslint',
      \ 'coc-prettier',
      \ 'coc-sh',
      \ 'coc-yaml',
      \ 'coc-snippets'
      \ ]

silent! colorscheme tokyonight

if exists('*sign_define')
  call sign_define('CocErrorSign', {'text': 'E ', 'texthl': 'CocErrorSign'})
  call sign_define('CocWarningSign', {'text': 'W ', 'texthl': 'CocWarningSign'})
  call sign_define('CocInfoSign', {'text': 'I ', 'texthl': 'CocInfoSign'})
  call sign_define('CocHintSign', {'text': 'H ', 'texthl': 'CocHintSign'})
endif

function! CheckBackspace() abort
  let l:col = col('.') - 1
  return l:col <= 0 || getline('.')[l:col - 1] =~# '\s'
endfunction

function! s:DeleteOtherBuffers() abort
  let l:current = bufnr('%')
  for l:buf in getbufinfo({'buflisted': 1})
    if l:buf.bufnr != l:current
      execute 'bdelete' l:buf.bufnr
    endif
  endfor
endfunction

function! s:ToggleAutoformatGlobal() abort
  let g:autoformat_enabled = !get(g:, 'autoformat_enabled', 0)
  echom g:autoformat_enabled ? 'Auto format (global): on' : 'Auto format (global): off'
endfunction

function! s:ToggleAutoformatBuffer() abort
  let b:autoformat_enabled = !get(b:, 'autoformat_enabled', get(g:, 'autoformat_enabled', 0))
  echom b:autoformat_enabled ? 'Auto format (buffer): on' : 'Auto format (buffer): off'
endfunction

function! s:ShouldAutoformat() abort
  if exists('b:autoformat_enabled')
    return b:autoformat_enabled
  endif
  return get(g:, 'autoformat_enabled', 0)
endfunction

function! s:TmuxSessionizer() abort
  if empty($TMUX)
    echohl WarningMsg | echom 'Not inside a tmux session' | echohl None
    return
  endif

  if executable('tmux') == 0 || executable('tmux-sessionizer') == 0
    echohl WarningMsg | echom 'tmux or tmux-sessionizer is not available' | echohl None
    return
  endif

  if has('job')
    call job_start(['tmux', 'new-window', 'tmux-sessionizer'], {'detach': v:true})
  else
    silent execute '!tmux new-window tmux-sessionizer'
    redraw!
  endif
endfunction

augroup user_config
  autocmd!
  autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab
  autocmd BufWritePre * if <SID>ShouldAutoformat() | silent! call CocAction('format') | endif
augroup END

inoremap , ,<C-g>u
inoremap . .<C-g>u
inoremap ; ;<C-g>u

nnoremap <silent> <Esc> :nohlsearch<CR><Esc>
inoremap <silent> <C-s> <Esc>:update<CR>a
nnoremap <silent> <C-s> :update<CR>
xnoremap <silent> <C-s> <Esc>:update<CR>gv

nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
xnoremap J :m '>+1<CR>gv=gv
xnoremap K :m '<-2<CR>gv=gv

nnoremap <leader>d "_d
xnoremap <leader>d "_d
if has('clipboard')
  nnoremap <leader>y "+y
  xnoremap <leader>y "+y
  nnoremap <leader>Y "+Y
else
  nnoremap <leader>y y
  xnoremap <leader>y y
  nnoremap <leader>Y Y
endif
xnoremap <leader>p "_dP

nnoremap <leader>fr :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>
nnoremap Q <Nop>

nnoremap <silent> <leader>e :Lexplore<CR>
nnoremap <silent> <leader>E :Explore<CR>
nnoremap <silent> <C-f> :call <SID>TmuxSessionizer()<CR>

if has('unix')
  nnoremap <silent> <leader>fx :silent !chmod +x %<CR>:redraw!<CR>
endif

nnoremap <silent> <C-Up> :resize +2<CR>
nnoremap <silent> <C-Down> :resize -2<CR>
nnoremap <silent> <C-Left> :vertical resize -2<CR>
nnoremap <silent> <C-Right> :vertical resize +2<CR>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap H :bprevious<CR>
nnoremap L :bnext<CR>
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
nnoremap <leader>, :Buffers<CR>
nnoremap <leader>bb :buffer #<CR>
nnoremap <leader>bd :bdelete<CR>
nnoremap <leader>bo :call <SID>DeleteOtherBuffers()<CR>

nnoremap <leader>- :split<CR>
nnoremap <leader><bar> :vsplit<CR>
nnoremap <leader>wd :close<CR>

nnoremap <leader><Space> :Files<CR>
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fF :Files<CR>
nnoremap <leader>fg :GFiles<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>/ :Rg<Space>
nnoremap <leader>sg :Rg<Space>
nnoremap <leader>sw :Rg <C-r><C-w><CR>
xnoremap <leader>sw y:Rg <C-r>0<CR>
nnoremap <leader>s/ :History/<CR>
nnoremap <leader>sc :History:<CR>
nnoremap <leader>sh :Helptags<CR>
nnoremap <leader>sk :Maps<CR>
nnoremap <leader>so :Options<CR>
nnoremap <leader>sj :Jumps<CR>
nnoremap <leader>sm :Marks<CR>
nnoremap <leader>s" :Registers<CR>
nnoremap <leader>sl :lopen<CR>
nnoremap <leader>sq :copen<CR>

nnoremap <leader>cu :UndotreeToggle<CR>

nnoremap <leader>uf :call <SID>ToggleAutoformatGlobal()<CR>
nnoremap <leader>uF :call <SID>ToggleAutoformatBuffer()<CR>
nnoremap <leader>cm :CocList extensions<CR>
nmap <leader>cf <Plug>(coc-format-selected)
xmap <leader>cf <Plug>(coc-format-selected)
nmap <silent> gra <Plug>(coc-codeaction-cursor)
xmap <silent> gra <Plug>(coc-codeaction-selected)
nmap <silent> grn <Plug>(coc-rename)
nmap <silent> gri <Plug>(coc-implementation)
nmap <silent> grr <Plug>(coc-references)
nmap <silent> grt <Plug>(coc-type-definition)
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)
nnoremap <leader>cd :call CocActionAsync('diagnosticInfo')<CR>
nnoremap <leader>xx :CocList diagnostics<CR>
nnoremap <leader>xX :CocList diagnostics --current-buf<CR>
nnoremap <leader>xq :copen<CR>
nnoremap <leader>xQ :copen<CR>
nnoremap <leader>xl :lopen<CR>
nnoremap <leader>xL :lopen<CR>
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap <leader>cs :CocList -I symbols<CR>
nnoremap <leader>cS :CocList -I outline<CR>
nnoremap gO :CocList -I outline<CR>

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() :
      \ "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr> <S-TAB>
      \ coc#pum#visible() ? coc#pum#prev(1) :
      \ "\<C-h>"
imap <silent> <C-l> <Plug>(coc-snippets-expand-jump)
smap <silent> <C-l> <Plug>(coc-snippets-expand-jump)

nnoremap <leader>H <Nop>
nnoremap <leader>ha :call HarpoonAdd()<CR>
nnoremap <leader>hh :call HarpoonMenu()<CR>
nnoremap <leader>1 :call HarpoonSelect(1)<CR>
nnoremap <leader>2 :call HarpoonSelect(2)<CR>
nnoremap <leader>3 :call HarpoonSelect(3)<CR>
nnoremap <leader>4 :call HarpoonSelect(4)<CR>
nnoremap <leader>5 :call HarpoonSelect(5)<CR>
