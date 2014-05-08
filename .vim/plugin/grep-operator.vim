"http://learnvimmscriptthehardway.stevelosh.com/chapters/33.html

"set script-local GrepOperator as an operator function and call it
nnoremap <leader>g :set operatorfunc=<SID>GrepOperator<cr>g@
" call script-local GrepOperator, telling it what mode we were called from
vnoremap <leader>g :<c-u>call <SID>GrepOperator(visualmode())<cr>

function! s:GrepOperator(type)
    let saved_unnamed_register = @@

    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[v`]y
    else
        return
    endif

    " don't yak at us whilst grepping
    silent execute "grep! -R " . shellescape(@@). " ."
    " open the quick fix window on our results
    copen

    let @@ = saved_unnamed_register
endfunction
