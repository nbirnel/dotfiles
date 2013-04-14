nnoremap <leader>d :normal! a<c-r>=<SID>Date()<cr><cr>
nnoremap <leader>t :normal! a<c-r>=<SID>DateTime()<cr><cr>
nnoremap <leader>T :normal! a<c-r>=<SID>Time()<cr><cr>

function! <SID>Date() 
    return strftime("%Y-%m-%d")
endfunction

function! <SID>DateTime() 
    return strftime("%Y-%m-%d %I:%M %p")
endfunction

function! <SID>Time() 
    return strftime("%I:%M %p")
endfunction

