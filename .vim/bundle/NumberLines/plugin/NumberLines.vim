if !exists('g:number_lines_map_keys')
    let g:number_lines_map_keys = 1
endif

if g:number_lines_map_keys
    vnoremap <leader>N <Esc>:call <SID>NumberSelectedLines(0)<cr>
    nnoremap <leader>N :call <SID>NumberAllLines(0)<cr>
    vnoremap <leader>S <Esc>:call <SID>NumberSelectedLines(1)<cr>
    nnoremap <leader>S :call <SID>NumberAllLines(1)<cr>
endif

" MAIN
function! <SID>NumberAllLines(as_suffix)
    let savepos  = getpos('.')
    let end = getpos('$')[1]
    1
    call <SID>NumberLines(1, l:end, a:as_suffix)
    call setpos('.', l:savepos)
endfunction

"savepos . or '<
"beg 1 or savepos[1]
"end getpos $ or '>
"setpos savepos
"call numberlines
"setpos savepos

function! <SID>NumberSelectedLines(as_suffix)
    let savepos  = getpos("'<")
    let beg = l:savepos[1]
    let end = getpos("'>")[1]
    call setpos('.', l:savepos)
    call <SID>NumberLines(l:beg, l:end, a:as_suffix)
    call setpos('.', l:savepos)
    normal! gv
endfunction

function! <SID>NumberLines(beg, end, as_suffix)
    let l:input = input("Enter start number: ", '1')
    if match(l:input, '[0-9]') ==# -1
        redraw | echom 'No number in "' . l:input . '"'
        return
    endif
    let l:delim = substitute(l:input, '^.*[0-9]\+\([^0-9]*\)$', '\1', '')
    let l:input = substitute(l:input, '^\(.*[0-9]\+\)[^0-9]*$', '\1', '')

    let l:prefix = substitute(l:input, '[0-9]*$', '', '')
    let l:rawnum = substitute(l:input, '^.*[^0-9]\+\([0-9]*\)$', '\1', '')
    let l:i      = substitute(l:rawnum, '^0*', '', '')
    let l:numpad = len(l:rawnum)

    while line(".") !=# a:end
        call <SID>NumberCurrentLine(l:numpad, l:prefix, l:i, l:delim, a:as_suffix)
        let l:i +=1
        +
    endwhile
    call <SID>NumberCurrentLine(l:numpad, l:prefix, l:i, l:delim, a:as_suffix)
endfunction

function! <SID>NumberCurrentLine(pad, prefix, number, delim, as_suffix)
    let l:fmtnum = printf('%s%0' . a:pad . 'd%s', a:prefix, a:number, a:delim)
    if a:as_suffix == 1
        s/$/\=l:fmtnum/
    else
        s/^/\=l:fmtnum/
    endif
endfunction

function! EscapeString(string)
    let string = escape(l:string, '&\/')   " Escape escapes and RE delims
    return l:string
    let l:string = substitute(l:string, '\n', '\\n', 'g') " Escape line endings
endfunction
