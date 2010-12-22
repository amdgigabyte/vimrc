" vim: set et sw=4 ts=4 sts=4 fdm=marker ff=unix fenc=utf8:
"
"   乔福的 Vim 配置文件
"   target:目标是配置一套适用于多个平台的vimrc文件
"   author:qiaofu<amdgigabyte@gmail.com>
"   date:2010-12-22 第一次结合了vingel和mingcheng两份vimrc

if v:version < 700
    echoerr 'This _vimrc requires Vim 7 or later.'
    quit
endif
" =======================
" 配置里面的函数在此定义
" 如果有功能越来越大，可
" 以把功能写成一个vim插件
" =======================
" function 获取当前目录
func! GetPWD()
    return substitute(getcwd(), "", "", "g")
endf

" function 返回当前时间
"func! GetTimeInfo()
"    return strftime('%Y-%m-%d %A %H:%M:%S')
"endfunction

" 全选
func! SelectAll()
    let s:current = line('.')
    exe "norm gg" . (&slm == "" ? "VG" : "gH\<C-O>G")
endfunc

" =========
" 环境配置
" =========
" 保留历史记录
set history=400

" 行控制
set linebreak
set nocompatible
set textwidth=80
set wrap

" 标签页
set tabpagemax=9
set showtabline=4

" 控制台响铃

set noerrorbells
set novisualbell
set t_vb= "close visual bell

" 行号和标尺

set number
set ruler
set rulerformat=%15(%c%V\ %p%%%)

" 状态栏配置

set ch=1
set stl=\ [File]\ %F%m%r%h%y[%{&fileformat},%{&fileencoding}]\ %w\ \ [PWD]\ %r%{GetPWD()}%h\ %=\ [Line]%l/%L\ %=\[%P]
set ls=2 " 始终显示状态行
set showmatch
" 配置命令切换的效果，可以使用左右键切换
set wildmenu
set wildmode=longest,full
set wildignore=*.bak,*.o,*.e,*~,*.pyn,*.svn

" 搜索配置
set incsearch		" do incremental searching
set hlsearch
set ignorecase

" 制表符
set tabstop=4
set expandtab
set smarttab
set shiftwidth=4
set softtabstop=4

" 状态栏显示目前所执行的指令
set showcmd 

" 缩进
set autoindent
set smartindent

" 自动重新读入
set autoread

" 插入模式下使用 <BS>、<Del> <C-W> <C-U>
set backspace=indent,eol,start

" 设定在任何模式下鼠标都可用
set mouse=a

" 备份和缓存
set nobackup
set noswapfile

" 自动完成
set complete=.,w,b,k,t,i
set completeopt=longest,menu

" 代码折叠
set foldmethod=syntax

if has ("folding")
    set nofoldenable
endif

" =====================
" 多语言环境
"    默认为 utf-8 编码
" =====================
if has("multi_byte")
    set encoding=utf-8
    " English messages only
    "language messages zh_CN.utf-8

    if has('win32')
        language english
        let &termencoding=&encoding
    endif

    set fencs=utf-8,gbk,chinese,latin1
    set formatoptions+=mM
    set nobomb " 不使用 Unicode 签名

    if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
        set ambiwidth=double
    endif
else
    echoerr "Sorry, this version of (g)vim was not compiled with +multi_byte"
endif

if has("gui_running")
  set encoding=utf-8
  set langmenu=zh_CN
  "let $LANG='chinese'
  "language messages en_US.utf-8
  language messages zh_CN.utf-8
  "let &termencoding=&encoding
  source $VIMRUNTIME\delmenu.vim
  source $VIMRUNTIME\menu.vim
  if version >= 603
    set helplang=cn
  endif
else
  "set fileencoding=utf-8
  lang mes zh_CN
  set encoding=chinese
endif


" =========
" AutoCmd
" =========
if has("autocmd")
    filetype plugin indent on

    " 括号自动补全
    func! AutoClose()
        :inoremap ( ()<ESC>i
        :inoremap " ""<ESC>i
        :inoremap ' ''<ESC>i
        :inoremap { {}<ESC>i
        :inoremap [ []<ESC>i
        :inoremap ) <c-r>=ClosePair(')')<CR>
        :inoremap } <c-r>=ClosePair('}')<CR>
        :inoremap ] <c-r>=ClosePair(']')<CR>
    endf

    func! ClosePair(char)
        if getline('.')[col('.') - 1] == a:char
            return "\<Right>"
        else
            return a:char
        endif
    endf

    augroup vimrcEx
        au!
        autocmd FileType text setlocal textwidth=80
        autocmd BufReadPost *
                    \ if line("'\"") > 0 && line("'\"") <= line("$") |
                    \   exe "normal g`\"" |
                    \ endif
    augroup END

    "auto close quotation marks for PHP, Javascript, etc, file
    au FileType php,c,python,javascript exe AutoClose()

    " Auto Check Syntax
    au BufWritePost,FileWritePost *.js,*.php call CheckSyntax(1)

    " JavaScript 语法高亮
    au FileType html,javascript let g:javascript_enable_domhtmlcss = 1

    " 给 Javascript 文件添加 Dict
    if has('gui_macvim') || has('unix')
        au FileType javascript setlocal dict+=~/.vim/dict/javascript.dict
    else 
        au FileType javascript setlocal dict+=$VIM/vimfiles/dict/javascript.dict
    endif

    " 格式化 JavaScript 文件
    au FileType javascript map <f12> :call g:Jsbeautify()<cr>
    au FileType javascript set omnifunc=javascriptcomplete#CompleteJS

    " 给 CSS 文件添加 Dict
    if has('gui_macvim') || has('unix')
        au FileType css setlocal dict+=~/.vim/dict/css.dict
    else
        au FileType css setlocal dict+=$VIM/vimfiles/dict/css.dict
    endif

    " 增加 ActionScript 语法支持
    au BufNewFile,BufRead *.as setf actionscript 

    " 自动最大化窗口
    if has('gui_running')
        if has("win32")
            au GUIEnter * simalt ~x
        "elseif has("unix")
            "au GUIEnter * winpos 0 0
            "set lines=999 columns=999
        endif
    endif
endif

" =========
" 图形界面
" =========
if has('gui_running')
    " 只显示菜单
    set guioptions=mcr

    " 高亮光标所在的行和列
    set cursorline
    "set cursorcolumn

    if has("win32")
        " Windows 兼容配置
        source $VIMRUNTIME/mswin.vim

        " f11 最大化
        map <f11> :call libcallnr('gvimfullscreen.dll', 'ToggleFullScreen', 0)<cr>

        " 字体配置
        "exec 'set guifont='.iconv('Courier_New', &enc, 'gbk').':h11:cANSI'
        set guifont=Consolas:h14:cDEFAULT
        "exec 'set guifontwide='.iconv('微软雅黑', &enc, 'gbk').':h11'
    endif
endif

if has("gui_running")
    " 编辑器配色
    colorscheme railscasts

    hi CursorLine guibg=#333333
    hi CursorColumn guibg=#333333
    
    " Omni menu colors
    hi Pmenu guibg=#333333
    hi PmenuSel guibg=#555555 guifg=#ffffff

else
    set background=dark
    "colorscheme zellner
    colorscheme vivi
endif

" =========
" 快捷键
" =========

" 编码转换
nmap <leader>eg :set fenc=gbk<cr>
nmap <leader>ee :set fenc=utf-8<cr>

" 标签相关的快捷键
nmap <C-t> :tabnew<cr>
nmap <C-p> :tabprevious<cr>
nmap <C-n> :tabnext<cr>
nmap <C-k> :tabclose<cr>
nmap <C-Tab> :tabnext<cr> 
"for i in range(1, &tabpagemax)
"    exec 'nmap <A-'.i.'> '.i.'gt'
"endfor

" 插件快捷键
nmap <C-d> :NERDTree<cr>
nmap <C-e> :BufExplorer<cr>

" 插入模式按 Ctrl + D(ate) 插入当前时间
"imap <C-d> <C-r>=GetTimeInfo()<cr>

" 新建 XHTML 、PHP、Javascript 文件的快捷键
nmap <C-c><C-h> :NewQuickTemplateTab xhtml<cr>
nmap <C-c><C-p> :NewQuickTemplateTab php<cr>
nmap <C-c><C-j> :NewQuickTemplateTab javascript<cr>
nmap <C-c><C-c> :NewQuickTemplateTab css<cr>
nmap <Leader>ca :Calendar<cr>

" 按下 Q 不进入 Ex 模式，而是退出
nmap Q :x<cr>

" Visual 中用 tab 和 shif-tab 做缩排
vmap <Tab>   :><CR>gv
vmap <S-Tab> :<<CR>gv

" =========
" 插件
" =========
" Javascript in CheckSyntax
let g:checksyntax_cmd_javascript  = 'jsl -conf '.shellescape($VIM . '\vimfiles\plugin\jsl.conf')
let g:checksyntax_cmd_javascript .= ' -nofilelisting -nocontext -nosummary -nologo -process'

" VIM HTML 插件
let g:no_html_toolbar = 'yes'

" YUICompressor 插件 modified from mingcheng 
let g:yui_compressor_command = 'compressor.cmd'

" VimWiki
let g:vimwiki_list = [{'path': $VIM . '\wiki\', 'path_html': 'D:\Appserv\www\wiki\', 'syntax': 'default'}]
let g:vimwiki_valid_html_tags='b,i,s,u,sub,sup,kbd,br,hr,del,code,input,script'
au FileType vimwiki set foldmethod=manual ff=unix fenc=utf8
nmap <C-i><C-i> :VimwikiTabGoHome<cr>
map <S-F4> :VimwikiAll2HTML<cr>
map <F4> :Vimwiki2HTML<cr>

" on Windows, default charset is gbk
if has("win32")
    let g:fontsize#encoding = "gbk"
endif

" Under the Mac(MacVim)
if has("gui_macvim")
    " Mac 下，按 \ff 切换全屏
    map <Leader>ff  :call FullScreenToggle()<cr>

    " Set input method off
    set imdisable

    " Set QuickTemplatePath
    let g:QuickTemplatePath = $HOME.'/.vim/templates/'

    lcd ~/Desktop/

    " 自动切换到文件当前目录
    set autochdir
endif

" 保证语法高亮
syntax on

"let g:JSLintHighlightErrorLine = 0 
