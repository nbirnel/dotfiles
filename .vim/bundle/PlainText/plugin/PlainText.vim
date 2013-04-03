function! PlainText()
    silent new
    let s:help ="]s and [s to go to mispelled or unusual word.\n
  \]S and [S to go to mispelled word.\]S and [S to go to mispelled word.\n
  \z= to request corrections\z= to request corrections\n
  \zg to add to dictionary, zug to undo\zg to add to dictionary, zug to undo\n
  \zw to mark as incorrect'\zw to mark as incorrect"

    setlocal statusline=Spelling\ Help
    setlocal nospell
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    wincmd J
    resize 6
    silent 0put =s:help

    wincmd k
    syntax off
    setlocal textwidth=78
    setlocal filetype=text
    filetype indent off
    setlocal noautoindent
    setlocal nosmartindent
    setlocal spell spelllang=en_us
    setlocal spellfile=teris.add
endfunction
