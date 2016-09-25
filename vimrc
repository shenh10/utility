set nocompatible               " be iMproved
filetype off                   " required!

filetype plugin indent on     " required!

" airline config
let g:airline_symbols = {}
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#tagbar#flags = 's'
let g:airline#extensions#whitespace#enabled = 0

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" indentLine config
let g:indentLine_fileType = ['c', 'cpp']
let g:indentLine_char = '⦙'
let g:indentLine_noConcealCursor = 1

" tagbar config
let g:tagbar_left = 1
let g:airline#extensions#syntastic#enabled = 1
let g:tagbar_expand = 1
let g:tagbar_iconchars = ['▸', '▾']
nnoremap <silent> <†> :TagbarToggle<CR>

" clang complete config
let g:clang_complete_copen = 1
let g:clang_complete_quickfix = 1
let g:clang_close_preview = 1

" snipmate config
"imap <S-Space> <Plug>snipMateNextOrTrigger
"let g:acp_behaviorSnipmateLength = 1


syntax on
set number
set numberwidth=3
set ruler
set ai
set cindent
set shiftwidth=4
set smartindent
"set textwidth=79
"filetype indent plugin on
set nocp
"set mouse=a
set hlsearch
set ignorecase
set smartcase
set showmatch
set showcmd
set title
set wildmenu
set incsearch

set bs=2
set ts=4
set sw=4
set sts=4
"set tw=80
set et

set scrolloff=2
set expandtab
set viminfo='20,\"500   
set hidden
set history=50
"set formatoptions=tc
set winwidth=82

hi Search ctermbg=2
hi Visual ctermbg=4
hi Pmenu ctermbg=22
hi PmenuSel ctermbg=2
hi MatchParen ctermbg=22
hi TabLineSel cterm=bold,reverse
hi TabLineFill cterm=bold
hi Tabline ctermbg=22
hi LineNr ctermfg=235
hi Folded ctermfg=22 ctermbg=0

autocmd InsertEnter * :hi LineNr guifg=#1265fb
"autocmd InsertEnter * :hi CursorLineNr guifg=Blue
autocmd InsertLeave * :hi LineNr guifg=Yellow
"autocmd InsertEnter * :hi CursorLineNr guifg=Blue

inoremap kj <Esc>

" Navigate up and down without moving cursor
map ∆ <C-e>
map ˚ <C-y>
inoremap <silent> ∆ <Esc><C-e>a
inoremap <silent> ˚ <Esc><C-y>a

" Navigate between tabs
map ¬ gt
map ˙ gT
inoremap <silent> ¬ <Esc>gt
inoremap <silent> ˙ <Esc>gT

" Easymotion Mapping
nmap <Space> \\w
nmap <BS> \\b

" automatically complete closing braces
inoremap {<CR>  {<CR>}<Esc>O

highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

" Better command-line completion
set wildmenu

" Show partial commands in the last line of the screen
set showcmd

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline

" always display the status line, even if only one window is displayed
set laststatus=2

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Enable use of the mouse for all modes
"set mouse=a

" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=1

" have the Visual selection automatically copied to the clipboard
set go+=a



" Highlight all instances of word under cursor, when idle.
" Useful when studying strange source code.
" Type z/ to toggle highlighting on/off.
nnoremap z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
function! AutoHighlightToggle()
  let @/ = ''
  if exists('#auto_highlight')
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime=4000
    echo 'Highlight current word: off'
    return 0
  else
    augroup auto_highlight
      au!
      au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
    augroup end
    setl updatetime=500
    echo 'Highlight current word: ON'
    return 1
  endif
endfunction


function! CFoldLevel(lnum)
  let line = getline(a:lnum)
  if line =~ '^/\*'
    return '>1' " A new fold of level 1 starts here.
  else
    return '1' " This line has a foldlevel of 1.
  endif
endfunction

function! CFoldText()
  " Look through all of the folded text for the function signature.
  let signature = ''
  let i = v:foldstart
  while signature == '' && i < v:foldend
    let line = getline(i)
    if line =~ '\w\+(.*)$'
      let signature = line
    endif 
    let i = i + 1
  endwhile

  " Return what the fold should show when folded.
  return '{...}'
endfunction

function! CFold()               
  set foldenable
  set foldlevel=0   
  set foldmethod=expr
  set foldexpr=CFoldLevel(v:lnum)
  set foldtext=CFoldText()
  set foldnestmax=1
endfunction

function! RemoveWidthLimitWarnigns()
    silent! call matchdelete(4)
endfunction
function! InsertWidthLimitWarnings()
    call RemoveWidthLimitWarnigns()
    call matchadd("ErrorMsg", "\\%>79v.\\+", 10, 4)
endfunction


set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif

autocmd InsertEnter * :let @/ =''


" has bug with tagbar
nnoremap <S-Up> :call MaximizeToggle ()<CR>
nnoremap <S-Down> :call MaximizeToggle ()<CR>

function! MaximizeToggle()
  if exists("s:maximize_session")
    :TagbarClose
    exec "source " . s:maximize_session
    call delete(s:maximize_session)
    unlet s:maximize_session
    let &hidden=s:maximize_hidden_save
    unlet s:maximize_hidden_save
  else
    let s:maximize_hidden_save = &hidden
    let s:maximize_session = tempname()
    set hidden
    exec "mksession! " . s:maximize_session
    only
  endif
endfunction

colorscheme ron
set softtabstop=4
set cul                                      

set wrap
set paste
autocmd BufNewFile,BufRead *.json set ft=javascript

" plugins
let Tlist_Show_One_File = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_File_Fold_Auto_Close = 1
let Tlist_GainFocus_On_ToggleOpen = 1
