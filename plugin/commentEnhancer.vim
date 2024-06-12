" Ensure the script is only loaded once
if exists("g:loaded_comment_enhancer")
  finish
endif
let g:loaded_comment_enhancer = 1
" Set default author if not set
if !exists("g:author")
  let g:author = "DefaultAuthor"
endif
function! GetCurrentDate()
  return strftime("%Y-%m-%d")
endfunction
function! ProcessComment(action)
  let l:current_date = GetCurrentDate()
  let l:prefix = "/* BEGIN: " . a:action . " by " . g:author . ", " . l:current_date . " PN: XXX Des: */\n"
  let l:suffix = "/* END  : " . a:action . " by " . g:author . ", " . l:current_date . " PN: XXX */"
  let l:start_line = line("'<")
  let l:end_line = line("'>")
  if l:start_line == l:end_line
    normal! `<I
    execute "normal! i" . l:prefix
    execute "normal! \<Esc>o\<C-u>\<Esc>"
    execute "normal! $a" . l:suffix
  else
    normal! `<I
    execute "normal! i" . l:prefix
    normal! `>
    execute "normal! \<Esc>o\<C-u>\<Esc>"
    execute "normal! a" . l:suffix
  endif
endfunction
function! AddComment()
  call ProcessComment('Added')
endfunction
function! DeleteComment()
  call ProcessComment('Deleted')
endfunction
function! ModifyComment()
  call ProcessComment('Modified')
endfunction
" Map shortcuts
vnoremap <C-a> :<C-u>call AddComment()<CR>
vnoremap <C-d> :<C-u>call DeleteComment()<CR>
vnoremap <C-o> :<C-u>call ModifyComment()<CR>