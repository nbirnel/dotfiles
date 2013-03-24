let s:here = getcwd()
let s:tmp = s:here . '/tmp'
let s:colorlist = s:here . '/colors'
let s:goodcolorf = s:here . '/goodcolors'

function! CollectColorSchemes()
    silent execute "!rm -f" s:tmp
    for s:path in split(&runtimepath, ',')
        let l:colorpath = s:path . '/colors/'
        silent execute "!ls" l:colorpath "2>/dev/nul >>" s:tmp
    endfor

    silent execute "!sort -u" s:tmp "| sed -n 's/\.vim$//p' >" s:colorlist
endfunction
    
function! AskForGoodColorschemes()
    call SaveColorScheme()
    let l:goodcolors = []
    for l:color in readfile(s:colorlist)
        execute 'colorscheme ' . l:color
        redraw
        let s:r = input("Like " . l:color . "? ", "Y")
        if s:r ==? 'Y'
            call add(l:goodcolors, l:color)
        endif
    endfor
    call RestoreColorScheme()

    call writefile(l:goodcolors, s:goodcolorf)
endfunction

function! SaveColorScheme()
    let s:ocolor = g:colors_name
endfunction

function! RestoreColorScheme()
    execute 'colorscheme ' . s:ocolor 
endfunction
