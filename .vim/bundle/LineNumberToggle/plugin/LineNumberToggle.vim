if !exists('g:LineNumberToggle_map_keys')
    let g:LineNumberToggle_map_keys = 1
endif

if g:LineNumberToggle_map_keys
    nnoremap <silent><leader>n :call <SID>LineNumberToggle()<cr>
endif

function! <SID>LineNumberToggle()
    if &relativenumber 
        set number
    elseif &number
        set nonumber
    else
        set relativenumber
    endif
endfunction

