" autoselect (ie clipboard support) for visual and modeless
" use console dialogs instead of popup dialogs for simple choices.
set guioptions=aAc

                                 " \eg edit gvimrc 
                                 " \sg source gvimrc 
nnoremap <silent> <leader>eg :edit $MYGVIMRC<cr>
nnoremap <silent> <leader>sg :source $MYGVIMRC<cr>

" instead of whatever that horrid default stuff is
set guifont=DejaVu_Sans_Mono:h11:cDEFAULT
" This has nothing to do with vim
" http://directory.google.com/Top/Computers/Software/Operating_Systems/Unix/Win32/

