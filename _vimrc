call plug#begin('~/.vim/plugged')

Plug 'nanotech/jellybeans.vim'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'kaicataldo/material.vim'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf',  { 'dir': '~/.fzf' }
Plug 'junegunn/fzf.vim'
Plug 'davidhalter/jedi-vim'
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'carpetsmoker/confirm_quit.vim'
Plug 'tpope/vim-fugitive'

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

if has('nvim')
endif

call plug#end()


if has("gui_running")
  set guioptions-=T "remove toolbar
  set guioptions-=l "remove left-hand scrollbar
  set guioptions-=L "remove left-hand scrollbar for split window
  set guioptions-=r "remove right-hand scrollbar
  set guioptions-=R "remove right-hand scrollbar for split window
endif

set background=dark
colorscheme material 
set t_Co=256
set guifont=DejaVuSansMono_NF:h12:cEASTEUROPE:qDRAFT


set number 
set pumheight=10

set encoding=utf-8

set history=999
set undolevels=999

set nowrap

set hlsearch
set incsearch
set ignorecase
set smartcase

set clipboard=unnamed "use system clipboard

set splitbelow
set splitright


nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

map <C-n> :NERDTreeToggle<CR>
map <S-F1>n :NERDTreeFind<CR>

map <C-P> :FZF<CR>

let g:confirm_quit_nomap = 0
let g:python_highlight_all = 1
let NERDTreeIgnore=['\.pyc$', '\~$', '\.DS_Store$', '__pycache__'] "ignore files in NERDTree
let g:deoplete#enable_at_startup = 1
