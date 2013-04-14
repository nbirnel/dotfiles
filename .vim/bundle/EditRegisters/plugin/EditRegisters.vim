if !exists('g:edit_registers_map_keys')
    let g:edit_registers_map_keys = 1
endif

if g:edit_registers_map_keys
    vnoremap <script> <leader>s <Esc>:<c-r>=VisualSubstitute()<cr>
    nnoremap <script> <leader>s :<c-r>=VisualSubstitute()<cr>
endif

" MAIN
