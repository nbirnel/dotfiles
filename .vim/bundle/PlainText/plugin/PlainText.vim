function! HelpText()
    silent new
    let s:help ="]s and [s to go to mispelled or unusual word.\n
  \]S and [S to go to mispelled word.\]S and [S to go to mispelled word.\n
  \z= to request corrections\z= to request corrections\n
  \zg to add to dictionary, zug to undo\zg to add to dictionary, zug to undo\n
  \zw to mark as incorrect'\zw to mark as incorrect"

    set nospell

    setlocal statusline=Spelling\ Help
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    wincmd J
    resize 6
    silent 0put =s:help

    wincmd k
    call PlainText()
endfunction

function! PlainText()
    syntax off
    setlocal textwidth=78
    setlocal filetype=text
    filetype indent off
    setlocal noautoindent
    setlocal nosmartindent
    setlocal spelllang=en_us
endfunction

function! SQLText()
    call PlainText()
    setlocal textwidth=256
    setlocal colorcolumn=257
endfunction
