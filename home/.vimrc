" {{{
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

augroup Vimrc
  autocmd!
augroup END
" }}}

" {{{
" neobundle
if !isdirectory(s:neobundle_dir)
  if executable('git')
    exec '!mkdir -p '.$BUNDLE.' && git clone https://github.com/Shougo/neobundle.vim '.s:neobundle_dir
  endif
else
if has('vim_starting')
  execute 'set runtimepath+='.s:neobundle_dir
endif
call neobundle#rc($BUNDLE)
NeoBundleFetch 'Shougo/neobundle.vim'
  nnoremap <silent> BB :<C-u>Unite neobundle/update -log -no-start-insert<CR>

" LightLine
NeoBundle 'itchyny/lightline.vim'
" let g:lightline = {
"       \ 'colorscheme': 'solarized',
"       \ 'active': {
"       \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
"       \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
"       \ },
"       \ 'component_function': {
"       \   'fugitive': 'MyFugitive',
"       \   'filename': 'MyFilename',
"       \   'fileformat': 'MyFileformat',
"       \   'filetype': 'MyFiletype',
"       \   'fileencoding': 'MyFileencoding',
"       \   'mode': 'MyMode',
"       \   'ctrlpmark': 'CtrlPMark',
"       \ },
"       \ 'component_expand': {
"       \   'syntastic': 'SyntasticStatuslineFlag',
"       \ },
"       \ 'component_type': {
"       \   'syntastic': 'error',
"       \ },
"       \ 'separator': { 'left': '⮀', 'right': '⮂' },
"       \ 'subseparator': { 'left': '⮁', 'right': '⮃' }
"       \ }
let g:lightline = {
      \ 'colorscheme': 'solarized'
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

" Complement
NeoBundle 'Shougo/neocomplete.vim', {'disabled': !(has('lua') && v:version > 703)}
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

  " Recommended key-mappings.
  " <CR>: close popup and save indent.
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
   return neocomplete#smart_close_popup() . "\<CR>"
   " For no inserting <CR> key.
   "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
  endfunction
  " <TAB>: completion.
  inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><C-y>  neocomplete#close_popup()
  inoremap <expr><C-e>  neocomplete#cancel_popup()
  " Close popup by <Space>.
  "inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

  " For cursor moving in insert mode(Not recommended)
  "inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
  "inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
  "inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
  "inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
  " Or set this.
  "let g:neocomplete#enable_cursor_hold_i = 1
  " Or set this.
  "let g:neocomplete#enable_insert_char_pre = 1

  " AutoComplPop like behavior.
  "let g:neocomplete#enable_auto_select = 1

  " Shell like behavior(not recommended).
  "set completeopt+=longest
  "let g:neocomplete#enable_auto_select = 1
  "let g:neocomplete#disable_auto_complete = 1
  "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

  " Enable omni completion.
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP

  " Enable heavy omni completion.
  if !exists('g:neocomplete#sources#omni#input_patterns')
   let g:neocomplete#sources#omni#input_patterns = {}
  endif
  let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
  let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
  let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

  " For perlomni.vim setting.
  " https://github.com/c9s/perlomni.vim
  let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

" syntax
NeoBundle 'scrooloose/syntastic'
NeoBundle 'mattn/emmet-vim'
  let g:user_emmet_mode = 'iv'
    let g:user_emmet_leader_key = '<C-Y>'
    let g:use_emmet_complete_tag = 1
    let g:user_emmet_settings = {
          \ 'lang' : 'ja',
          \ 'html' : {
          \   'filters' : 'html',
          \ },
          \ 'css' : {
          \   'filters' : 'fc',
          \ },
          \ 'php' : {
          \   'extends' : 'html',
          \   'filters' : 'html',
          \ },
          \}
    augroup EmmitVim
      autocmd!
      autocmd FileType * let g:user_emmet_settings.indentation = '               '[:&tabstop]
    augroup END
NeoBundle 'hail2u/vim-css3-syntax'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'othree/html5.vim'
" NeoBundle 'taichouchou2/html5.vim'
"   syn keyword htmlTagName contained article aside audio bb canvas command
"   syn keyword htmlTagName contained datalist details dialog embed figure
"   syn keyword htmlTagName contained header hgroup keygen mark meter nav output
"   syn keyword htmlTagName contained progress time ruby rt rp section time
"   syn keyword htmlTagName contained source figcaption
"   syn keyword htmlArg contained autofocus autocomplete placeholder min max
"   syn keyword htmlArg contained contenteditable contextmenu draggable hidden
"   syn keyword htmlArg contained itemprop list sandbox subject spellcheck
"   syn keyword htmlArg contained novalidate seamless pattern formtarget
"   syn keyword htmlArg contained formaction formenctype formmethod
"   syn keyword htmlArg contained sizes scoped async reversed sandbox srcdoc
"   syn keyword htmlArg contained hidden role
"   syn match   htmlArg "\<\(aria-[\-a-zA-Z0-9_]\+\)=" contained
"   syn match   htmlArg contained "\s*data-[-a-zA-Z0-9_]\+"
NeoBundle 'jelera/vim-javascript-syntax'
NeoBundle 'felixge/vim-nodejs-errorformat'
NeoBundle 'moll/vim-node'
NeoBundle 'myhere/vim-nodejs-complete'
NeoBundle 'cakebaker/scss-syntax.vim'

" Utilities
NeoBundle 'open-browser.vim'
  nmap <Leader>o <Plug>(openbrowser-open)
  vmap <Leader>o <Plug>(openbrowser-open)
  nnoremap <Leader>g :<C-u>OpenBrowserSearch<Space><C-r><C-w><Enter>

" NeoBundle 'Shougo/vimfiler.vim'
" nnoremap <leader>e :VimFilerExplore -split -winwidth=30 -find -no-quit<Cr>
" let g:vimfiler_edit_action = 'tabopen'

NeoBundle 'scrooloose/nerdtree'
NeoBundle 'jistr/vim-nerdtree-tabs'
  " 引数なしで実行したとき、NERDTreeを実行する
  let file_name = expand("%:p")
  if has('vim_starting') &&  file_name == ""
      autocmd VimEnter * call ExecuteNERDTree()
  endif
  " カーソルが外れているときは自動的にnerdtreeを隠す
  function! ExecuteNERDTree()
      "b:nerdstatus = 1 : NERDTree 表示中
      "b:nerdstatus = 2 : NERDTree 非表示中
      if !exists('g:nerdstatus')
          execute 'NERDTree ./'
          let g:windowWidth = winwidth(winnr())
          let g:nerdtreebuf = bufnr('')
          let g:nerdstatus = 1 
      elseif g:nerdstatus == 1 
          execute 'wincmd t'
          execute 'vertical resize' 0 
          execute 'wincmd p'
          let g:nerdstatus = 2 
      elseif g:nerdstatus == 2 
          execute 'wincmd t'
          execute 'vertical resize' g:windowWidth
          let g:nerdstatus = 1 
      endif
  endfunction
  noremap <c-e> :<c-u>:call ExecuteNERDTree()<cr>

NeoBundle 'glsl.vim'
  autocmd BufNewFile,BufRead *.frag,*.vert,*.fp,*.vp,*.glsl
    \ set filetype=glsl

NeoBundle 'mattn/webapi-vim'
NeoBundle 'tell-k/vim-browsereload-mac'
NeoBundle 'jeyb/vim-jst'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'slim-template/vim-slim'
NeoBundle 'tpope/vim-rails'
NeoBundle 'sophacles/vim-processing'
NeoBundle 'vim-scripts/sudo.vim'
NeoBundle 'digitaltoad/vim-jade'

NeoBundle 'osyo-manga/vim-over'
"" vim-over {{{
" vim-overの起動
nnoremap <silent> <Leader>m :OverCommandLine<CR>
" カーソル下の単語をハイライト付きで置換
nnoremap sub :OverCommandLine<CR>%s/<C-r><C-w>//g<Left><Left>
" コピーした文字列をハイライト付きで置換
 nnoremap subp y:OverCommandLine<CR>%s!<C-r>=substitute(@0, '!', '\\!', 'g')<CR>!!gI<Left><Left><Left>
" }}}

NeoBundle 'fuenor/qfixhowm.git'
" {{{
"QFixHowmキーマップ
let QFixHowm_Key = 'g'

""howm_dirはファイルを保存したいディレクトリを設定。
let howm_dir             = '~/ownCloud/workspace/memo'
let howm_filename        = '%Y/%m/%Y-%m-%d-%H%M%S.md'
let howm_fileencoding    = 'utf-8'
let howm_fileformat      = 'unix'
" ファイルタイプをmarkdownにする
let QFixHowm_FileType = 'markdown'
" タイトル記号
let QFixHowm_Title = '#'
" タイトル行検索正規表現の辞書を初期化
let QFixMRU_Title = {}
" MRUでタイトル行とみなす正規表現(Vimの正規表現で指定)
let QFixMRU_Title['mkd'] = '^###[^#]'
" grepでタイトル行とみなす正規表現(使用するgrepによっては変更する必要があります)
let QFixMRU_Title['mkd_regxp'] = '^###[^#]'

let QFixHowm_DiaryFile = 'diary/%Y/%m/%Y-%m-%d-000000.md'
" }}}


NeoBundle 'kana/vim-submode'

" Indent
NeoBundle 'Yggdroot/indentLine'
let g:indentLine_faster = 1
nmap <silent><Leader>i :<C-u>IndentLinesToggle<CR>

" Text align
NeoBundle 'junegunn/vim-easy-align'

NeoBundle 'mhinz/vim-startify'

" markdown
NeoBundle 'godlygeek/tabular'
NeoBundle 'plasticboy/vim-markdown'

" grunt
NeoBundle 'mklabs/grunt.vim'

" less
NeoBundle 'groenewege/vim-less'

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

endif
NeoBundleCheck
" }}}

" Setting {{{
filetype plugin indent on
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
 "Search
 set incsearch
 set ignorecase
 set smartcase
 set wrapscan
 set nohlsearch
 "Input
 set cindent
 set shiftwidth=4
 set tabstop=2
 set expandtab
 set softtabstop=4
 set backspace=indent,eol,start
 set whichwrap=b,s,h,l,<,>,[,]
 set clipboard=unnamed
 vnoremap <silent> > >gv
 vnoremap <silent> < <gv
 "Display
 set number
 set title
 set showcmd
 set ruler
 set list
 set showmatch
 set matchtime=3
"  au BufRead,BufNewFile *.scss set filetype=sass
 au BufRead,BufNewFile *.slim set filetype=slim
 au BufNewFile,BufRead *.ejs.* set filetype=jst
 au BufNewFile,BufRead *.ejs set filetype=jst
 "補完
 set wildmenu
 set wildchar=<tab>
 set history=1000
 set wildmode=list:longest,full
 set statusline=%F%r%h%=
 set autoindent
 set smartindent
 set shiftwidth=2
 set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
 set visualbell
 set vb t_vb=
 set clipboard+=unnamed

"  "ステータスラインの設定 分けて書いた方が見易いと思う
 set laststatus=2
"  set statusline=%n\:%y
"  set statusline+=[%{(&fenc!=''?&fenc:&enc)}]
"  set statusline+=[%{Getff()}]
"  set statusline+=%m%r\ %F%=[%l/%L]
"  function! Getff()
"      if &ff == 'unix'
"          return 'LF'
"      elseif &ff == 'dos'
"          return 'CR+LF'
"      elseif &ff == 'mac'
"          return 'CR'
"      else
"          return '?'
"      endif
"   endfunction

 "swapファイル
 set directory=/tmp

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
set showtabline=2 " 常にタブラインを表示
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

" vim-submode
nnoremap s <Nop>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap sn gt
nnoremap sp gT
nnoremap sr <C-w>r
nnoremap s= <C-w>=
nnoremap sw <C-w>w
nnoremap so <C-w>_<C-w>|
nnoremap sO <C-w>=
nnoremap sN :<C-u>bn<CR>
nnoremap sP :<C-u>bp<CR>
nnoremap st :<C-u>tabnew<CR>
nnoremap sT :<C-u>Unite tab<CR>
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap sq :<C-u>q<CR>
nnoremap sQ :<C-u>bd<CR>
nnoremap sb :<C-u>Unite buffer_tab -buffer-name=file<CR>
nnoremap sB :<C-u>Unite buffer -buffer-name=file<CR>

call submode#enter_with('bufmove', 'n', '', 's>', '<C-w>>')
call submode#enter_with('bufmove', 'n', '', 's<', '<C-w><')
call submode#enter_with('bufmove', 'n', '', 's+', '<C-w>+')
call submode#enter_with('bufmove', 'n', '', 's-', '<C-w>-')
call submode#map('bufmove', 'n', '', '>', '<C-w>>')
call submode#map('bufmove', 'n', '', '<', '<C-w><')
call submode#map('bufmove', 'n', '', '+', '<C-w>+')
call submode#map('bufmove', 'n', '', '-', '<C-w>-')

