" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Configure Vundle
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
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'Valloric/YouCompleteMe'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'vim-scripts/taglist.vim'
Plugin 'scrooloose/syntastic'
Plugin 'kien/ctrlp.vim'
Plugin 'nathanaelkane/vim-indent-guides'
"Plugin 'Yggdroot/indentLine'
Plugin 'nanotech/jellybeans.vim'
Plugin 'vim-scripts/xoria256.vim'
Plugin 'tomasr/molokai'
Plugin 'altercation/vim-colors-solarized'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
" set backspace=2

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set backupdir=~/.vim/backup,.,/tmp " set backup directory
set history=100		" keep 100 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set wrapscan		" search next jumps to the beginning of the file
set number		" show line numbers.
set smarttab       	  " When on, a <Tab> in front of a line inserts blanks
                    	" according to 'shiftwidth'. 'tabstop' is used in other
                     	" places. A <BS> will delete a 'shiftwidth' worth of 
                      " space at the start of the line.
set showmatch       	" When a bracket is inserted, briefly jump to the
                			" matching one. The jump is only done if the match can
			                " be seen on the screen. The time to show the match 
			                " can be set with 'matchtime'.
set ignorecase
set smartcase       	" Override the 'ignorecase' option if the search pattern
                    	" contains upper case characters.
"set spell 		  " spell checking, z= to view suggestions, EN
"set hidden
set wildmenu		" Enable enhanced command-line completion.
set vb	    		" set visual bell

" Make command line two lines high
set ch=2

" don't redisplay the line you are changing
set cpoptions+=$

" Set the status line the way I like it
set stl=%f\ %m\ %r\ Line:\ %l/%L[%p%%]\ Col:\ %c\ Buf:\ #%n\ [%b][0x%B]

" tell Vim to always put a status line in, even if there is only one
" window
set laststatus=2

" Hide the mouse pointer while typing
set mousehide

set guioptions=ac

" This is the timeout used while waiting for user input on a
" multi-keyed macro or while just sitting and waiting for another
" key to be pressed measured in milliseconds.
set timeoutlen=500

" These commands open folds
set foldopen=block,insert,jump,mark,percent,quickfix,search,tag,undo

" When the page starts to scroll, keep the cursor 8 lines from
" the top and 8 lines from the bottom
set scrolloff=8

" Allow the cursor to go in to 'invalid' places
"set virtualedit=all

" Tabstops are 4 spaces
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" Don't update the display while executing macros
set lazyredraw

" Show the current mode
set showmode

" Set up the gui cursor to look nice
set guicursor=n-v-c:block-Cursor-blinkon0,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor,r-cr:hor20-Cursor,sm:block-Cursor-blinkwait175-blinkoff150-blinkon175

" When completing by tag, show the whole tag, not just the function name
set showfulltag

" Set the textwidth to be 80 chars
set textwidth=80

" get rid of the silly characters in separators
set fillchars = ""

" Add ignorance of whitespace to diff
set diffopt+=iwhite

" Add the unnamed register to the clipboard
set clipboard+=unnamed

" Automatically read a file that has changed on disk
set autoread

set fdm=marker

" Edit the vimrc file
nmap <silent> \ev :e $MYVIMRC<cr>
nmap <silent> \sv :so $MYVIMRC<cr>

" Toggle paste mode
nmap <silent> \p :set invpaste<CR>:set paste?<CR>

" Turn off that stupid highlight search
nmap <silent> ,n :nohls<CR>

" Set text wrapping toggles
nmap <silent> \ww :set invwrap<CR>:set wrap?<CR>

" cd to the directory containing the file in the buffer
nmap <silent> \cd :lcd %:h<CR>

" Make the directory that contains the file in the current buffer.
" This is useful when you edit a file in a directory that doesn't
" (yet) exist
nmap <silent> \md :!mkdir -p %:p:h<CR>

" Make the current file executable
nmap \x :w<cr>:!chmod 755 %<cr>:e<cr>

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

au BufRead,BufNewFile *.des set syntax=levdes

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable EN spell checking for plain text files (*.txt)
  autocmd FileType plaintext setlocal spell spelllang=en_us

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else
  " always set autoindenting on
  set autoindent
" has("autocmd")
endif 

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has('gui_running')
  " Make shift-insert work like in Xterm
  map <S-Insert> <MiddleMouse>
  map! <S-Insert> <MiddleMouse>
endif

"-----------------------------------------------------------------------------
" NERD Tree Plugin Settings
"-----------------------------------------------------------------------------
" Toggle the NERD Tree on an off with F7
nmap <F7> :NERDTreeToggle<CR>

" Close the NERD Tree with Shift-F7
nmap <S-F7> :NERDTreeClose<CR>

" Show the bookmarks table on startup
let NERDTreeShowBookmarks=1

"-----------------------------------------------------------------------------
" jellybeans
"-----------------------------------------------------------------------------
"let g:jellybeans_use_lowcolor_black = 0
let g:jellybeans_overrides = {
\    'Todo': { 'guifg': '303030', 'guibg': 'f0f000',
\              'ctermfg': 'Black', 'ctermbg': 'Yellow',
\              'attr': 'bold' },
\}

"-----------------------------------------------------------------------------
" solarized
"-----------------------------------------------------------------------------
call togglebg#map("<S-F5>")

"-----------------------------------------------------------------------------
" vim-airline
"-----------------------------------------------------------------------------
let g:airline#extensions#tabline#enabled = 1
if has("gui_running")
  let g:airline_powerline_fonts = 1
else
  " unicode symbols
  let g:airline_left_sep = '▶'
  let g:airline_right_sep = '◀'
endif
let g:airline_theme = 'jellybeans'
"if !exists('g:airline_symbols')
"  let g:airline_symbols = {}
"endif
"let g:airline_symbols.space = "\ua0"

"-----------------------------------------------------------------------------
" YouCompleteMe
"-----------------------------------------------------------------------------
let g:ycm_autoclose_preview_window_after_completion=1

" set here the proper pythonn version
"let g:ycm_python_binary_path = '/usr/bin/python2'
let g:ycm_python_binary_path = '/usr/bin/python'

"-----------------------------------------------------------------------------
" taglist.vim
"-----------------------------------------------------------------------------
nmap <F3> :TlistToggle<CR>
let Tlist_Use_Right_Window = 1

"-----------------------------------------------------------------------------
" syntastic
"-----------------------------------------------------------------------------
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_enable_signs=1
let g:syntastic_loc_list_height=7
let g:syntastic_warning_symbol='⚠'
let g:syntastic_style_warning_symbol='⚠'
let g:syntastic_style_error_symbol='⚠'
let g:syntastic_error_symbol='✗'
" Ignore following errors:
" E501 - line too long
" E231 - missing whitespace after ','
" E203 - whitespace before ':'
" E225 - missing whitespace around separator
" E261 - at least two spaces before inline comment
" E226 - missing whitespace around arithmethic operator
" E302 - expected 2 blank lines, found 1
" E128 - continuation line under-indented for visual indent
"let g:syntastic_python_flake8_args='--ignore="E501,E231,E203,E225,E261,E226,E302,E128"'
nmap <F5> :lopen<CR>
nmap <F6> :lclose<CR>
nmap [s :lprev<CR>
nmap ]s :lnext<CR>

" set here the proper python version
"let g:syntastic_python_python_exec = '/usr/bin/python2'
let g:syntastic_python_python_exec = '/usr/bin/python'

"-----------------------------------------------------------------------------
" Set up the window colors and size
"-----------------------------------------------------------------------------
if has("gui_running")
  "set background=light
  "colorscheme solarized
  colorscheme jellybeans
  set guifont=Input\ Mono\ Narrow\ Semi-Condensed\ 10
"  if !exists("g:vimrcloaded")
"      "winpos 0 0
"      if !&diff
"          winsize 80 24
"      else
"          winsize 165 24
"      endif
"      let g:vimrcloaded = 1
"  endif
else
  colorscheme jellybeans
endif
:nohls
