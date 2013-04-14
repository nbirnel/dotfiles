" Sorted(l): return sorted list l
function! Sorted(l)
    let new_list = deepcopy(a:l)
    call sort(new_list)
    return new_list
endfunction

" Reversed(l): return reversed list l
function! Reversed(l)
    let new_list = deepcopy(a:l)
    call reverse(new_list)
    return new_list
endfunction

" Append(l, val): return list l with val appended
function! Append(l, val)
    let new_list = deepcopy(a:l)
    call add(new_list, a:val)
    return new_list
endfunction

" Assoc(l, i, val): return list l with index i replaced by val
"                   or     dict l with key   i replaced by val
function! Assoc(l, i, val)
    let new_list = deepcopy(a:l)
    let new_list[a:i] = a:val
    return new_list
endfunction

" Pop(l, i): return list l with index i removed
"            or return dict l with key i removed
function! Pop(l, i)
    let new_list = deepcopy(a:l)
    call remove(new_list, a:i)
    return new_list
endfunction

" Mapped(function("fnname"), l): return list or dict l with func fnname 
"                                run over each value.
function! Mapped(fn, l)
    let new_list = deepcopy(a:l)
    call map(new_list, string(a:fn) . '(v:val)')
    return new_list
endfunction 

" MappedFn('fnname', l): return list or dict l with func fnname 
"                        run over each value.
function! MappedFn(fn, l)
    let new_list = deepcopy(a:l)
    let func_ref = string(function(a:fn))
    call map(new_list, func_ref . '(v:val)')
    return new_list
endfunction 

" Filtered(function('fnname'), l): return elements of list or dict l 
" which evaluate to non zero when function n is applied.
function! Filtered(fn, l)
    let new_list = deepcopy(a:l)
    call filter(new_list, string(a:fn) . '(v:val)')
    return new_list
endfunction

" FilteredFn('fnname', l): return elements of list or dict l 
" which evaluate to non zero (truth) when function n is applied.
function! FilteredFn(fn, l)
    let new_list = deepcopy(a:l)
    let func_ref = string(function(a:fn))
    call filter(new_list, func_ref . '(v:val)')
    return new_list
endfunction

" RemovedFn('fnname', l): return elements of list or dict l 
" which evaluate to false when function n is applied (inverse of FilteredFn).
function! RemovedFn(fn, l)
    let new_list = deepcopy(a:l)
    let func_ref = string(function(a:fn))
    call filter(new_list, '!' . func_ref . '(v:val)')
    return new_list
endfunction

"function! Reduced(fn, l)
"    for i in (a:l)
"        let retval = retval a:fn v:val
"    endfor
"    return retval
"endfunction 
