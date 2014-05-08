
if exists("b:did_ftplugin")
  finish
endif

" Allow lines of unlimited length. Do NOT want automatic linebreaks,
" as a newline starts a new paragraph in FlexWiki.
setlocal textwidth=0
" Wrap long lines, rather than using horizontal scrolling.
setlocal wrap
" Wrap at a character in 'breakat' rather than at last char on screen
" text: *http://foo.bar.com/*
setlocal linebreak

if exists("g:flexwiki_maps")
  " Move up and down by display lines, to account for screen wrapping
  " of very long lines
  nmap <buffer> <Up>   gk
  nmap <buffer> k      gk
  vmap <buffer> <Up>   gk
  vmap <buffer> k      gk

  nmap <buffer> <Down> gj
  nmap <buffer> j      gj
  vmap <buffer> <Down> gj
  vmap <buffer> j      gj

  " for earlier versions - for when 'wrap' is set
  imap <buffer> <S-Down>   <C-o>gj
  imap <buffer> <S-Up>     <C-o>gk
  if v:version >= 700
      imap <buffer> <Down>   <C-o>gj
      imap <buffer> <Up>     <C-o>gk
  endif
endif
