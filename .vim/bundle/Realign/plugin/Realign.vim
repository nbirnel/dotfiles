if !exists('g:Realign_map_keys')
    let g:Realign_map_keys = 1
endif

let s:uptomatch     = '\1'
let s:match_n_after = '\2\3'
let s:aftermatch    = '\3'

if g:Realign_map_keys
    "vnoremap <script> <leader>= <Esc>:<c-r>=Realign()<cr>
    "nnoremap <script> <leader>= :<c-r>=Realign()<cr>
    command! -nargs=* -range Realign :call Realign(<line1>,<line2>,<f-args>)
endif

" MAIN

function! Realign(beg, end, ...)
    let s:sepRE    = a:0 > 0 ? a:1 : ' #'
    let s:col      = a:0 > 1 ? a:2 : col(".")

    let s:lineRE = '^\(.*\)\(' . s:sepRE . '\)\(.*\)$'
    let s:uptoRE = '^\(.*\)'   . s:sepRE .     '.*$'

    let i = a:beg
    while l:i <= a:end
        call setpos(".", [0, l:i, 0, 0])
        call <SID>RealignLine(getline("."), 1)
        let l:i += 1
    endwhile

endfunction

function! <SID>RealignLine(line, firstrun)
    if match(a:line, s:sepRE) < 0
        return
    endif
    let prematch = substitute(a:line, s:lineRE, s:uptomatch, '')
    let needed = s:col - len(l:prematch)
    if needed < 1 && a:firstrun
        let a = substitute(l:prematch, '\s*$', '', '')
        let b = substitute(a:line, s:lineRE, s:match_n_after, '')
        call <SID>RealignLine(l:a . l:b, 0)
        return
    elseif needed < 1 
        call setline(".", a:line)
        return
    endif

    let spaces = ''
    let i = 1
    while i < needed
        let spaces = l:spaces . ' '
        let i += 1
    endwhile
    let replacement = '\1' . spaces . '\2\3'
    let newline = substitute(a:line, s:lineRE, l:replacement, "")
    call setline(".", l:newline)
endfunction

