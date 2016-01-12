if has('vim_starting')
  " if &compatible
""    set nocompatible               " Be iMproved
  " endif
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle'))

"""" NeoBundle import plugin list
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/vimproc.vim', {
\ 'build' : {
\     'windows' : 'tools\\update-dll-mingw',
\     'cygwin' : 'make -f make_cygwin.mak',
\     'mac' : 'make -f make_mac.mak',
\     'linux' : 'make',
\     'unix' : 'gmake',
\    },
\ }
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'Yggdroot/indentLine'
NeoBundle 'cakebaker/scss-syntax.vim'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'tpope/vim-surround'
NeoBundle 'vim-scripts/Align'
NeoBundle 'vim-scripts/YankRing.vim'
NeoBundle 'tpope/vim-dispatch'
NeoBundle "tpope/vim-obsession"
NeoBundle 'tyru/open-browser.vim'
NeoBundle 'kannokanno/previm'
NeoBundle "tyru/caw.vim.git"
NeoBundle 'wakatime/vim-wakatime'
" NeoBundle 'digitaltoad/vim-jade'
" NeoBundle 'vim-scripts/jade.vim'

NeoBundleLazy 'junegunn/vim-easy-align', { 'autoload': { 'commands' : ['EasyAlign'] } }
NeoBundleLazy "Shougo/neocomplete.vim", { "autoload": { "insert": 1 } }
NeoBundleLazy 'Shougo/neosnippet.vim', { "autoload": { "insert": 1 } }
NeoBundleLazy "sjl/gundo.vim", { "autoload": { "commands": ['GundoToggle'], } }
NeoBundleLazy "vim-scripts/TaskList.vim", { "autoload": { "mappings": ['<Plug>TaskList'] } }
NeoBundleLazy 'mattn/emmet-vim', { "autoload":  {"filetypes": ['html', 'php'] } }
NeoBundleLazy 'hail2u/vim-css3-syntax', { "autoload": { "filetypes": ['css'] } }
" NeoBundleLazy 'taichouchou2/html5.vim', { "autoload": { "filetypes": ['html', 'php'] } }
NeoBundleLazy 'digitaltoad/vim-jade', { "autoload": { "filetypes": ['jade'] } }
NeoBundleLazy 'jelera/vim-javascript-syntax', { 'autoload':{ 'filetypes':['javascript'] } }
NeoBundleLazy "Shougo/unite.vim", { "autoload": { "commands": ["Unite", "UniteWithBufferDir"] } }
NeoBundleLazy 'h1mesuke/unite-outline', { "autoload": { "unite_sources": ["outline"], } }
NeoBundleLazy 'sophacles/vim-processing', { "autoload": { "filetypes": ['pde', 'processing'] } }
NeoBundleLazy "Shougo/vimfiler", {
\ "depends": ["Shougo/unite.vim"],
\ "autoload": {
\   "commands": ["VimFilerTab", "VimFiler", "VimFilerExplorer"],
\   "mappings": ['<Plug>(vimfiler_switch)'],
\   "explorer": 1,
\ }}
NeoBundleLazy "davidhalter/jedi-vim", {
\ "autoload": {
\   "filetypes": ["python", "python3", "djangohtml"],
\ },
\ "build": {
\   "mac": "pip install jedi",
\   "unix": "pip install jedi",
\ }}
NeoBundleLazy "thinca/vim-quickrun", {
\ "autoload": {
\   "mappings": [['nxo', '<Plug>(quickrun)']]
\ }}

NeoBundleLazy 'OmniSharp/omnisharp-vim', {
\   'autoload': { 'filetypes': [ 'cs', 'csi', 'csx' ] },
\   'build': {
\     'windows' : 'msbuild server/OmniSharp.sln',
\     'mac': 'xbuild server/OmniSharp.sln',
\     'unix': 'xbuild server/OmniSharp.sln',
\   },
\ }

NeoBundleLazy 'OrangeT/vim-csharp', { 'autoload': { 'filetypes': [ 'cs', 'csi', 'csx' ] } }

"""" end of plugin list

call neobundle#end()
filetype plugin indent on
NeoBundleCheck

"----------------------------------------------------
" 基本的な設定
"----------------------------------------------------
set ffs=unix,dos,mac
set encoding=utf-8
set fileencodings=utf-8,ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932
set termencoding=utf-8
" scriptencoding utf-8
set clipboard+=unnamed,autoselect
set vb t_vb=    " ビープ音を鳴らさない

 "----------------------------------------------------
" vim file関連
"----------------------------------------------------
set confirm    " 保存されていないファイルがあるときは終了前に保存確認
set hidden     " 保存されていないファイルがあるときでも別のファイルを開くことが出来る
set autoread   "外部でファイルに変更がされた場合は読みなおす
set nobackup   " ファイル保存時にバックアップファイルを作らない
set noswapfile " ファイル編集中にスワップファイルを作らない
set switchbuf=useopen   " 新しく開く代わりにすでに開いてあるバッファを開く
set nowritebackup
set backspace=indent,eol,start " バックスペースキーで削除できるものを指定


"----------------------------------------------------
" 検索関係
"----------------------------------------------------

set history=100     " コマンド、検索パターンを100個まで履歴に残す
set ignorecase      " 検索の時に大文字小文字を区別しない
set smartcase       " 検索の時に大文字が含まれている場合は区別して検索する
set wrapscan        " 最後まで検索したら先頭に戻る
" set noincsearch     " インクリメンタルサーチを使わない
set incsearch           " インクリメンタルサーチ
set hlsearch        " 検索結果文字列のハイライトを有効にする
set wrapscan        " 検索がファイル末尾まで進んだら、ファイル先頭から再び検索する。（有効:wrapscan/無効:nowrapscan）

"----------------------------------------------------
" 表示関係
"----------------------------------------------------
syntax on           " シンタックスハイライトを有効にする
set title           " タイトルをウインドウ枠に表示する
set number          " 行番号を表示する
set showcmd         " 入力中のコマンドをステータスに表示する
set laststatus=2    " ステータスラインを常に表示
set showmatch       " 括弧入力時の対応する括弧を表示
set matchtime=3     " 対応する括弧の表示時間を2にする
set matchpairs=(:),{:},[:],<:>  " 強調する括弧のパターン
set wildmenu        " コマンドライン補完を拡張モードにする
set cursorline      " カーソルを表示
set virtualedit=all     " カーソルを文字が存在しない部分でも動けるようにする
set wrap                " 長いテキストの折り返し
" set textwidth=0         " 自動的に改行が入るのを無効化
set colorcolumn=80      " その代わり80文字目にラインを入れる
set novisualbell    " 前時代的スクリーンベルを無効化
set ruler
set list                " 不可視文字の可視化
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE
highlight CursorLine gui=underline guifg=NONE guibg=NONE
set ambiwidth=double

"----------------------------------------------------
" インデント
"----------------------------------------------------
set smartindent
"自動インデントを有効にする
set smartindent
set autoindent
set tabstop=2 
set shiftround          " '<'や'>'でインデントする際に'shiftwidth'の倍数に丸める
set cindent
set expandtab
set softtabstop=4
set whichwrap=b,s,h,l,<,>,[,]
vnoremap <silent> > >gv
vnoremap <silent> < <gv

"----------------------------------------------------
" 補完
"----------------------------------------------------
set infercase           " 補完時に大文字小文字を区別しない
set matchpairs& matchpairs+=<:>   " 対応括弧に'<'と'>'のペアを追加
set wildchar=<tab>
set wildmode=longest,full
set shiftwidth=2

"----------------------------------------------------
" 検索
"----------------------------------------------------
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

"----------------------------------------------------
" その他
"----------------------------------------------------
let mapleader = ","
noremap \  ,
",のデフォルトの機能は、\で使えるように退避


"----------------------------------------------------
" ファイル系
"----------------------------------------------------
au BufNewFile,BufRead *.scss set filetype=sass
au BufNewFile,BufRead *.slim set filetype=slim
au BufNewFile,BufRead *.ejs.* set filetype=jst
au BufNewFile,BufRead *.ejs set filetype=jst
au BufNewFile,BufRead *.pde setf processing↲
au BufNewFile,BufRead *.jade set filetype=jade
au BufNewFile,BufRead *.jade set tabstop=2 shiftwidth=2 expandtab


"----------------------------------------------------
" キーマッピング
"----------------------------------------------------
" 入力モード中に素早くjjと入力した場合はESCとみなす
inoremap jj <Esc>
" ESCを二回押すことでハイライトを消す
nmap <silent> <Esc><Esc> :nohlsearch<CR>
" カーソル下の単語を * で検索
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n', 'g')<CR><CR>
" 検索後にジャンプした際に検索単語を画面中央に持ってくる
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
" j, k による移動を折り返されたテキストでも自然に振る舞うように変更
" nnoremap j gj
" nnoremap k gk
" nnoremap <Down> gj
" nnoremap <Up> gk
" vを二回で行末まで選択
vnoremap v $h
" TABにて対応ペアにジャンプ
nnoremap <Tab> %
vnoremap <Tab> %
" Ctrl + hjkl でウィンドウ間を移動
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Shift + 矢印でウィンドウサイズを変更
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>
" T + ? で各種設定をトグル
nnoremap [toggle] <Nop>
nmap T [toggle]
nnoremap <silent> [toggle]s :setl spell!<CR>:setl spell?<CR>
nnoremap <silent> [toggle]l :setl list!<CR>:setl list?<CR>
nnoremap <silent> [toggle]t :setl expandtab!<CR>:setl expandtab?<CR>
nnoremap <silent> [toggle]w :setl wrap!<CR>:setl wrap?<CR>

"----------------------------------------------------
" vim コマンド
"----------------------------------------------------
" w!! でスーパーユーザーとして保存（sudoが使える環境限定）
cmap w!! w !sudo tee > /dev/null %

"----------------------------------------------------
" 未整理
"----------------------------------------------------
augroup MyAutoCmd
  autocmd!
augroup END

" make, grep などのコマンド後に自動的にQuickFixを開く
autocmd MyAutoCmd QuickfixCmdPost make,grep,grepadd,vimgrep copen
" QuickFixおよびHelpでは q でバッファを閉じる
autocmd MyAutoCmd FileType help,qf nnoremap <buffer> q <C-w>c
" :e などでファイルを開く際にフォルダが存在しない場合は自動作成
function! s:mkdir(dir, force)
  if !isdirectory(a:dir) && (a:force ||
        \ input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
  endif
endfunction
autocmd MyAutoCmd BufWritePre * call s:mkdir(expand('<afile>:p:h'), v:cmdbang)
" vim 起動時のみカレントディレクトリを開いたファイルの親ディレクトリに指定
autocmd MyAutoCmd VimEnter * call s:ChangeCurrentDir('', '')
function! s:ChangeCurrentDir(directory, bang)
    if a:directory == ''
        lcd %:p:h
    else
        execute 'lcd' . a:directory
    endif
    if a:bang == ''
        pwd
    endif
endfunction
" ~/.vimrc.localが存在する場合のみ設定を読み込む
let s:local_vimrc = expand('~/.vimrc.local')
if filereadable(s:local_vimrc)
    execute 'source ' . s:local_vimrc
endif
" tab
" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction
" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
" set showtabline=2 " 常にタブラインを表示
" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ
map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tc 新しいタブを一番右に作る
map <silent> [Tag]x :tabclose<CR>
" tx タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ

"----------------------------------------------------
" neocomplete
"----------------------------------------------------
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings
inoremap <expr><CR> pumvisible() ? neocomplete#smart_close_popup() : "\<CR>"
inoremap <expr><BS> pumvisible() ? neocomplete#cancel_popup() . "<BS>" : "\<BS>"
inoremap <expr><C-y> pumvisible() ? neocomplete#smart_close_popup() : "\<C-y>"
inoremap <expr><C-n> pumvisible() ? neocomplete#close_popup() : "\<C-n>"
inoremap <expr><C-h> pumvisible() ? neocomplete#cancel_popup() : "\<C-h>"
inoremap <expr><C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr><C-k> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr><C-h> pumvisible() ? neocomplete#smart_close_popup() . "\<C-i>" : "\<C-h>"
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType cs setlocal omnifunc=OmniSharp#Complete

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.cs = '.*[^=\);]'

"----------------------------------------------------
" lightline 
"----------------------------------------------------
let g:lightline = {
\ 'colorscheme': 'solarized',
\ 'active': {
\   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
\   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
\ },
\ 'component_function': {
\   'fugitive': 'MyFugitive',
\   'filename': 'MyFilename',
\   'fileformat': 'MyFileformat',
\   'filetype': 'MyFiletype',
\   'fileencoding': 'MyFileencoding',
\   'mode': 'MyMode',
\   'ctrlpmark': 'CtrlPMark',
\ },
\ 'component_expand': {
\   'syntastic': 'SyntasticStatuslineFlag',
\ },
\ 'component_type': {
\   'syntastic': 'error',
\ },
\ 'separator': { 'left': '⮀', 'right': '⮂' },
\ 'subseparator': { 'left': '⮁', 'right': '⮃' }
\ }

function! MyModified()
  return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction

function! MyFilename()
  let fname = expand('%:t')
  return fname == 'ControlP' ? g:lightline.ctrlp_item :
        \ fname == '__Tagbar__' ? g:lightline.fname :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
        \ &ft == 'unite' ? unite#get_status_string() :
        \ &ft == 'vimshell' ? vimshell#get_status_string() :
        \ ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ ('' != fname ? fname : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  try
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
      let mark = ''  " edit here for cool mark
      let _ = fugitive#head()
      return strlen(_) ? mark._ : ''
    endif
  catch
  endtry
  return ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == 'ControlP' ? 'CtrlP' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! CtrlPMark()
  if expand('%:t') =~ 'ControlP'
    call lightline#link('iR'[g:lightline.ctrlp_regex])
    return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
          \ , g:lightline.ctrlp_next], 0)
  else
    return ''
  endif
endfunction

let g:ctrlp_status_func = {
  \ 'main': 'CtrlPStatusFunc_1',
  \ 'prog': 'CtrlPStatusFunc_2',
  \ }

function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
  let g:lightline.ctrlp_regex = a:regex
  let g:lightline.ctrlp_prev = a:prev
  let g:lightline.ctrlp_item = a:item
  let g:lightline.ctrlp_next = a:next
  return lightline#statusline(0)
endfunction

function! CtrlPStatusFunc_2(str)
  return lightline#statusline(0)
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
    let g:lightline.fname = a:fname
  return lightline#statusline(0)
endfunction

augroup AutoSyntastic
  autocmd!
  autocmd BufWritePost *.c,*.cpp call s:syntastic()
augroup END

function! s:syntastic()
  SyntasticCheck
  call lightline#update()
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

"----------------------------------------------------
" previm
"----------------------------------------------------
augroup PrevimSettings
  autocmd!
  autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
augroup END

"----------------------------------------------------
" indentLine
"----------------------------------------------------
let g:indentLine_faster = 1
nmap <silent><Leader>i :<C-u>IndentLinesToggle<CR>

"----------------------------------------------------
" tcomment_vim
"----------------------------------------------------
if !exists('g:tcomment_types')
  let g:tcomment_types = {}
endif
let g:tcomment_types = {
      \'php_surround' : "<?php %s ?>",
      \'eruby_surround' : "<%% %s %%>",
      \'eruby_surround_minus' : "<%% %s -%%>",
      \'eruby_surround_equality' : "<%%= %s %%>",
\}
" マッピングを追加
function! SetErubyMapping2()
  nmap <buffer> <C-_>c :TCommentAs eruby_surround<CR>
  nmap <buffer> <C-_>- :TCommentAs eruby_surround_minus<CR>
  nmap <buffer> <C-_>= :TCommentAs eruby_surround_equality<CR>
  vmap <buffer> <C-_>c :TCommentAs eruby_surround<CR>
  vmap <buffer> <C-_>- :TCommentAs eruby_surround_minus<CR>
  vmap <buffer> <C-_>= :TCommentAs eruby_surround_equality<CR>
endfunction
" erubyのときだけ設定を追加
au FileType eruby call SetErubyMapping2()
" phpのときだけ設定を追加
au FileType php nmap <buffer><C-_>c :TCommentAs php_surround<CR>
au FileType php vmap <buffer><C-_>c :TCommentAs php_surround<CR>

"----------------------------------------------------
" Gundo
"----------------------------------------------------
nnoremap <Leader>g :GundoToggle<CR>

"----------------------------------------------------
" TaskList
"----------------------------------------------------
nmap <Leader>T <plug>TaskList

"----------------------------------------------------
" unite
"----------------------------------------------------
nnoremap [unite] <Nop>
nmap U [unite]
nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
nnoremap <silent> [unite]r :<C-u>Unite register<CR>
nnoremap <silent> [unite]m :<C-u>Unite file_mru<CR>
nnoremap <silent> [unite]c :<C-u>Unite bookmark<CR>
nnoremap <silent> [unite]o :<C-u>Unite outline<CR>
nnoremap <silent> [unite]t :<C-u>Unite tab<CR>
nnoremap <silent> [unite]w :<C-u>Unite window<CR>

let s:hooks = neobundle#get_hooks("unite.vim")

function! s:hooks.on_source(bundle)
  " start unite in insert mode
  let g:unite_enable_start_insert = 1
  " use vimfiler to open directory
  call unite#custom_default_action("source/bookmark/directory", "vimfiler")
  call unite#custom_default_action("directory", "vimfiler")
  call unite#custom_default_action("directory_mru", "vimfiler")
  autocmd MyAutoCmd FileType unite call s:unite_settings()
  function! s:unite_settings()
    imap <buffer> <Esc><Esc> <Plug>(unite_exit)
    nmap <buffer> <Esc> <Plug>(unite_exit)
    nmap <buffer> <C-n> <Plug>(unite_select_next_line)
    nmap <buffer> <C-p> <Plug>(unite_select_previous_line)
  endfunction
endfunction

"----------------------------------------------------
" vimfiler
"----------------------------------------------------
nnoremap <Leader>e :VimFilerExplorer<CR>
" close vimfiler automatically when there are only vimfiler open
autocmd MyAutoCmd BufEnter * if (winnr('$') == 1 && &filetype ==# 'vimfiler') | q | endif

let s:hooks = neobundle#get_hooks("vimfiler")

let g:vimfiler_edit_action = 'tabopen'

function! s:hooks.on_source(bundle)
  let g:vimfiler_as_default_explorer = 1
  let g:vimfiler_enable_auto_cd = 1
  " .から始まるファイルおよび.pycで終わるファイルを不可視パターンに
  let g:vimfiler_ignore_pattern = "\%(^\..*\|\.pyc$\)"
  " vimfiler specific key mappings
  autocmd MyAutoCmd FileType vimfiler call s:vimfiler_settings()
  function! s:vimfiler_settings()
    " ^^ to go up
    nmap <buffer> ^^ <Plug>(vimfiler_switch_to_parent_directory)
    " use R to refresh
    nmap <buffer> R <Plug>(vimfiler_redraw_screen)
    " overwrite C-l
    nmap <buffer> <C-l> <C-w>l
  endfunction
endfunction

"----------------------------------------------------
" jedi-vim
"----------------------------------------------------
let s:hooks = neobundle#get_hooks("jedi-vim")

function! s:hooks.on_source(bundle)
  autocmd FileType python setlocal omnifunc=jedi#completions
  let g:jedi#completions_enabled = 0
  let g:jedi#auto_vim_configuration = 0
  if !exists('g:neocomplete#force_omni_input_patterns')
          let g:neocomplete#force_omni_input_patterns = {}
  endif
  let g:neocomplete#force_omni_input_patterns.python = '\h\w*\|[^. \t]\.\w*'
  " quickrunと被るため大文字に変更
  let g:jedi#rename_command = '<Leader>R'
endfunction

"----------------------------------------------------
" vim-quickrun
"----------------------------------------------------
nmap <Leader>r <Plug>(quickrun)
let s:hooks = neobundle#get_hooks("vim-quickrun")
function! s:hooks.on_source(bundle)
  let g:quickrun_config = {
      \ "*": {"runner": "vimproc"},
      \ }
endfunction

"----------------------------------------------------
" vim-hybrid
"----------------------------------------------------
""colorscheme hybrid
