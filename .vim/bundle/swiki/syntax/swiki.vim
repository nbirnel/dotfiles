" Vim syntax file
" Language:     CoWeb Swiki http://wiki.squeak.org/swiki
" Maintainer:   Noah Birnel <nbirnel@gmail.com>
" Author:       Noah Birnel
" Filenames:    *.swiki
" Last Change: Fri Dec 14 09:00 AM 2012 P
" Version:      0.1
" Adapted From: http://www.georgevreilly.com/vim/stwiki/
"
" Quit if syntax file is already loaded
if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

syntax match swikiExtLink           `\*[[:alpha:]]\+://[^*]*\*`

" text: *http://foo.bar.com/*
syntax match swikiIntLink           `\*[^*]*\*`

" text: <b>bold<\/b>
syntax match swikiBold           /<b>.*<\/b>/

" text: <u>underlined<\/u>
syntax match swikiUL           /<u>.*<\/u>/

" text: <i>italic<\/i>
syntax match swikiItalic           /<i>.*<\/i>/

" text: <code>code<\/code>
syntax match swikiCode           /<code>.*<\/code>/

" Aggregate all the regular text highlighting into swikiText
syntax cluster swikiText contains=swikiItalic,swikiBold,swikiCode,swikiLink,swikiWord

" Header levels, 1-6
syntax match swikiH1             /^!.*$/
syntax match swikiH2             /^!!.*$/
syntax match swikiH3             /^!!!.*$/

" <hr>, horizontal rule
syntax match swikiHR             /^_.*$/

" Tables. Each line starts and ends with '|'; each cell is separated by '|'
syntax match swikiTable          /|/

" Link swiki syntax items to colors
hi def link swikiH1                    Title
hi def link swikiH2                    swikiH1
hi def link swikiH3                    swikiH2
hi def link swikiHR                    swikiH3
    
hi def swikiBold                       term=bold cterm=bold gui=bold
hi def swikiItalic                     term=italic cterm=italic gui=italic

hi def link swikiCode                  Statement

hi def link swikiUL                   Underlined

hi def link stwikiEscape                Todo
hi def link stwikiPre                   PreProc
hi def link stwikiLink                  Underlined
hi def link stwikiList                  Type

hi def link swikiTable                  Type


let b:current_syntax="stWiki"

" vim:tw=0:
hi def link swikiIntLink Type
hi def link swikiExtLink Type

