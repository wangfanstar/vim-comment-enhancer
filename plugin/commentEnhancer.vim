" Ensure the script is only loaded once
if exists("g:loaded_comment_enhancer")
  finish
endif
let g:loaded_comment_enhancer = 1

" Set default author if not set
if !exists("g:author")
  let g:author = "DefaultAuthor"
endif

" Set default PN and Des if not set
if !exists("g:PN")
  let g:PN = "XXX"
endif

if !exists("g:Des")
  let g:Des = "YYY"
endif

function! UpdateAuthorFromAuthorFile()
  " 初始化全局变量为 "未设置"
  let g:author = '未设置'
  let g:PN = '未设置'
  let g:Des = '未设置'

  if filereadable(".author")
    " 读取文件内容
    let l:author_content = readfile(".author")
    " 遍历每一行内容
    for line in l:author_content
      " 去掉行首和行尾的空白
      let line = trim(line)
      
      " 查找并处理每行
      if line =~ '^author='
        let g:author = substitute(line, '^author=', '', '')
      elseif line =~ '^pn='
        let g:PN = substitute(line, '^pn=', '', '')
      elseif line =~ '^des='
        let g:Des = substitute(line, '^des=', '', '')
      endif
    endfor
  else
    echom "File .author not found"
  endif

  " 打印变量的值，显示是否已设置
  echom "Author: " . g:author
  echom "PN: " . g:PN
  echom "Des: " . g:Des
endfunction


call UpdateAuthorFromAuthorFile()

" 定义快捷键 <leader>9 来调用 UpdateAuthorFromAuthorFile 函数
nnoremap <leader>9 :call UpdateAuthorFromAuthorFile()<CR>

function! GetCurrentDate()
  return strftime("%Y-%m-%d")
endfunction

function! ProcessComment(action)
  let l:current_date = GetCurrentDate()
  let l:prefix = "/* BEGIN: " . a:action . " by " . g:author . ", " . l:current_date . " PN:"."HSV7D". g:PN . " Des: " . g:Des . " */\n"
  let l:suffix = "/* END  : " . a:action . " by " . g:author . ", " . l:current_date . " PN:"."HSV7D". g:PN . " */"
  
  let l:start_line = line("'<")
  let l:end_line = line("'>")
  
  if l:start_line == l:end_line
    normal! `<I
    execute "normal! i" . l:prefix
    execute "normal! \<Esc>o\<Esc>"
    execute "normal! $a" . l:suffix
  else
    normal! `<I
    execute "normal! i" . l:prefix
    normal! `>
    execute "normal! \<Esc>o\<Esc>"
    execute "normal! a" . l:suffix
  endif
  
  " Select the modified lines in Visual mode and then format
  let l:current_indent = indent(line('.') - 1)  " 获取上一行的缩进量
  if l:current_indent > 0
	execute "normal! V" . l:start_line . "G="
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