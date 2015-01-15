" release autogroup in MyAutoCmd
augroup MyAutoCmd
  autocmd!
augroup END

filetype off
scriptencoding utf-8
if !executable(&shell) | set shell=sh | endif
let s:iswin = has('win16') || has('win32') || has('win64')
let s:ismac = !s:iswin && !has('win32unix') && (has('mac') || has('macunix') || has('guimacvim'))
let s:fancy = s:ismac && has('multi_byte')
let s:nosudo = $SUDO_USER == ''
let $VIM = expand('~/.vim')
let $CACHE = $VIM.'/.cache'
let $BUNDLE = $VIM.'/bundle'
let s:neobundle_dir = $BUNDLE.'/neobundle.vim'

let mapleader = ","
" ,のデフォルトの機能は、\で使えるように退避
noremap \  ,

syntax enable
"Encode
 set ffs=unix,dos,mac
 set encoding=utf-8
 set fileencodings=utf-8,ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932
 set termencoding=utf-8
 if exists('&ambiwidth')
 set ambiwidth=double
 endif
 "File
 set hidden
 set autoread
 " 検索関係
  set wrapscan
  set ignorecase          " 大文字小文字を区別しない
  set smartcase           " 検索文字に大文字がある場合は大文字小文字を区別
  set incsearch           " インクリメンタルサーチ
  set hlsearch            " 検索マッチテキストをハイライト
  " バックスラッシュやクエスチョンを状況に合わせ自動的にエスケープ
  cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
  cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

 " 編集関係
  set shiftround          " '<'や'>'でインデントする際に'shiftwidth'の倍数に丸める
  set infercase           " 補完時に大文字小文字を区別しない
  set virtualedit=all     " カーソルを文字が存在しない部分でも動けるようにする
  set hidden              " バッファを閉じる代わりに隠す（Undo履歴を残すため）
  set switchbuf=useopen   " 新しく開く代わりにすでに開いてあるバッファを開く
  set showmatch           " 対応する括弧などをハイライト表示する
  set matchtime=3         " 対応括弧のハイライト表示を3秒にする
  " 対応括弧に'<'と'>'のペアを追加
  set matchpairs& matchpairs+=<:>
  " バックスペースでなんでも消せるようにする
  set backspace=indent,eol,start
  " クリップボードをデフォルトのレジスタとして指定。後にYankRingを使うので
  " 'unnamedplus'が存在しているかどうかで設定を分ける必要がある
  if has('unnamedplus')
      set clipboard& clipboard+=unnamedplus,unnamed 
  else
      set clipboard& clipboard+=unnamed
  endif
  " Swapファイル？Backupファイル？前時代的すぎ
  " なので全て無効化する
  set nowritebackup
  set nobackup
  set noswapfile 
  "
  set cindent
  set shiftwidth=4
  set tabstop=2
  set expandtab
  set softtabstop=4
  set whichwrap=b,s,h,l,<,>,[,]
  vnoremap <silent> > >gv
  vnoremap <silent> < <gv

  "表示関係
  set laststatus=2        " ステータスライン2行
  set cursorline          " カーソルを表示
  highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE
  highlight CursorLine gui=underline guifg=NONE guibg=NONE
  set list                " 不可視文字の可視化
  set number              " 行番号の表示
  set wrap                " 長いテキストの折り返し
  set textwidth=0         " 自動的に改行が入るのを無効化
  set colorcolumn=80      " その代わり80文字目にラインを入れる
  " 前時代的スクリーンベルを無効化
  set t_vb=
  set novisualbell
  " デフォルト不可視文字は美しくないのでUnicodeで綺麗に
  set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:↲
  "
  set title
  set showcmd
  set ruler
  set showmatch
  set matchtime=3
  au BufRead,BufNewFile *.scss set filetype=sass
  au BufRead,BufNewFile *.slim set filetype=slim
  au BufNewFile,BufRead *.ejs.* set filetype=jst
  au BufNewFile,BufRead *.ejs set filetype=jst
 "補完
 set wildmenu
 set wildchar=<tab>
 set history=1000
 set wildmode=list:longest,full
 set smartindent
 set shiftwidth=2

  "マクロおよびキー設定
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
  nnoremap j gj
  nnoremap k gk
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
  " make, grep などのコマンド後に自動的にQuickFixを開く
  autocmd MyAutoCmd QuickfixCmdPost make,grep,grepadd,vimgrep copen
  " QuickFixおよびHelpでは q でバッファを閉じる
  autocmd MyAutoCmd FileType help,qf nnoremap <buffer> q <C-w>c
  " w!! でスーパーユーザーとして保存（sudoが使える環境限定）
  cmap w!! w !sudo tee > /dev/null %
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
  " }}}

" Neobundle
let s:noplugin = 0
let s:bundle_root = expand('~/.vim/bundle')
let s:neobundle_root = s:bundle_root . '/neobundle.vim'
if !isdirectory(s:neobundle_root) || v:version < 702
    " NeoBundleが存在しない、もしくはVimのバージョンが古い場合はプラグインを一切
    " 読み込まない
    let s:noplugin = 1
else
    " NeoBundleを'runtimepath'に追加し初期化を行う
    if has('vim_starting')
        execute "set runtimepath+=" . s:neobundle_root
    endif
    call neobundle#rc(s:bundle_root)

    " NeoBundle自身をNeoBundleで管理させる
    NeoBundleFetch 'Shougo/neobundle.vim'

    " 非同期通信を可能にする
    " 'build'が指定されているのでインストール時に自動的に
    " 指定されたコマンドが実行され vimproc がコンパイルされる
    NeoBundle "Shougo/vimproc", {
        \ "build": {
        \   "windows"   : "make -f make_mingw32.mak",
        \   "cygwin"    : "make -f make_cygwin.mak",
        \   "mac"       : "make -f make_mac.mak",
        \   "unix"      : "make -f make_unix.mak",
        \ }}

    " (ry
      " LightLine
      NeoBundle 'itchyny/lightline.vim'
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

      NeoBundle 'Yggdroot/indentLine'
      
      let g:indentLine_faster = 1
      nmap <silent><Leader>i :<C-u>IndentLinesToggle<CR>
      " Text align
      NeoBundleLazy 'junegunn/vim-easy-align', { 'autoload': {
            \ 'commands' : ['EasyAlign'] }}

      " コメントアウト系プラグイン
      NeoBundle 'tomtom/tcomment_vim'
      " tcommentで使用する形式を追加
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
      " caw.vim.git
      " NeoBundle "tyru/caw.vim.git"
      " nmap <C-K> <Plug>(caw:i:toggle)
      " vmap <C-K> <Plug>(caw:i:toggle)
      
      NeoBundle 'scrooloose/syntastic'

    if has('lua') && v:version >= 703 && has('patch885')
        NeoBundleLazy "Shougo/neocomplete.vim", {
            \ "autoload": {
            \   "insert": 1,
            \ }}
        let g:neocomplete#enable_at_startup = 1
        let s:hooks = neobundle#get_hooks("neocomplete.vim")
        function! s:hooks.on_source(bundle)
            let g:acp_enableAtStartup = 0
            let g:neocomplet#enable_smart_case = 1

            " NeoCompleteを有効化
            NeoCompleteEnable
        endfunction
    else
        NeoBundleLazy "Shougo/neocomplcache.vim", {
            \ "autoload": {
            \   "insert": 1,
            \ }}
        let g:neocomplcache_enable_at_startup = 1
        let s:hooks = neobundle#get_hooks("neocomplcache.vim")
        function! s:hooks.on_source(bundle)
            let g:acp_enableAtStartup = 0
            let g:neocomplcache_enable_smart_case = 1
            " NeoComplCacheを有効化
            " NeoComplCacheEnable 
        endfunction
    endif
    inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

      NeoBundleLazy 'Shougo/neosnippet.vim', {
          \ "autoload": {"insert": 1}}
      " 'GundoToggle'が呼ばれるまでロードしない
      NeoBundleLazy "sjl/gundo.vim", {
      \ "autoload": {
      \   "commands": ['GundoToggle'],
      \}}
      nnoremap <Leader>g :GundoToggle<CR>

      " '<Plug>TaskList'というマッピングが呼ばれるまでロードしない
      NeoBundleLazy "vim-scripts/TaskList.vim", {
      \ "autoload": {
      \   "mappings": ['<Plug>TaskList'],
      \}}
      nmap <Leader>T <plug>TaskList

      " HTMLが開かれるまでロードしない
      NeoBundleLazy 'mattn/emmet-vim', {
          \ "autoload": {"filetypes": ['html', 'php']}}

      NeoBundleLazy 'hail2u/vim-css3-syntax', {
            \ "autoload": {"filetypes": ['css']}}

      NeoBundleLazy 'taichouchou2/html5.vim', {
            \ "autoload": {"filetypes": ['html', 'php']}}

      NeoBundleLazy 'taichouchou2/vim-javascript', {
            \ "autoload": {"filetypes": ['js']}}

      NeoBundle 'cakebaker/scss-syntax.vim'

    NeoBundleLazy "Shougo/unite.vim", {
          \ "autoload": {
          \   "commands": ["Unite", "UniteWithBufferDir"]
          \ }}
    NeoBundleLazy 'h1mesuke/unite-outline', {
          \ "autoload": {
          \   "unite_sources": ["outline"],
          \ }}
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

  NeoBundleLazy "Shougo/vimfiler", {
        \ "depends": ["Shougo/unite.vim"],
        \ "autoload": {
        \   "commands": ["VimFilerTab", "VimFiler", "VimFilerExplorer"],
        \   "mappings": ['<Plug>(vimfiler_switch)'],
        \   "explorer": 1,
        \ }}
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

  NeoBundle 'tpope/vim-surround'
  NeoBundle 'vim-scripts/Align'
  NeoBundle 'vim-scripts/YankRing.vim'



    " インストールされていないプラグインのチェックおよびダウンロード
    NeoBundleCheck
endif
filetype plugin indent on
