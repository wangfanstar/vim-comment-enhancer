# vim-comment-enhancer
## 简介
这是一个Vim插件，可以帮助你快速地给选中的代码块添加注释，包括添加、删除和修改的标记。这对于代码审查和版本控制非常有用。
## 使用效果
```c
/* BEGIN: Added by DefaultAuthor, 2024-06-11 PN: XXX Des: */
选中的代码
/* END   : Added by DefaultAuthor, 2024-06-11 PN: XXX  */
```
## 安装
推荐使用[vim-plug](https://github.com/junegunn/vim-plug)来安装此插件。
1. 在你的`init.vim`或`.vimrc`文件中添加以下行：
```vim
Plug 'wangfanstar/vim-comment-enhancer'
```
2. 然后执行`:PlugInstall`。
## 使用
- 选择代码块，然后按`Ctrl+a`来添加“Added by”注释。
- 按`Ctrl+d`来添加“Deleted by”注释。
- 按`Ctrl+o`来添加“Modified by”注释。
## 配置
你可以通过设置全局变量`g:author`来自定义注释中的作者名字，例如：
```vim
let g:author = "你的名字"
```
