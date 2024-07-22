call plug#begin("~/.vim/plugged")
Plug 'fatih/vim-go', { 'do' : ':GoUpdateBinaries' }

Plug 'preservim/nerdtree'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-rooter'

Plug 'lifepillar/vim-solarized8'

Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
call plug#end()

nnoremap <SPACE> <Nop>
map <Space> <Leader>

" 通用配置
set backspace=indent,eol,start " 配置回退键在插入模式的行为
let g:indentLine_enabled = 1 " 设置缩进对齐

set autowrite " 自动保存
set laststatus=2 " 始终显示状态栏
set statusline=%F\ %l,%c " 控制状态栏显示文件名，行号和列号
autocmd filetype go inoremap <buffer> . .<C-x><C-o>
nnoremap <leader>sn :set number!<CR> " 显示行号
set autoindent " 设置自动缩进
set confirm " 在处理未保存或只读文件时，弹出确认
set history=1000 " 设置历史记录步数
set tabstop=4 " 设置制表符为4空格
set shiftwidth=4 " 设置自动缩进长度为4空格
set expandtab " vim自动将输入的制表符替换为缩进的空格数
autocmd BufWritePre *.go :silent! GoFmt " 保存文件时自动fmt go代码

set foldmethod=syntax " 按代码缩进: indent(python), syntax(golang)
set foldlevel=99 " 默认第n级开始折叠
syntax on

" 主题配色
syntax enable
set background=dark
let g:solarized_termtrans=1 " This gets rid of the grey background
colorscheme solarized8
hi SpecialKey ctermbg=None ctermfg=66

" vim-go推荐高亮配置
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_types = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_functions_buildin = 1
let g:go_highlight_fold_enable = 1 " zo展开 zc折叠 zR展开所有 zM折叠所有

" NerdTree
nnoremap <leader>nc :NERDTreeToggle<CR> " 显示或隐藏目录
nnoremap <leader>ni :NERDTreeFind<CR> " 打开目录，并定位到当前文件
nnoremap <leader>nb :NERDTreeFocus<CR> " 切换窗口焦点到NerdTree窗口
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let NERDTreeShowHidden=1

" fzf and vim-rooter and 模糊查找函数
nnoremap <leader>fg :RG<cr> " 当前项目内全局查找关键字
nnoremap <leader>fh :History<cr> " 查看最近打开的文件和打开的缓冲区
nnoremap <leader>fb :Buffers<cr> " 查看打开的缓冲区
nnoremap <leader>ff :Files<cr> " 当前项目内查找文件
nnoremap <leader>ft :Tags<cr> " 当前项目下查找Tag
let g:fzf_preview_window = ['hidden,right,50%,<70(up,40%)', 'ctrl-/']
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'highlight': 'Todo', 'border': 'rounded' } }
" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1
" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R'
let $FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git/**'"

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" Git
nnoremap <leader>gb :Git blame<cr>

" vim-go
" 双击鼠标左键，跳转到光标所在代码定义处
nnoremap <2-LeftMouse> :GoDef <CR>
" 鼠标右键，从代码定义跳转回上一个位置
nnoremap <RightMouse> :GoDefPop <CR>
" Leader+gr 列出调用当前光标下标识符的代码位置
nnoremap <leader>gr :GoCallers <CR>
" Leader+ge 列出当前光标下标识符调用的代码位置
nnoremap <leader>ge :GoCallees <CR>
" 鼠标滚轮向上滚动，会执行向上滚动，类似于按下Ctrl+Y
nnoremap <ScrollWheelUp> <C-Y>
" 鼠标滚轮向下滚动时，会执行向下滚动，类似于Ctrl+E
nnoremap <ScrollWheelDown> <C-E>
" 按下Leader+gd，会执行Go代码跳转，类似于双击鼠标左键
nnoremap <leader>gd :GoDef <CR>
" 按下Leader+gp，会执行Go代码定义跳转为上一个位置，类似于鼠标右键
nnoremap <leader>gp :GoDefPop <CR>
" 按下Shift+K时，会显示当前光标下标识符文档注释
nnoremap <S-K> :GoDoc<cr>
" 按下Shift+M时，会显示当前光标下标识符的详细信息
nnoremap <S-M> :GoInfo<cr>
" 按下Shift+T时，会跳转到当前光标下标识符的类型定义
nnoremap <S-T> :GoDefType<cr>
" 按下Shift+L时，会执行Go结构体标签（Tag）的添加操作
"nnoremap <S-L> :GoAddTag<cr>
nnoremap <S-L> :GoIfErr <CR>
" 按下Shift+P时，会列出当前光标下接口（interface）的所有实现
nnoremap <S-P> :GoImplements<cr>
" 按下Shift+R时，会执行Go代码的重命名操作
nnoremap <S-R> :GoRename<cr>
" 按下Shift+F时，会执行填充Go结构体的操作
nnoremap <S-F> :GoFillStruct<cr>
" 按下Shift+C时，会列出当前光标下标识符的调用者
nnoremap <S-C> :GoCallers<cr>
" 按下Shift+H时，会启用/禁用相同标识符的突出显示
nnoremap <S-H> :GoSameIdsToggle<cr>


" 自动命令组go, 使用autocmd!可以确保已经存在的autocmd不会被覆盖
augroup go
  autocmd!

  " Show by default 4 spaces for a tab
  autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4

  " :GoBuild and :GoTestCompile
  "autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>

  " :GoTest
  "autocmd FileType go nmap <leader>t  <Plug>(go-test)

  " :GoRun
  "autocmd FileType go nmap <leader>r  <Plug>(go-run)

  " :GoDoc
  "autocmd FileType go nmap <Leader>d <Plug>(go-doc)

  " :GoCoverageToggle
  "autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)

  " :GoInfo
  "autocmd FileType go nmap <Leader>i <Plug>(go-info)

  " :GoMetaLinter
  "autocmd FileType go nmap <Leader>l <Plug>(go-metalinter)

  " :GoDef but opens in a vertical split
  autocmd FileType go nmap <Leader>v <Plug>(go-def-vertical)
  " :GoDef but opens in a horizontal split
  autocmd FileType go nmap <Leader>s <Plug>(go-def-split)

  " :GoAlternate  commands :A, :AV, :AS and :AT
  "autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  "autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  "autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
  "autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
  "autocmd BufNewFile,BufFilePre,BufRead * set wrap
augroup END
