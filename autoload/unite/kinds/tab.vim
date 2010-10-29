"=============================================================================
" FILE: tab.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" Last Modified: 29 Oct 2010
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

function! unite#kinds#tab#define()"{{{
  return s:kind
endfunction"}}}

let s:kind = {
      \ 'name' : 'tab',
      \ 'default_action' : 'open',
      \ 'action_table': {},
      \}

" Actions"{{{
let s:kind.action_table.open = {
      \ }
function! s:kind.action_table.open.func(candidate)"{{{
  execute 'tabnext' a:candidate.unite_tab_nr
endfunction"}}}

let s:kind.action_table.delete = {
      \ 'is_selectable' : 1,
      \ 'is_invalidate_cache' : 1,
      \ 'is_quit' : 0,
      \ }
function! s:kind.action_table.delete.func(candidates)"{{{
  for l:candidate in sort(a:candidates, 's:compare')
    execute 'tabclose' l:candidate.unite_tab_nr
  endfor
endfunction"}}}

if exists('*gettabvar')
  let s:kind.action_table.cd = {
        \ }
  function! s:kind.action_table.cd.func(candidate)"{{{
    let l:dir = a:candidate.unite_tab_cwd
    if l:dir == ''
      " Ignore.
      return
    endif

    if &filetype ==# 'vimfiler'
      call vimfiler#internal_commands#cd(l:dir)
    elseif &filetype ==# 'vimshell'
      call vimshell#switch_shell(0, l:dir)
    endif

    execute g:unite_cd_command '`=l:dir`'
  endfunction"}}}

  let s:kind.action_table.lcd = {
        \ }
  function! s:kind.action_table.lcd.func(candidate)"{{{
    let l:dir = a:candidate.unite_tab_cwd
    if l:dir == ''
      " Ignore.
      return
    endif

    if &filetype ==# 'vimfiler'
      call vimfiler#internal_commands#cd(l:dir)
    elseif &filetype ==# 'vimshell'
      call vimshell#switch_shell(0, l:dir)
    endif

    execute g:unite_lcd_command '`=l:dir`'
  endfunction"}}}

  let s:kind.action_table.rename = {
      \ 'is_selectable' : 1,
      \ 'is_invalidate_cache' : 1,
      \ 'is_quit' : 0,
        \ }
  function! s:kind.action_table.rename.func(candidates)"{{{
    for l:candidate in a:candidates
      let l:old_title = gettabvar(l:candidate.unite_tab_nr, 'title')
      let l:title = input(printf('New title: %s -> ', l:old_title), l:old_title)
      if l:title != ''
        call settabvar(l:candidate.unite_tab_nr, 'title', l:title)
      endif
    endfor
  endfunction"}}}
endif
"}}}

" Misc
function! s:compare(candidate_a, candidate_b)"{{{
  return a:candidate_b.unite_tab_nr - a:candidate_a.unite_tab_nr
endfunction"}}}

" vim: foldmethod=marker
