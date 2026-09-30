if exists('g:loaded_user_harpoon')
  finish
endif
let g:loaded_user_harpoon = 1

let s:harpoon_store = expand('~/.vim/harpoon_files')

function! s:LoadHarpoon() abort
  if filereadable(s:harpoon_store)
    return filter(readfile(s:harpoon_store), 'v:val !=# ""')
  endif
  return []
endfunction

function! s:SaveHarpoon(list) abort
  let l:store_dir = fnamemodify(s:harpoon_store, ':h')
  if !isdirectory(l:store_dir)
    call mkdir(l:store_dir, 'p', 0700)
  endif
  call writefile(a:list, s:harpoon_store)
endfunction

function! HarpoonAdd() abort
  let l:file = expand('%:p')
  if empty(l:file)
    echohl WarningMsg | echom 'Harpoon: current buffer has no file path' | echohl None
    return
  endif

  let l:list = s:LoadHarpoon()
  if index(l:list, l:file) < 0
    call add(l:list, l:file)
    call s:SaveHarpoon(l:list)
    echom 'Harpoon add: ' . fnamemodify(l:file, ':~')
  else
    echom 'Harpoon already contains: ' . fnamemodify(l:file, ':~')
  endif
endfunction

function! HarpoonSelect(index) abort
  let l:list = s:LoadHarpoon()
  if a:index < 1 || a:index > len(l:list)
    echohl WarningMsg | echom 'Harpoon slot ' . a:index . ' is empty' | echohl None
    return
  endif
  execute 'edit' fnameescape(l:list[a:index - 1])
endfunction

function! HarpoonMenu() abort
  let l:list = s:LoadHarpoon()
  if empty(l:list)
    echohl WarningMsg | echom 'Harpoon list is empty' | echohl None
    return
  endif

  let l:choices = ['Harpoon files:']
  for l:i in range(0, len(l:list) - 1)
    call add(l:choices, printf('%d. %s', l:i + 1, fnamemodify(l:list[l:i], ':~:.')))
  endfor

  let l:selected = inputlist(l:choices)
  if l:selected <= 0
    return
  endif
  call HarpoonSelect(l:selected)
endfunction
