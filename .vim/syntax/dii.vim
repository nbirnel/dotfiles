" Vim syntax file
" Language:	Summation dii loadfile
" Version Info: @(#)dii.vim 0.1 2013/04/08 16:06:30
" Author:       Noah Birnel <nbirnel@teris.com>
" Maintainer:   Noah Birnel <nbirnel@teris.com>
" Version Info: Mon, 04 Apr 2013 16:06:30 +1000

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" shut case off
syntax case ignore

syntax match diiComment /^;.*/

syntax match diiRecordNum /^; Record [0-9][0-9]*/
hi default diiRecordNum ctermfg=DarkRed guifg=white guibg=DarkRed 

syntax match diiToken /^@[^ ]*/
hi default diiToken ctermfg=LightYellow guifg=white guibg=LightYellow 

syntax match diiC /^@C [^ ]*/
hi default diiC ctermfg=DarkYellow guifg=white guibg=DarkYellow 

syntax match diiMedia /^@MEDIA .*/
syntax match diiEdoc /^@EDOC/
syntax match diiEmail /^@EMAIL/
syntax match diiAttachment /^@ATTACHMENT/
hi link diiMedia diiMediaType
hi link diiEdoc diiMediaType
hi link diiEmail diiMediaType
hi link diiAttachment diiMediaType
hi default diiMediaType ctermfg=DarkCyan guifg=white guibg=DarkCyan 
 

syn match diiT /^@T /
hi default  diiT ctermfg=LightBlue guifg=white guibg=LightBlue

syn match diiD /^@D /
hi default diiD ctermfg=DarkMagenta guifg=white guibg=DarkMagenta 

syn match diiI /@I/
hi default diiI ctermfg=DarkGreen guifg=white guibg=DarkGreen 

syn match diiBatesBeg /^@BATESBEG / 
hi default diiBatesBeg ctermfg=LightGreen guifg=White guibg=LightGreen

syn match diiBatesEnd /^@BATESEND / 
hi default diiBatesEnd ctermfg=LightGreen guifg=White guibg=LightGreen


if version >= 508 || !exists("did_dii_syn_inits")
  if version < 508
    let did_dii_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink diiComment     Comment
  HiLink diiFunction     Function

  HiLink diiDelimiter   Delimiter

  delcommand HiLink
endif

" b: local to current buffer
let b:current_syntax = "dii"
