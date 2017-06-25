set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
" Color themes
Plugin 'chriskempson/base16-vim'
Bundle 'klen/python-mode'
"Plugin 'davidhalter/jedi-vim'
Plugin 'scrooloose/nerdtree'
Plugin 'rking/ag.vim'
Plugin 'fatih/vim-go'
Bundle 'jistr/vim-nerdtree-tabs'
Plugin 'airblade/vim-gitgutter'
Plugin 'ctrlp.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Bundle 'edkolev/tmuxline.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'rodjek/vim-puppet.git'
Plugin 'godlygeek/tabular.git'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" color scheme setup
set background=dark
" let base16colorspace=256
colorscheme molokai

set ignorecase
set hlsearch

" enable syntax highlighting
syntax enable
" show line numbers
set number
" set tabs to have 4 spaces
set ts=4
" indent when moving to the next line while writing code
set autoindent
" expand tabs into spaces
set expandtab
" when using the >> or << commands, shift lines by 4 spaces
set shiftwidth=4
" show a visual line under the cursor's current line
set cursorline
set incsearch " Search as typing
set hlsearch " Highlight search results
set scrolloff=10 " Always keep 10 lines after or before when scrolling
set showtabline=2 " Always show tabs
set ignorecase " Search insensitive
set smartcase " ... but smart
set showbreak=↪ " See this char when wrapping text
" show the matching part of the pair for [] {} and ()
set showmatch
set matchtime=3 " ... during this time
" always wrap
set wrap
" enable all Python syntax highlighting features
let python_highlight_all = 1

let g:NERDTreeIgnore=['.pyc$']

 """""""""""""""""""""""""""""""""""""Python-mode
 " Activate rope
 " Keys:
 " K             Show python docs
 " <Ctrl-Space>  Rope autocomplete
 " <Ctrl-c>g     Rope goto definition
 " <Ctrl-c>d     Rope show documentation
 " <Ctrl-c>f     Rope find occurrences
 " <Leader>b     Set, unset breakpoint (g:pymode_breakpoint enabled)
 " [[            Jump on previous class or function (normal, visual, operator modes)
 " ]]            Jump on next class or function (normal, visual, operator modes)
 " [M            Jump on previous class or method (normal, visual, operator modes)
 " ]M            Jump on next class or method (normal, visual, operator modes)
 let g:pymode_rope = 0

 " Documentation
 let g:pymode_doc = 1
 let g:pymode_doc_key = 'K'

 "Linting
 let g:pymode_lint = 1
 let g:pymode_lint_checker = "pyflakes,pep8"
 " Auto check on save
 let g:pymode_lint_write = 1

 " Support virtualenv
 let g:pymode_virtualenv = 1

 " Enable breakpoints plugin
 let g:pymode_breakpoint = 1
 let g:pymode_breakpoint_bind = '<leader>b'

 " syntax highlighting
 let g:pymode_syntax = 1
 let g:pymode_syntax_all = 1
 let g:pymode_syntax_indent_errors = g:pymode_syntax_all

 " Don't autofold code
 let g:pymode_syntax_space_errors = g:pymode_syntax_all
 let g:pymode_folding = 0


" set line length to 120 char and tweak pycheck accordingly
 autocmd FileType python set colorcolumn=120
 let g:pymode_options_max_line_length = 120
 let g:pymode_breakpoint_cmd = 'import ipdb; ipdb.set_trace()  # FIXME breakpoint'

 """"""""""""""""""""""""""" vim airline
 set laststatus=2
 let g:airline#extensions#tabline#enabled = 1
 let g:airline_theme= 'murmur'
 let g:airline_powerline_fonts=1
 let g:airline#extensions#tmuxline#enabled = 0

 let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'

""""""" vim-go
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:syntastic_go_checkers = ['go', 'golint', 'errcheck']

""""""" vim-puppet
" detect puppet filetype
autocmd BufRead,BufNewFile *.pp set filetype=puppet
autocmd BufRead,BufNewFile *.pp setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab smarttab

" :W - To write with root rights
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!

""""""" SHORTCUTS
map <F2> :NERDTreeTabsToggle<CR>
autocmd BufWritePre <buffer> :%s/\s\+$//e  " Remove trailing spaces at save
autocmd BufWritePost,FileWritePost *.go execute 'GoLint' | cwindow
