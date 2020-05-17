"           _     
"     _  __(_)_ _ 
"    | |/ / /  ' \
"    |___/_/_/_/_/
"                 
" =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=
" Preamble
" =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=

" Clear autocmds
autocmd!

" Leader
let mapleader = '\'

" =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=
" Functions
" =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=

" Insert tab at beginning of line, complete otherwise
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction

" =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=
" General
" =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=

" Prevent cursor from moving to sol when buffer switching
set nostartofline

" Select past eol in visual-block
set virtualedit=block

" Don't redraw for macros
set lazyredraw
set nottimeout

" Nice completion settings
set wildmenu
set wildmode=longest,full,list
set wildignore=*.o,*~,*.pyc,*.so
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=*.png,*.jpg,*.gif

" Allow hidden buffers
set hidden

" Switch to tab with buffer
set switchbuf=usetab,newtab

" Don't allow backups, swapfiles
set noswapfile
set nobackup

if has('persistent_undo')
    " Save undo history to file
    set undofile

    " Maximum number of undos
    set undolevels=10000

    " Save complete files for undo on reload if it has less lines than this
    set undoreload=10000

    " Save in a central location
    set undodir=~/.vim/tmp//,.
endif

" Shift char with C-A and C-X.
set nrformats=alpha

" Automatically switch cwd to file being edited
set autochdir

" Automatically reread buffers
set autoread

" Delete comment character when joining commented lines
if v:version > 703 || v:version == 703 && has("patch541")
    set formatoptions+=j
endif

" Swap and backup files
set backupdir=~/.vim/tmp//,.
set directory=~/.vim/tmp//,.

let g:custom_tab_completion = 1

" =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=
" Interface
" =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=

" Statusline
set statusline=%=
set statusline+=\ %f%h%m%r%w
set statusline+=\ ::\ %y\ ::\ %P\ ::\ %l\|%c\ 

" Show matching brackets
set showmatch

" ...for 2/10ths of a second
set mat=2

" Always show the statusline
set laststatus=1

" Syntax highlighting
syntax on

" Allow mouse usage
set mouse=a

" Relative line numbers, but show real number instead of 0
set relativenumber
set number

" Fold text with {{{,}}}
set foldmethod=marker

" Commandline options
set showcmd
set cmdheight=1

" Invisible chars
set listchars=tab:▸\ ,eol:¬,nbsp:_,trail:▋

" lines of 'buffer' to the window bottom
set so=16

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=
" Indentation
" =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=

" Enable backspace
set backspace=2

" Convert tabs to spaces for PEP8
set expandtab

" 4 spaces for a tab
set tabstop=4

" 4 spaces for indentation
set shiftwidth=4
set softtabstop=4

" Indent to nearest tabstop
set shiftround

" Automatically indent after certain cues
set autoindent

" =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=
" Searching
" =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=

" Move cursor to search result
set incsearch

" Highlight search result
set hlsearch

" Ignore case when searching
set ignorecase

" But don't when using uppercase letters
set smartcase

" Magic regex
set magic

" =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=
" Filetype specific settings
" =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=

" Proper shell syntax highlighting
let g:sh_no_error = 1

" Some file types use real tabs
au FileType {make,gitconfig} set noexpandtab sw=4

" Python
augroup python_stuff
    autocmd!
    autocmd FileType python setlocal colorcolumn=80
    autocmd FileType python setlocal completeopt-=preview
augroup END

" Markdown
augroup markdown
    autocmd!
    autocmd BufNewFile,BufReadPost *.md set filetype=markdown
augroup END

" Source rc on save
augroup vimrc
    autocmd!
    au BufWritePost .vimrc,init.vim :source %
augroup END

" =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=
" Keybindings
" =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=

" Useless keys
inoremap <F1> <nop>
nnoremap <F1> <nop>
nnoremap Q <nop>

" Save with sudo and reload
command! WW :execute ':silent w !sudo tee % > /dev/null' | :edit!

" Fat fingers
command! Wq :wq

" Insert tab at line start or autocomplete
if g:custom_tab_completion == 1
    inoremap <tab> <c-r>=InsertTabWrapper()<cr>
    inoremap <s-tab> <c-n>
endif

" Buffer movement
nnoremap <leader>]  :bnext<CR>
nnoremap <leader>[  :bprevious<CR>

" Line moving
nnoremap <leader><Up>   :<C-u>silent! move-2<CR>==
nnoremap <leader><Down> :<C-u>silent! move+<CR>==
xnoremap <leader><Up>   :<C-u>silent! '<,'>move-2<CR>gv=gv
xnoremap <leader><Down> :<C-u>silent! '<,'>move'>+<CR>gv=gv

" Open vimrc
nnoremap <leader>v :e ~/.vimrc<CR>

" Show invisible chars
nnoremap <leader>a :set list!<CR>

" Enable spell-checking
nmap <silent> <leader>c :set spell!<CR>

" Error movement
nnoremap [q :lprevious<CR>
nnoremap ]q :lnext<CR>
nnoremap [e :cprevious<CR>
nnoremap ]e :cnext<CR>

" Easier navigation in long lines
nnoremap <silent> j gj
nnoremap <silent> k gk

" Center screen when searching and moving
nnoremap n nzz
nnoremap N Nzz
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Make Y behave like other capitals
nnoremap Y y$

" Black hole
nnoremap X "_d

" Substitute current line with buffer content
nnoremap S "_ddP

" Easy line movement
noremap H ^
noremap L g_

" Quick q macro replay
nnoremap Q @q

" Break up undo sequence after every sentence
inoremap . .<c-g>u

" Clear search highlighting with enter
nnoremap <cr> :nohlsearch<cr>:<backspace>

