---
# vim-comment-enhancer
## Introduction
- 【[Chinese | 中文文档](README_zh.md)】
This Vim plugin facilitates the quick addition of comments to selected blocks of code, including markers for added, deleted, and modified code. This is highly useful for code review and version control purposes.
## Effect
```c
/* BEGIN: Added by DefaultAuthor, 2024-06-11 PN: XXX Des: */
Your Code
/* END   : Added by DefaultAuthor, 2024-06-11 PN: XXX  */
```

## Installation
It is recommended to use [vim-plug](https://github.com/junegunn/vim-plug) for installing this plugin.
1. Add the following line to your `init.vim` or `.vimrc` file:
```vim
Plug 'wangfanstar/vim-comment-enhancer'
```
2. Then, run `:PlugInstall`.
## Usage
- Select a block of code and press `Ctrl+a` to add an "Added by" comment.
- Press `Ctrl+d` to add a "Deleted by" comment.
- Press `Ctrl+o` to add a "Modified by" comment.
## Configuration
You can customize the author name in the comments by setting the global variable `g:author`, for example:
```vim
let g:author = "Your Name"
```
---