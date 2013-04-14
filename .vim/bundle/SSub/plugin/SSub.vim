if !exists('g:subsitute_visual_map_keys')
    let g:subsitute_visual_map_keys = 1
endif

if g:subsitute_visual_map_keys
    vnoremap <script> <leader>s <Esc>:<c-r>=<SID>SSub()<cr>
    nnoremap <script> <leader>s :<c-r>=<SID>SSub()<cr>
endif

" MAIN
function! <SID>SSub()
    let l:subs = split(input("Use visual register none cwd windir: ", ''))
    if len(l:subs) < 2
        return ""
    endif
    let l:replacestring = []
    for i in [0, 1]
        if l:subs[i] =~? '^v'
            call add(l:replacestring, s:Sel())
        elseif l:subs[i] =~? '^r'
            if len(l:subs[i]) < 2
                return
            else
                let l:reg = l:subs[i][-1:]
                call add(l:replacestring, getreg(l:reg))
            endif
        elseif l:subs[i] =~? '^n'
            call add(l:replacestring, '')
        elseif l:subs[i] =~? '^c'
            call add(l:replacestring, getcwd())
        elseif l:subs[i] =~? '^w'
            call add(l:replacestring, s:WinCwd())
        else 
            return ""
        endif
    endfor
    let Lsub = s:EscStr(l:replacestring[0], 'LHS')
    let Rsub = s:EscStr(l:replacestring[1], 'RHS')
    return '%s/' . Lsub . '/' . Rsub . '/g'
endfunction

" PROCESSING FUNCTIONS
" derived from from bryan kennedy
" Escape special characters in a string for exact matching.
" Based on  
" http://peterodding.com/code/vim/profile/autoload/xolox/escape.vim
function! s:EscStr(string, side)
    let l:string=a:string

    if a:side ==# 'LHS'
        let string = escape(l:string, '^$.*\/~[]') " Escape regex characters
    elseif a:side ==# 'RHS'
        " remove a trailing null byte. FIXME - this is too aggressive.
        let string = substitute(l:string, '\%o000$', '', '')
        " FIXME factor out \, make / user-replaceable.
        "
        let string = escape(l:string, '&\/')      " Escape escapes and RE delims
    endif
  
    let l:string = substitute(l:string, '\n', '\\n', 'g') " Escape line endings
    return l:string
endfunction

" RAW STRING RETURN FUNCTIONS

function! s:WinCwd()
    if has("win32")
        return getcwd()
    else
        return system("cygpath -w \"$(pwd)\"")
    endif
endfunction

function! s:None(...)
    return ''
endfunction

" Get the current visual block for search and replaces
" Based on 
" http://stackoverflow.com/questions/676600/vim-replace-selected-text/677918#677918
function! s:Sel() range
    " Save the current register and clipboard
    let reg_save = getreg('"')
    let regtype_save = getregtype('"')
    let cb_save = &clipboard
    set clipboard&
  
    " Fill the " register from Visual
    normal! ""gvy
    let selection = getreg('"')
  
    " Put the saved registers and clipboards back
    call setreg('"', reg_save, regtype_save)
    let &clipboard = cb_save

    return selection
endfunction
