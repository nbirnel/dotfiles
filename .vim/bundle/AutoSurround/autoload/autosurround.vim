" make matching ) for (, like Sublime Text 2

function! autosurround#autosurroundstart()
    inoremap " ""<esc>i
    inoremap ' ''<esc>i
    inoremap < <><esc>i
    inoremap ( ()<esc>i
    inoremap [ []<esc>i
    inoremap { {}<esc>i
endfunction

function! AutoSurroundStop()
    iunmap "
    iunmap '
    iunmap <
    iunmap (
    iunmap [
    iunmap {
endfunction
