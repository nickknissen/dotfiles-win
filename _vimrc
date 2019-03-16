call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'kaicataldo/material.vim'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf',  { 'dir': '~/.fzf' }
Plug 'junegunn/fzf.vim'

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
set guifont=Inconsolata:h12


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
