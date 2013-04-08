"" GENERAL
set nocompatible                 " no vi junk - keep this first!
let vimrc_version = '0.03'
let machinefile = $HOME . '/.config/vim/machines/' . hostname() . '.vim'

if has("win32")
    set runtimepath+=~/.vim      " stupid hack to get autoload in windows
else
                                 ":Man wget, or \K over WORD. *Nix only.
    runtime! ftplugin/man.vim    
endif

set modeline                     " set secure at end

set encoding=utf-8               " because we're modern
setglobal fileencoding=utf-8     " ...
set nobomb                       " do not write utf-8 BOM!
set fileencodings=ucs-bom,utf-8,iso-8859-1
                                 " order to detect Unicodeyness

"" VIM MANAGEMENT
                                 " use pathogen for .vim package management:
                                 " cd ~/.vim/bundle
                                 " git clone git://github.com/thing/plugin.git
                                 " :Helptags
call pathogen#infect() 

                                 " \ev edit vimrc 
nnoremap <silent> <leader>ev :edit $MYVIMRC<cr>
                                 " \sv source vimrc
nnoremap <silent> <leader>sv :source $MYVIMRC<cr>
nnoremap <silent> <leader>em :exe 'edit ' machinefile <cr>
nnoremap <silent> <leader>sm :exe 'source ' machinefile <cr>

                                 " viminfo:
                                 " max 100 files remembered,
                                 " 50 lines of register,
                                 " skip >10Kbyte registers,
                                 " disable hlsearch,
set viminfo='100,<50,s10,h

"" DISPLAY
set scrolloff=1                  " keep a few lines of context when scrolling

set relativenumber               " show line numbers relative to .
set cursorline                   " and hightlight the current line

set showmatch                    "flash matching braces
set matchtime=5                  " how many tenths of a second to blink 

set colorcolumn=80               " visual notice when my lines are too long
set nowrap                       " one line per line
set showbreak=↳\                 " shown at the start of a wrapped line

syntax on                        " syntax highlighting on
colorscheme darkblue             " default - to be reset in machinefile

set lazyredraw                   " don't show magic whilst executing macros.

"" STATUS LINE
set cmdwinheight=20              " plenty of space of command-line window
set showmode                     " what mode am I in?
set showcmd                      " show the command being typed 

set laststatus=2                 " always show the status line 

set statusline=%<                " truncate here if too long
set statusline+=buf%n\           " buffer number
set statusline+=%F\              " full path
set statusline+=%h               " help flag
set statusline+=%m               " modified flag
set statusline+=%w               " preview flag
set statusline+=%r               " readonly flag
set statusline+=%y               " filetype in buffer
set statusline+=%=               " everything after this on the right
set statusline+=B\ %b\|0x%B\     " value|hex of byte under cursor
set statusline+=C\ %c\|%v\       " column|virtual column
set statusline+=L\ %l\/%L\       " line
set statusline+=(%p%%)           " percentage in to file

"" VIMDIFF
                                 " filler lines to keep side by side in sync
                                 " vertical split
set diffopt=filler,vertical

"" NAVIGATION
                                 " g% to toggle between the last two tabs
map g% :exe "tabn ".g:ltv<CR>
function! Setlasttabpagevisited()
    let g:ltv = tabpagenr()
endfunction

set matchpairs+=<:>              " angle brackets bounced with %

" INDENT
set autoindent                   " copy indent from current line
set smartindent                  " indent after {, cinwords, before }
                                 " except comment to beginning of line crap:
                                 " type an X, rub it out, then type an #
inoremap # X#

set tabstop=4                    " number of spaces for tab
set shiftwidth=4                 " number of spaces for autoindent
set expandtab                    " no real tabs please!

"" WINDOWS
                                 " \w vertical split and jump to the right 
nnoremap <leader>w <C-w>v<C-w>l

"" MS WINDOWS
if has("gui_win32")
                                 " windows crap - get rid of CUA cut emulation
    silent vunmap 
endif

"" MISC
                                 " multi-key strokes don't timeout,
                                 " but we should only need to press ESC once
set ttimeout
set notimeout

                                 " see help displayed next to editing buffer
nnoremap <leader>h :vert help     

set history=10000                " memory is cheap
set undolevels=10000             " memory is cheap

                                 " Rename our terminal for gui scripting. Sigh.
auto BufEnter * let &titlestring = "VIM - " . expand("%F")
set title titlestring=VIM\ \-\ %F

"" GREP
                                 "\g quietly grep recursively for cWORD,
                                 "open quickfix window on it.
                                 "FIXME add nonrecursive.
                                 "FIXME this is busted by grep-operator plugin
nnoremap <leader>g :silent execute "grep! -R " . shellescape(expand("<cWORD>")). " ."<cr>:copen<cr>

"" FILES
filetype on                      " try to figure out filetype
filetype plugin on               " attempt to load appropriate plugin
filetype indent on               " attempt to load appropriate indent plugin

set autochdir                    " always switch to the current file directory 

set hidden                       " allow hiding unwritten buffers

set backup                       " make backup files
set directory=~/.vim/tmp         " directory to place swap files in
set backupdir=~/.vim/backup      " where to put backup files
set undofile                     " keep an undo file even after closing
set undodir=~/.vim/undo          " where to put undo files

                                 " save every time the window loses focus
autocmd FocusLost * :bufdo call s:WriteFileBuffers()

function! s:WriteFileBuffers()
    if len(expand("%")) > 0  
       write
    endif
endfunction

"" SEARCH 
set hlsearch                     " highlight searches
                                 " \space clears out search highlighting
nnoremap <silent> <leader><space> :nohlsearch<cr>
set incsearch                    " show search matches while typing
set ignorecase                   " ignore case while searching, unless...
set smartcase                    " the search has any upper case

"" EDIT
set backspace=indent,eol,start   " make backspace a more flexible
set iskeyword+=_                 " none of these are word dividers

set nrformats=alpha              " stop the madness of <C-a> octal incrementing

set mouse=a                      " use mouse everywhere

                                 " add a blank line and return to normal mode
                                 " from
"http://www.terminally-incoherent.com/blog/2012/04/02/nifty-vim-tricks/
nnoremap <leader>o o<esc>
nnoremap <leader>O O<esc>
                                 " titlecap current line or selection
nnoremap <leader>t :s/\<\(\w\)\(\w*\)\>/\u\1\L\2/g<CR>
vnoremap <leader>t :s/\%V\(\w\)\(\w*\)\%V/\u\1\L\2/g<CR>

                                 " wrap current word in quotes, braces, etc
nnoremap <leader>i" viw<esc>a"<esc>hbi"<esc>lel
nnoremap <leader>i' viw<esc>a'<esc>hbi'<esc>lel
nnoremap <leader>i` viw<esc>a`<esc>hbi`<esc>lel
nnoremap <leader>i% viw<esc>a%<esc>hbi%<esc>lel
nnoremap <leader>i< viw<esc>a><esc>hbi<<esc>lel
nnoremap <leader>i( viw<esc>a)<esc>hbi(<esc>lel
nnoremap <leader>i[ viw<esc>a]<esc>hbi[<esc>lel
nnoremap <leader>i{ viw<esc>a}<esc>hbi{<esc>lel

                                 " wrap selected text in quotes, braces, etc
vnoremap <leader>i" <esc>a"<esc>`<i"<esc>`>l
vnoremap <leader>i' <esc>a'<esc>`<i'<esc>`>l
vnoremap <leader>i` <esc>a`<esc>`<i`<esc>`>l
vnoremap <leader>i% <esc>a%<esc>`<i%<esc>`>l
vnoremap <leader>i< <esc>a><esc>`<i<<esc>`>l
vnoremap <leader>i( <esc>a)<esc>`<i(<esc>`>l
vnoremap <leader>i[ <esc>a]<esc>`<i[<esc>`>l
vnoremap <leader>i{ <esc>a}<esc>`<i{<esc>`>l

"" TEXT-OBJECTS
                                 "in( = in next parens
                                 "il( = in last parens
onoremap in" :<c-u>normal! f"vi"<cr>
onoremap il" :<c-u>normal! F"vi"<cr>
onoremap in' :<c-u>normal! f'vi'<cr>
onoremap il' :<c-u>normal! F'vi'<cr>
onoremap in` :<c-u>normal! f`vi`<cr>
onoremap il` :<c-u>normal! F`vi`<cr>
onoremap in% :<c-u>normal! fl%vt%<cr>
onoremap il% :<c-u>normal! Fh%vT%<cr>

onoremap in< :<c-u>normal! f<vi<<cr>
onoremap il< :<c-u>normal! F>vi<<cr>
onoremap in( :<c-u>normal! f(vi(<cr>
onoremap il( :<c-u>normal! F)vi(<cr>
onoremap in[ :<c-u>normal! f[vi[<cr>
onoremap il[ :<c-u>normal! F]vi[<cr>
onoremap in{ :<c-u>normal! f{vi{<cr>
onoremap il{ :<c-u>normal! F}vi{<cr>


"" FILETYPES
                                 " vim help needs help
augroup filetype_vimhelp
    autocmd!
    autocmd FileType help setlocal iskeyword+=-
augroup END

                                 " vim scripts need help
augroup filetype_vimscript
    autocmd!
    autocmd FileType vim setlocal iskeyword+=#
augroup END

                                 " makefile syntax sucks
augroup filetype_make
    autocmd!
    autocmd FileType make setlocal noexpandtab
augroup END

                                 " Concordance dat files
autocmd BufNewFile,BufRead *.dat setf dat 
augroup filetype_dat
    autocmd!
    autocmd FileType dat setlocal iskeyword+=þ "  thorn is word divider
augroup END

                                 " Summation dii files
autocmd BufNewFile,BufRead *.dii setf dii 

                                 " Ipro lfp files
autocmd BufNewFile,BufRead *.lfp setf lfp 

                                 " kCura import & export files
autocmd BufNewFile,BufRead *.kwe setf xml 
autocmd BufNewFile,BufRead *.kwx setf xml 

                                 " textpad syntax files
autocmd BufNewFile,BufRead *.syn setf ini 

                                 " halibut files
autocmd BufNewFile,BufRead *.but setf halibut 

                                 " AutoHotKey syntax
autocmd BufNewFile,BufRead *.ahk setf ahk 

"" SELECT
                                 " \v reselect text just pasted in
nnoremap <leader>v v`]

set virtualedit=block            " allow block selecting past end of line

                                 " Swaps selection with buffer
vnoremap <leader>x <Esc>`.``gvP``P

"" SUBSTITUTE

"" COMMAND-LINE
                                 " F5 to execute line under cursor and refresh
autocmd CmdwinEnter * nnoremap <buffer> <F5> <CR>q:
autocmd CmdwinEnter * inoremap <buffer> <F5> <CR>q:

set wildmenu                     " show a list for command-line completion

                                 " emacs mappings pulled from *emacs-keys* 
                                 " clobbers defaults. But those stink anyway.
                                 " start of line
cnoremap <C-A>		<Home>
                                 " back one character
cnoremap <C-B>		<Left>
                                 " delete character under cursor
cnoremap <C-D>		<Del>
                                 " end of line
cnoremap <C-E>		<End>
                                 " forward one character
cnoremap <C-F>		<Right>
                                 " recall newer command-line
cnoremap <C-N>		<Down>
                                 " recall previous (older) command-line
cnoremap <C-P>		<Up>
                                 " back one word
cnoremap <Esc><C-B>	<S-Left>
                                 " forward one word
cnoremap <Esc><C-F>	<S-Right>

"" PER-MACHINE SETTINGS
if filereadable(machinefile)
    exe 'source ' . machinefile
endif

"" WRAP-UP
set secure                       " important since we set modeline way above


