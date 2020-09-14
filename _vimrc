call plug#begin('~/.vim/plugged')

Plug 'nanotech/jellybeans.vim'
Plug 'scrooloose/nerdtree'
Plug 'kaicataldo/material.vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf',  { 'dir': '~/.fzf' }
Plug 'junegunn/fzf.vim'
Plug 'editorconfig/editorconfig-vim'

Plug 'davidhalter/jedi-vim'
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'tweekmonster/impsort.vim'
Plug 'ambv/black'

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'janko-m/vim-test'
Plug 'stephpy/vim-yaml'
Plug 'PProvost/vim-ps1'

Plug 'OmniSharp/omnisharp-vim'
Plug 'posva/vim-vue'
Plug 'isRuslan/vim-es6'
Plug 'mattn/emmet-vim'


"" Clojure stuff
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
let g:python3_host_prog='C:\Python38\python.exe'
endif

call plug#end()

set nocompatible 

" enable syntax and plugins
syntax on
syntax enable
filetype plugin on 



if has("gui_running")
  set guioptions-=T "remove toolbar
  set guioptions-=l "remove left-hand scrollbar
  set guioptions-=L "remove left-hand scrollbar for split window
  set guioptions-=r "remove right-hand scrollbar
  set guioptions-=R "remove right-hand scrollbar for split window
endif

set background=light
colorscheme PaperColor

set t_Co=256

if has('nvim')
else
  set guifont=DejaVuSansMono_NF:h12:cEASTEUROPE:qDRAFT
endif


set number 
set laststatus=2
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

set path+=**


set fileformat=unix


autocmd BufWritePre *.py ImpSort!
autocmd BufWritePre *.py Black 
autocmd FileType python set foldmethod=indent foldlevel=99
autocmd FileType arduino set foldmethod=indent foldlevel=99
autocmd FileType vue syntax sync fromstart

au BufNewFile,BufRead *.py
    \ set fileformat=unix

" add yaml stuffs
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap <leader>is :<c-u>ImpSort!<cr>

vnoremap // y/\V<C-r>=escape(@",'/\')<CR><CR>

map <C-n> :NERDTreeToggle<CR>
map <S-F1>n :NERDTreeFind<CR>

map <C-P> :GFiles<CR>
let mapleader = ","


call deoplete#custom#option({
	\ 'auto_complete_delay': 100,
	\ 'smart_case': v:true,
\ })


let g:deoplete#enable_at_startup = 1
let g:jedi#auto_initialization = 1
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#smart_auto_mappings = 0
let g:jedi#popup_on_dot = 0
let g:jedi#completions_command = ""
let g:jedi#show_call_signatures = "1"
let g:jedi#force_py_version =3


let g:confirm_quit_nomap = 0
let g:python_highlight_all = 1
let NERDTreeIgnore=['\.pyc$', '\~$', '\.DS_Store$', '__pycache__'] "ignore files in NERDTree
let test#python#runner = 'pytest'
