" Header Section {{{1
" =============================================================================
" File:          plugin/markify.vim
" Description:   Use sign to mark & indicate lines matched by quickfix
"                commands. Works for  :make, :lmake, :grep, :lgrep, :grepadd,
"                :lgrepadd, :vimgrep, :lvimgrep, :vimgrepadd, :lvimgrepadd,
"                :cscope, :helpgrep, :lhelpgrep
" Author:        Dhruva Sagar <http://dhruvasagar.com/>
" License:       Vim License
" Website:       http://github.com/dhruvasagar/vim-markify
" Version:       1.1.1
"
" Copyright Notice:
"                Permission is hereby granted to use and distribute this code,
"                with or without modifications, provided that this copyright
"                notice is copied with it. Like anything else that's free,
"                marify.vim is provided *as is* and comes with no warranty of
"                any kind, either expressed or implied. In no event will the
"                copyright holder be liable for any damamges resulting from
"                the use of this software.
" =============================================================================
" }}}1

if exists('g:markify_loaded') "{{{1
  finish
endif
let g:markify_loaded = 1
" }}}1

if !has('signs') "{{{1
  echoerr 'Compile VIM with signs to use this plugin.'
  finish
endif
" }}}1

" Avoiding side effects {{{1
let s:save_cpo = &cpo
set cpo&vim
" }}}1

function! s:SetGlobalOptDefault(opt, val) "{{{1
  if !exists('g:' . a:opt)
    let g:{a:opt} = a:val
  endif
endfunction
" }}}1

" Set Global Default Options {{{1
call s:SetGlobalOptDefault('markify_error_text', '>>')
call s:SetGlobalOptDefault('markify_error_texthl', 'Error')
call s:SetGlobalOptDefault('markify_warning_text', '>>')
call s:SetGlobalOptDefault('markify_warning_texthl', 'Todo')
call s:SetGlobalOptDefault('markify_info_text', '>>')
call s:SetGlobalOptDefault('markify_info_texthl', 'Normal')
call s:SetGlobalOptDefault('markify_autocmd', 1)
call s:SetGlobalOptDefault('markify_map', '<Leader>mm')
call s:SetGlobalOptDefault('markify_clear_map', '<Leader>mc')
call s:SetGlobalOptDefault('markify_toggle_map', '<Leader>M')
call s:SetGlobalOptDefault('markify_echo_current_message', 1)
" }}}1

if g:markify_autocmd "{{{1
  augroup Markify " {{{2
    au!

    if g:markify_echo_current_message
      autocmd CursorMoved * call s:EchoCurrentMessage()
    endif

    autocmd QuickFixCmdPost * call s:MarkifyClear() | call s:Markify()
  augroup END
  " }}}2
end
" }}}1

" Define Signs {{{1
execute 'sign define MarkifyError text=' . g:markify_error_text .
      \ ' texthl=' . g:markify_error_texthl
execute 'sign define MarkifyWarming text=' . g:markify_warning_text .
      \ ' texthl=' . g:markify_warning_texthl
execute 'sign define MarkifyInfo text=' . g:markify_info_text .
      \ ' texthl=' . g:markify_info_texthl
" }}}1

function! MarkifyBalloonExpr() " {{{1
  for item in getqflist()
    if item.bufnr ==# v:beval_bufnr && item.lnum ==# v:beval_lnum
      return item.text
    endif
  endfor
  return ''
endfunction
" }}}1

function! s:PlaceSigns(items) " {{{1
  for item in a:items
    if item.bufnr == 0 || item.lnum == 0 | continue | endif
    let id = item.bufnr . item.lnum
    if has_key(s:sign_ids, id) | return | endif
    let s:sign_ids[id] = item

    let sign_name = ''
    if item.type ==? 'E'
      let sign_name = 'MarkifyError'
    elseif item.type ==? 'W'
      let sign_name = 'MarkifyWarning'
    else
      let sign_name = 'MarkifyInfo'
    endif

    execute 'sign place ' . id . ' line=' . item.lnum . ' name=' . sign_name .
          \ ' buffer=' .  item.bufnr
  endfor
endfunction
" }}}1

" function! s:EchoMessage(message) - Taken from Syntastic {{{1
function! s:EchoMessage(message)
  let [old_ruler, old_showcmd] = [&ruler, &showcmd]

  let message = substitute(a:message, "\t", repeat(' ', &tabstop), 'g')
  let message = strpart(message, 0, winwidth(0)-1)
  let message = substitute(message, "\n", '', 'g')

  set noruler noshowcmd
  redraw

  echo message

  let [&ruler, &showcmd] = [old_ruler, old_showcmd]
endfunction
" }}}1

function! s:EchoCurrentMessage() "{{{1
  let id = bufnr('%') . line('.')
  if !has_key(s:sign_ids, id) | return | endif
  call s:EchoMessage(s:sign_ids[id].text)
endfunction
" }}}1

" function! s:Markify() {{{1
let [s:markified, s:sign_ids] = [0, {}]
function! s:Markify()
  if s:markified | return | endif

  let [items, loclist, qflist] = [[], getloclist(0), getqflist()]
  if !empty(loclist)
    let items = loclist
  elseif !empty(qflist)
    let items = qflist
  endif

  if has('balloon_eval')
    let old_balloonexpr = &balloonexpr
    set ballooneval balloonexpr=MarkifyBalloonExpr()
  endif

  call s:PlaceSigns(items)

  if has('balloon_eval') && exists(old_balloonexpr)
    let &balloonexpr = old_balloonexpr
  endif

  let s:markified = 1
endfunction
" }}}1

function! s:MarkifyClear() " {{{1
  for sign_id in keys(s:sign_ids)
    exec 'sign unplace ' . sign_id
    call remove(s:sign_ids, sign_id)
  endfor
  let s:markified = 0
endfunction
" }}}1

function! s:MarkifyToggle() "{{{1
  if s:markified | call s:MarkifyClear() | else | call s:Markify() | endif
endfunction
" }}}1

" Commands & Mappings {{{1
command! -nargs=0 Markify call s:Markify()
command! -nargs=0 MarkifyClear call s:MarkifyClear()
command! -nargs=0 MarkifyToggle call s:MarkifyToggle()

execute "nnoremap <silent> " . g:markify_map . " :Markify<CR>"
execute "nnoremap <silent> " . g:markify_clear_map . " :MarkifyClear<CR>"
execute "nnoremap <silent> " . g:markify_toggle_map . " :MarkifyToggle<CR>"
" }}}1

" Avoid side effects {{{1
let &cpo = s:save_cpo
unlet s:save_cpo
" }}}1

" ModeLine {{{
" vim:fdl=0 fdm=marker
