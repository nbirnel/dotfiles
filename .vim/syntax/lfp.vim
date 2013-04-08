" Vim syntax file
" Language:	Load File Protocol (.lfp) for Ipro, kCura Relativity, etc
" Version Info: @(#)lfp.vim 0.1 2012/07/28 10:41:42
" Author:       Noah Birnel <nbirnel@teris.com>
" Maintainer:   Noah Birnel <nbirnel@teris.com>
" Version Info: Sat, 28 Jul 2012 10:41:42 +1000

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" shut case off
syntax case ignore

"syntax keyword lfpFunction im vn io is bf in lc of oi ot rS rt sr vf rp br ck da dt fn ft ia rr
syntax match lfpComment /^##.*/
" syntax match lfpField /[^,;]\+/
syntax match lfpDelimiter /[,;]/

" syn region done start=/\*\*DONE/ end=/\*\*/ 

syn match lfpIM /^im/
hi default  lfpIM ctermfg=LightBlue guifg=white guibg=LightBlue

syn match lfpVN /^vn/
hi default lfpVN ctermfg=DarkRed guifg=white guibg=DarkRed 

syn match lfpBF /^bf/
hi default lfpBF ctermfg=DarkGreen guifg=white guibg=DarkGreen 

syn match lfpBM /^bm/ 
hi default lfpBM ctermfg=DarkGreen guifg=White guibg=DarkGreen

syn match lfpIN /^in/
hi default lfpIN ctermfg=DarkBlue guifg=white guibg=DarkBlue 

syn match lfpLC /^lc/
hi default lfpLC ctermfg=LightBlue guifg=white guibg=LightBlue 

syn match lfpIA /^ia/
hi default lfpIA ctermfg=LightYellow guifg=white guibg=LightYellow 

syn match lfpIO /^io/
hi default lfpIO ctermfg=LightYellow guifg=white guibg=LightYellow 

syn match lfpIS /^is/
hi default lfpIS ctermfg=LightYellow guifg=white guibg=LightYellow 

syn match lfpOF /^of/
hi default lfpOF ctermfg=DarkYellow guifg=white guibg=DarkYellow 

syn match lfpOI /^oi/
hi default lfpOI ctermfg=Brown guifg=white guibg=Brown 

syn match lfpOT /^ot/
hi default lfpOT ctermfg=DarkGreen guifg=white guibg=DarkGreen 

syn match lfpRS /^rs/
hi default lfpRS ctermfg=Magenta guifg=white guibg=Magenta 

syn match lfpRT /^rt/
hi default lfpRT ctermfg=LightRed guifg=white guibg=LightRed 

syn match lfpSR /^sr/
hi default lfpSR ctermfg=DarkGray guifg=white guibg=DarkGray 

syn match lfpVF /^vf/
hi default lfpVF ctermfg=DarkCyan guifg=white guibg=DarkCyan 

syn match lfpRP /^rp/
hi default lfpRP ctermfg=Cyan guifg=white guibg=Cyan 

syn match lfpBR /^br/
hi default lfpBR ctermfg=Black guifg=white guibg=Black 

syn match lfpCK /^ck/
hi default lfpCK ctermfg=DarkGreen guifg=white guibg=DarkGreen 

syn match lfpDA /^da/
hi default lfpDA ctermfg=LightMagenta guifg=white guibg=LightMagenta 

syn match lfpDT /^dt/
hi default lfpDT ctermfg=DarkMagenta guifg=white guibg=DarkMagenta 

syn match lfpFN /^fn/
hi default lfpFN ctermfg=LightGray guifg=white guibg=LightGray 

syn match lfpFT /^ft/
hi default lfpFT ctermfg=DarkGreen guifg=white guibg=DarkGreen 

syn match lfpRR /^rr.*/
hi default lfpRR ctermfg=DarkRed guifg=white guibg=DarkRed 

"syn match lfpBreak /[SBFDC]/
"hi default lfpBreak ctermfg=LightBlue guifg=white guibg=LightBlue 

syn match lfpVolume /@[A-Za-z_0-9]*/
hi default lfpVolume ctermfg=DarkBlue guifg=white guibg=DarkBlue 

" hi link tododone tDone
" hi link done tDone

if version >= 508 || !exists("did_halibut_syn_inits")
  if version < 508
    let did_lfp_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink lfpComment     Comment
  HiLink lfpFunction     Function

  HiLink lfpDelimiter   Delimiter


  delcommand HiLink
endif

" b: local to current buffer
let b:current_syntax = "lfp"
