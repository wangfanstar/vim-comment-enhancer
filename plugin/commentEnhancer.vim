" =============================================================================
" Comment-Enhancer.vim - 一个增强注释功能的Vim插件
" 功能：
" 1. 自动生成函数头注释
" 2. 添加修改/添加/删除代码块的注释标记
" 3. 从.author文件读取作者信息
" =============================================================================

" 防止重复加载插件
if exists("g:loaded_comment_enhancer")
  finish
endif
let g:loaded_comment_enhancer = 1

" 设置默认作者信息（如果未定义）
if !exists("g:author")
  let g:author = "DefaultAuthor"
endif

" 设置默认PN和Des值（如果未定义）
if !exists("g:PN")
  let g:PN = "XXX"
endif
if !exists("g:Des")
  let g:Des = "YYY"
endif

" 从.author文件更新作者信息
function! UpdateAuthorFromAuthorFile()
  " 初始化全局变量
  let g:author = '未设置'
  let g:PN = '未设置'
  let g:Des = '未设置'
  
  " 尝试读取.author文件
  if filereadable(".author")
    let l:author_content = readfile(".author")
    " 解析文件内容
    for line in l:author_content
      let line = trim(line)
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
  
  " 显示当前设置的值
  echom "Author: " . g:author
  echom "PN: " . g:PN
  echom "Des: " . g:Des
endfunction

" 启动时自动更新作者信息
call UpdateAuthorFromAuthorFile()

" 映射<leader>9键更新作者信息
nnoremap <leader>9 :call UpdateAuthorFromAuthorFile()<CR>

" 获取当前日期的辅助函数
function! GetCurrentDate()
  return strftime("%Y-%m-%d")
endfunction

" 处理代码块注释（添加/删除/修改标记）
function! ProcessComment(action)
  " 获取当前日期
  let l:current_date = GetCurrentDate()
  
  " 构建注释前缀和后缀
  let l:prefix = "/* BEGIN: " . a:action . " by " . g:author . ", " . l:current_date . " PN:" . "HSV7D" . g:PN . " Des: " . g:Des . " */\n"
  let l:suffix = "/* END  : " . a:action . " by " . g:author . ", " . l:current_date . " PN:" . "HSV7D" . g:PN . " */"
  
  " 获取选择的行范围
  let l:start_line = line("'<")
  let l:end_line = line("'>")
  
  " 根据选择的是单行还是多行进行不同处理
  if l:start_line == l:end_line
    " 单行情况
    normal! `<I
    execute "normal! i" . l:prefix
    execute "normal! \<Esc>o\<Esc>"
    execute "normal! $a" . l:suffix
  else
    " 多行情况
    normal! `<I
    execute "normal! i" . l:prefix
    normal! `>
    execute "normal! \<Esc>o\<Esc>"
    execute "normal! a" . l:suffix
  endif
  
  " 处理缩进
  let l:current_indent = indent(line('.') - 1)
  if l:current_indent > 0
    execute "normal! V" . l:start_line . "G="
  endif
endfunction

" 添加代码块的函数
function! AddComment()
  call ProcessComment('Added')
endfunction

" 删除代码块的函数
function! DeleteComment()
  call ProcessComment('Deleted')
endfunction

" 修改代码块的函数
function! ModifyComment()
  call ProcessComment('Modified')
endfunction

" 可视模式下的键映射
vnoremap <C-a> :<C-u>call AddComment()<CR>
vnoremap <C-d> :<C-u>call DeleteComment()<CR>
vnoremap <C-o> :<C-u>call ModifyComment()<CR>

" 初始化用于追踪变量名的数组
let g:which_key_vars = []

" 设置全局作者名称
function! SetGlobalAuthor()
    let g:author = input('Please enter the author name: ')
    call add(g:which_key_vars, 'g:author')
endfunction

" 设置全局PN值
function! SetGlobalPN()
    let g:PN = input('Please enter the PN: ')
    call add(g:which_key_vars, 'g:PN')
endfunction

" 设置全局Des值
function! SetGlobalDes()
    let g:Des = input('Please enter the Description: ')
    call add(g:which_key_vars, 'g:Des')
endfunction

" 显示已设置的全局变量
function! ShowGlobalWhichKeyVars()
    " 映射快捷键到全局变量名
    let l:key_mapping = {
    \ '<leader>1': 'g:author',
    \ '<leader>2': 'g:PN',
    \ '<leader>3': 'g:Des'
    \ }
    
    " 显示每个变量的当前值
    for [key, var_name] in items(l:key_mapping)
        if exists(var_name)
            let value = get(g:, var_name[2:], "")
        else
            let value = ""
        endif
        echo key . ' ' . var_name . ' : ' . value
    endfor
endfunction

" 快捷键映射
nnoremap <silent> <leader>1 :call SetGlobalAuthor()<CR>
nnoremap <silent> <leader>2 :call SetGlobalPN()<CR>
nnoremap <silent> <leader>3 :call SetGlobalDes()<CR>
nnoremap <silent> <leader>0 :call ShowGlobalWhichKeyVars()<CR>

" 生成函数头注释（修正版）
" 生成函数头注释（修正版）
function! GenerateFunctionComment() range
    " 获取选中的所有行作为函数声明
    let decl_lines = getline(a:firstline, a:lastline)
    let decl = join(decl_lines, ' ')
    
    " 解析函数声明部分
    let parts = split(decl)
    if len(parts) < 2
        echom "[Comment-Enhancer] 函数声明格式不正确"
        return
    endif
    
    " 提取返回类型和函数名
    let return_type = parts[0]
    let func_name = substitute(parts[1], '(.*', '', '')

    " 提取参数字符串 - 改进正则表达式以匹配单行函数声明
    let param_start = stridx(decl, '(')
    let param_end = strridx(decl, ')')
    
    if param_start == -1 || param_end == -1 || param_start >= param_end
        let param_str = ""
    else
        let param_str = strpart(decl, param_start + 1, param_end - param_start - 1)
    endif
    
    " 判断插入位置
    let ins_line = a:firstline - 1
    let exist = 0
    
    " 检查是否已存在该函数的注释
    let min_line = ins_line > 100 ? ins_line - 100 : 1
    for i in range(min_line, ins_line)
        if getline(i) =~? '^\s*Func Name\s*:\s*' . func_name . '\s*'
            let exist = 1
            break
        endif
    endfor
    
    if exist
        echom '[Comment-Enhancer] 已存在函数头，不重复生成'
        return
    endif

    " 开始构建函数头注释
    let comment = [
    \ '/*****************************************************************************',
    \ ' Func Name    : ' . func_name,
    \ ' Date Created : ' . strftime('%Y/%m/%d'),
    \ ' Author       : ' . g:author,
    \ ' Description  : '
    \ ]

    " 参数分类容器
    let ins = []
    let outs = []
    
    " 如果存在参数，则解析参数
    if !empty(param_str)
        let param_list = split(param_str, ',')
        " 处理每个参数
        for p in param_list
            " 清理参数字符串前后的空白和括号
            let p = substitute(p, '^\s*\(.*\)\s*$', '\1', '')
            if empty(p)
                continue
            endif
            
            let pp = split(p)
            if len(pp) < 2
                continue
            endif
            
            " 识别参数方向（输入/输出）
            let flag = toupper(pp[0])
            
            " 处理不同格式的参数声明
            if len(pp) == 2
                let typ = ""
                let name = pp[1]
            else
                let typ = join(pp[1:-2], ' ')
                let name = pp[-1]
            endif
            
            " 构造参数描述文本（类型+名称）
            let txt = empty(typ) ? name : typ . ' ' . name
            
            " 根据方向分类参数
            if flag =~# '\v^(IN|INOUT)'
                call add(ins, txt)
            endif
            
            if flag =~# '\v^(OUT|INOUT)'
                call add(outs, txt)
            endif
        endfor
    endif

    " 输入参数处理
    if empty(ins)
        call add(comment, ' Input        : None')
    else
        call add(comment, ' Input        : ' . remove(ins, 0))
        for p in ins
            call add(comment, '                ' . p)
        endfor
    endif

    " 输出参数处理
    if empty(outs)
        call add(comment, ' Output       : None')
    else
        call add(comment, ' Output       : ' . remove(outs, 0))
        for p in outs
            call add(comment, '                ' . p)
        endfor
    endif

    " 返回值处理
    if return_type ==# 'ULONG'
        call add(comment, ' Return       : ERROR_SUCCESS 操作成功')
        call add(comment, '                ERROR_FAILED  操作失败')
    elseif return_type ==# 'BOOL_T'
        call add(comment, ' Return       : BOOL_TRUE')
        call add(comment, '                BOOL_FALSE')
    else
        call add(comment, ' Return       : ' . return_type)
    endif

    " 注意事项和结束标记
    call add(comment, ' Caution      :')
    call add(comment, '*****************************************************************************/')

    " 插入注释到目标位置
    call append(ins_line, comment)
    call cursor(ins_line + 1, 1)
endfunction

" 在可视模式下映射<leader>f生成函数头注释
vnoremap <silent> <leader>f :call GenerateFunctionComment()<CR>
