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
 set tabstop=4
 set expandtab
 set softtabstop=4
 set backspace=indent,eol,start
 set whichwrap=b,s,h,l,<,>,[,]
 set clipboard=unnamed
 vnoremap <silent> > >gv
 vnoremap <silent> < <gv
 "Display
 syntax on
 set number
 set title
 set showcmd
 set ruler
 set list
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
 set statusline=%F%r%h%=
 set autoindent
 set smartindent
 set shiftwidth=2
 set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
 set visualbell
 set vb t_vb=
 set clipboard+=unnamed

 "ステータスラインの設定 分けて書いた方が見易いと思う
 set laststatus=2
 set statusline=%n\:%y
 set statusline+=[%{(&fenc!=''?&fenc:&enc)}]
 set statusline+=[%{Getff()}]
 set statusline+=%m%r\ %F%=[%l/%L]
 function! Getff()
     if &ff == 'unix'
         return 'LF'
     elseif &ff == 'dos'
         return 'CR+LF'
     elseif &ff == 'mac'
         return 'CR'
     else
         return '?'
     endif
  endfunction

 "swapファイル
 set directory=/tmp

"NeoBundle
set nocompatible
filetype on

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
  call neobundle#rc(expand('~/.vim/bundle'))
endif

" ここにインストールしたいプラグインのリストを書く
NeoBundle 'Shougo/unite.vim'
NeoBundle "Shougo/neocomplete.vim"
NeoBundle "Shougo/vimfiler.vim"
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'h1mesuke/unite-outline'
NeoBundle 'Align'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'open-browser.vim'
NeoBundle 'mattn/webapi-vim'
NeoBundle 'tell-k/vim-browsereload-mac'
NeoBundle 'hail2u/vim-css3-syntax'
NeoBundle 'taichouchou2/html5.vim'
NeoBundle 'jeyb/vim-jst'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'slim-template/vim-slim'
NeoBundle 'cakebaker/scss-syntax.vim'
NeoBundle 'tpope/vim-rails'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'sophacles/vim-processing'
NeoBundle 'vim-scripts/sudo.vim'
NeoBundle 'digitaltoad/vim-jade'
NeoBundle 'tpope/vim-surround'

" Javascript
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'jelera/vim-javascript-syntax'

" Node.js
NeoBundle 'felixge/vim-nodejs-errorformat'
NeoBundle 'moll/vim-node'
NeoBundle 'myhere/vim-nodejs-complete'

NeoBundle 'scrooloose/syntastic'
NeoBundle 'scrooloose/nerdtree'

NeoBundle 'jistr/vim-nerdtree-tabs'


filetype plugin on
filetype indent on

NeoBundleCheck

 "neocomplete
 "Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
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
 

" emmet-vim
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


" open-browser.vim
" カーソル下のURLをブラウザで開く
nmap <Leader>o <Plug>(openbrowser-open)
vmap <Leader>o <Plug>(openbrowser-open)
" ググる
nnoremap <Leader>g :<C-u>OpenBrowserSearch<Space><C-r><C-w><Enter>

" vim-css3-syntax, vim-javascript, html5.vim
" HTML 5 tags
syn keyword htmlTagName contained article aside audio bb canvas command
syn keyword htmlTagName contained datalist details dialog embed figure
syn keyword htmlTagName contained header hgroup keygen mark meter nav output
syn keyword htmlTagName contained progress time ruby rt rp section time
syn keyword htmlTagName contained source figcaption
syn keyword htmlArg contained autofocus autocomplete placeholder min max
syn keyword htmlArg contained contenteditable contextmenu draggable hidden
syn keyword htmlArg contained itemprop list sandbox subject spellcheck
syn keyword htmlArg contained novalidate seamless pattern formtarget
syn keyword htmlArg contained formaction formenctype formmethod
syn keyword htmlArg contained sizes scoped async reversed sandbox srcdoc
syn keyword htmlArg contained hidden role
syn match   htmlArg "\<\(aria-[\-a-zA-Z0-9_]\+\)=" contained
syn match   htmlArg contained "\s*data-[-a-zA-Z0-9_]\+"

" NERDTree
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
endfunction "}}}
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

"lightline
let g:lightline = {
        \ 'colorscheme': 'wombat',
        \ 'mode_map': {'c': 'NORMAL'},
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
        \ },
        \ 'component_function': {
        \   'modified': 'MyModified',
        \   'readonly': 'MyReadonly',
        \   'fugitive': 'MyFugitive',
        \   'filename': 'MyFilename',
        \   'fileformat': 'MyFileformat',
        \   'filetype': 'MyFiletype',
        \   'fileencoding': 'MyFileencoding',
        \   'mode': 'MyMode'
        \ }
        \ }

function! MyModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
endfunction

function! MyFilename()
  return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  try
    if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
      return fugitive#head()
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
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction
