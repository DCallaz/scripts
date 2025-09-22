" misc {{{
set updatetime=100
set hidden
set timeoutlen=500
" }}}

" vim-plug {{{
call plug#begin('~/.vim/plugged')
Plug 'valloric/youcompleteme'
Plug 'ryanpcmcquen/fix-vim-pasting'
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'valloric/vim-indent-guides'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdtree'
Plug 'dense-analysis/ale'
Plug 'gsiano/vmux-clipboard'
Plug 'jrozner/vim-antlr'
Plug 'vim-latex/vim-latex'
Plug 'mbbill/undotree'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
call plug#end()
" }}}

" Colors {{{
"GRUVBOX
" set termguicolors
" let g:gruvbox_italic=1
colorscheme gruvbox
set background=dark

augroup my_colours
  autocmd!
  autocmd ColorScheme gruvbox hi SpellBad cterm=reverse
augroup END

"MONOKAI DARK
"colorscheme monokai

"SPACE-VIM-DARK
"colorscheme space-vim-dark
"hi Comment cterm=italic
" }}}

" FUNCTIONS {{{
function! <SID>StripTrailingWhiteSpaces()
  "prep: save last searched
  let _s=@/
  let l = line(".")
  let c = col(".")
  " remove trailing
  let c = col(".")
  %s/\s\+$//e
  " restore hostory
  let @/=_s
  call cursor(l, c)
endfunction

function Reorder()
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Get the comment string
  let comment = split(&commentstring, '%s')
  if len(comment) > 0
    let com = trim(comment[0])
  else
    let com = "#"
  endif
  let reg = '^\s*\([^\\ \t{}'.com.']\|\\\(begin\)\@!\)'

  call <SID>StripTrailingWhiteSpaces()
  let len = strwidth(getline("."))
  " Merge if current line < 80 and next line is not comment or blank
  if len < 80 && getline(line(".")+1) =~ reg
    execute "normal M"
  endif
  let len = strwidth(getline("."))
  while len > 80
    execute "normal 80|"
    if (Break() == 0)
      call search("\\s", 'b', line("."))
      call Break()
    endif

    if getline(line(".")+1) !~ reg
      break
    endif
    call <SID>StripTrailingWhiteSpaces()
    execute "normal M"
    let len = strwidth(getline("."))
  endwhile

  let @/=_s
  call cursor(l, c)
endfunction

function Break()
  let char = strcharpart(getline('.')[col('.') - 1:], 0, 1)
  let line = line(".")
  if !(char =~ '\s')
    if !(search("\\s", '', line))
      return 0
    endif
  endif
  execute "normal i\<CR>\<Esc>"
  return 1
endfunction

function Merge()
  " Merge lines normally
  execute "normal! J"
  let curr = getline('.')[col('.') - 1]
  let next = getline('.')[col('.')]
  " Check if extra space was added
  if (curr =~ '\s') && (next =~ '\s')
    execute "normal! x"
  endif
endfunction

function _Comment()
  let l = line(".")
  let c = col(".")
  let line=getline('.')
  let ext = expand('%:e')

  let comment = split(&commentstring, '%s')
  if len(comment) > 0
    let com = trim(comment[0])
  else
    let com = "#"
  endif
  let len = strlen(com)

  if line =~ '^\s*' . com
    "echo "Found comment"
    execute l . 's@^\(\s*\)\M' . com . '\m\( \(\s\+\)\@!\)\?@\1@'
    call cursor(l, c-len)
  else
    "echo "Comment not found"
    if line =~ '^\s*$'
      execute "normal _i" . com
    else
      execute "normal _i" . com . " "
    endif
    call cursor(l, c+len)
  endif
endfunction

function Comment() range
  " Get the comment string
  let comment = split(&commentstring, '%s')
  if len(comment) > 0
    let com = trim(comment[0])
  else
    let com = "#"
  endif
  let len = strlen(com)

  " Check if comment/uncomment and get lowest indent
  let type = "uncomment"
  let indent = match(getline(a:firstline),'\S\|^\s*$')+1
  for l in range(a:firstline, a:lastline)
    let line = getline(l)
    " If any line does not contain a comment, then comment, otherwise uncomment
    if line !~ '^\s*' . com
      let type = "comment"
    endif
    let indent = min([indent, match(getline(l),'\S\|^\s*$')+1])
  endfor

  " Comment/uncomment all lines
  if type ==? "comment"
    " comment the block
    for l in range(a:firstline, a:lastline)
      " first set the indent level
      silent call cursor(l, indent)
      let line = getline(l)
      " then comment the block
      if line =~ '^\s*$'
        silent execute "normal i" . com
      else
        silent execute "normal i" . com . " "
      endif
    endfor
  else
    " uncomment the block
    silent execute a:firstline . ',' . a:lastline . 's@^\(\s*\)\M' . com . '\m\( \(\s\+\)\@!\)\?@\1@'
  endif
endfunction

function Controlc()
  let extension = expand('%:e')
  if extension == "md"
    :execute "silent !mark -s %" | redraw!
  elseif extension == "tex"
    :execute "silent !pdftex %" | redraw!
  else
    :!mmake
  endif
endfunction

function _AleFix()
  let l = line(".")
  let c = col(".")
  let line=getline('.')
  normal! gvy
  vs tmp
  normal! pggdd
  ALEFix black
  execute "normal! ggVGy:q!\<CR>gvp"
endfunc

function Format_ALE()
  echo v:lnum v:count
  return 0
endfunc

function ToggleFlake8()
  if (exists("b:ale_linters.python") && index(b:ale_linters.python, 'flake8') != -1)
    call remove(b:ale_linters.python, index(b:ale_linters.python, 'flake8'))
  else
    if (!exists("b:ale_linters"))
      let b:ale_linters = {'python': []}
    endif
    if (!exists("b:ale_linters.python"))
      let b:ale_linters.python = []
    endif
    if (index(b:ale_linters.python, 'flake8') == -1)
      call add(b:ale_linters.python, 'flake8')
    endif
  endif
endfunc

function ScrollPopup(up=0)
  if (len(popup_list()) >= 1)
    let popid = popup_list()[0]
    let firstline = popup_getoptions(popid)['firstline']
    if (a:up)
      call popup_setoptions(popid, {'firstline': max([1, firstline-5])})
    else
      call popup_setoptions(popid, {'firstline': firstline+5})
    endif
  endif
endfunc

function TogglePopup()
  if (len(popup_list()) >= 1)
    call popup_clear()
  else
    execute "normal \<plug>(YCMHover)"
  endif
endfunc

"set formatexpr=Format_ALE()

" Enable vim paste mode whenever pasting
"function! WrapForTmux(s)
"  if !exists('$TMUX')
"    return a:s
"  endif
"
"  let tmux_start = "\<Esc>Ptmux;"
"  let tmux_end = "\<Esc>\\"
"
"  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
"endfunction
"
"let &t_SI .= WrapForTmux("\<Esc>[?2004h")
"let &t_EI .= WrapForTmux("\<Esc>[?2004l")
"
"function! XTermPasteBegin()
"  set pastetoggle=<Esc>[201~
"  set paste
"  return ""
"endfunction
"
"inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
" end

" Autocommands
augroup autocom
  autocmd!
  " Executes the following on exit of a markdown file
  autocmd VimLeave *.md !mark -c %

augroup END

filetype plugin on
set omnifunc=syntaxcomplete#Complete
autocmd Filetype java setlocal omnifunc=javacomplete#Complete
set completeopt+=menu,menuone,popup

"function! OpenCompletion()
"    if !pumvisible() && ((v:char >= 'a' && v:char <= 'z') || (v:char >= 'A' && v:char <= 'Z'))
"        call feedkeys("\<C-x>\<C-o>", "n")
"    endif
"endfunction

"autocmd InsertCharPre * call OpenCompletion()

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<C-x>\<C-o>\<C-p>"

" }}}
" COMMANDS {{{
" Merge current changes with original file
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
    \ | wincmd p | diffthis
"show trailing white spaces by default

augroup whitespace
  autocmd!
  " remove all whitespaces when done
  autocmd BufWrite * :call <SID>StripTrailingWhiteSpaces()
augroup END
nnoremap  <leader>s :call <SID>StripTrailingWhiteSpaces()<CR>
nnoremap <C-f> ggVGzC
nnoremap R :call Reorder()<CR>
nnoremap <leader>c  :call Comment()<CR>
vnoremap <leader>c  :call Comment()<CR>
nnoremap <leader>i  :IndentGuidesToggle<CR>
nnoremap <leader>u  :GitGutterUndoHunk<CR>
nnoremap <leader>d  :GitGutterDiffOrig<CR>
"nnoremap <leader>f  :call _AleFix()<CR>
" }}}

" KEYBINDS {{{
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
nnoremap <Up> 10<C-y>
nnoremap <Down> 10<C-e>
nnoremap <Left>   1b
nnoremap <Right>  1w
nnoremap \ :noh<return>
nnoremap <C-\> :NERDTreeToggle<CR>
nnoremap <C-u> :UndotreeToggle<CR>
vnoremap p	"0p
nnoremap vv <C-v>
"Join lines
noremap M :call Merge()<CR>
"move line up/down
noremap K  :move -2<CR>
noremap J  :move +1<CR>
xnoremap K  :m-2<CR>gv=gv
xnoremap J :m'>+<CR>gv=gv
"Break line
noremap B :call Break()<CR>
"Tmux copy
noremap <C-y>  y :WriteToVmuxClipboard<CR>
noremap <C-p>  :ReadFromVmuxClipboard<CR> p
"youcompleteme commands
noremap <leader>g :YcmCompleter GoTo<CR>
noremap <leader>r :YcmCompleter GoToReferences<CR>
noremap <leader>f :YcmCompleter FixIt<CR>
nmap <C-q> :call TogglePopup()<CR>
"   -> scroll ycm popup
noremap <S-Down> :call ScrollPopup()<CR>
noremap <S-Up> :call ScrollPopup(1)<CR>
"Open in normal
nnoremap <leader>o o<Esc>
nnoremap <leader>O O<Esc>
"Ale next
nnoremap <leader><TAB> :ALENextWrap<CR>
"Script running
nnoremap <C-c> :call Controlc()<CR>
"Spell check
nnoremap <C-s>  :setlocal spell spelllang=en_gb<CR>
"space open/closes folds
nnoremap <space> za
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>
nnoremap <S-x> :bdelete<CR>
"Automatic code insertions
inoremap {<CR>	{<CR>}<Esc>O
inoremap `sout<Tab>	System.out.println("");<Esc>2hi
inoremap `pf<Tab>	printf("\n");<Esc>4hi
inoremap `psvm<Tab>	public static void main(String[] args) {<CR>}<Esc>O
inoremap `im<Tab>	int main(int argc, char[] *argv) {<CR>}<Esc>O
inoremap `for for(int i = <++>; i < <++>; i++) {<CR>}<Esc>O<++><Esc>k0<C-j>
inoremap `<Tab>	<C-p>
" Remap esc
inoremap wq <Esc>l
inoremap qw <Esc>l
" Ale commands
" nmap <C-k> <Plug>(ale_previous_wrap)
" nmap <C-j> <Plug>(ale_next_wrap)
" }}}

" ALL SETS {{{
set backspace=indent,eol,start
set colorcolumn=80
set number
"set relativenumber
set hlsearch
"TAB SETTINGS
set autoindent    " Copy indent from current line when starting a new line.
set tabstop=2     " Size of a hard tabstop (ts).
set shiftwidth=2  " Size of an indentation (sw).
"set expandtab     " Always uses spaces instead of tab characters (et).
set softtabstop=0 expandtab " Number of spaces a <Tab> counts for. When 0, featuer is off (sts).
set smarttab      " Inserts blanks on a <Tab> key (as per sw, ts and sts).
"END TAB SETTINGS
"FOLD SETTINGS
set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=indent
set foldminlines=0
set textwidth=80
"END FOLD SETTINGS
syntax enable
set cursorline
set wildmenu
set modelines=1
set synmaxcol=500
" }}}
"VIMDIFF SETTINGS
set diffopt+=algorithm:patience
"END VIMDIFF SETTINGS

" air-line {{{
let g:Powerline_symbols = 'fancy'
let g:airline_theme='base16'
let g:airline_solorized_bg='dark'
set t_Co=256

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#formatter = 'jsformatter'
let g:airline_powerline_fonts = 1
let g:airline#extensions#syntastic#enabled = 1
set laststatus=2
"let g:airline_symbols={}
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
"let g:airline_left_sep = '»'
"let g:airline_left_sep = '▶'
"let g:airline_right_sep = '«'
"let g:airline_right_sep = '◀'
"let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
"let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
"let g:airline_symbols.paste = 'Þ'
"let g:airline_symbols.paste = '∥'
"let g:airline_symbols.whitespace = 'Ξ'
" }}}

" ale settings
let g:ale_virtualtext_cursor=0
"let g:ale_echo_msg_error_str = 'E'
"let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%severity%] %s [%linter%]'
let g:ale_python_auto_virtualenv = 1
" }}}


" youcompleteme settings
" OPTIONAL: do not display popup messages on hover by default.
let g:ycm_auto_hover = ''
let g:ycm_key_list_select_completion = ['<Down>']
let g:ycm_key_list_stop_completion = ['<TAB>']

" Set python virtual environment interpreter for YCM and ALE
autocmd Filetype python ++once call SetPythonPath()
function SetPythonPath()
  " Get the path of the closest python executable
  :cd %:p:h
  let file_dir = fnamemodify(@%, ':p:h')
  let pyfile = fnamemodify(system('python3 -c "import sys;print(sys.prefix, end=\"\")"') . '/bin/python3', ':p')
  if (pyfile == fnamemodify('~/.global_python_venv/bin/python3', ':p'))
    let hidden_pyfile = fnamemodify(findfile('python3', '**0/.*/bin;'), ':p')
    let visible_pyfile = fnamemodify(findfile('python3', '**0/*/bin;'), ':p')

    let hidden_pre = matchlist(hidden_pyfile."\0".file_dir, '\v^(.+).*'."\0".'\1')[1]
    let visible_pre = matchlist(visible_pyfile."\0".file_dir, '\v^(.+).*'."\0".'\1')[1]
    if (strlen(hidden_pre) >= strlen(visible_pre))
      let pyfile = hidden_pyfile
    else
      let pyfile = visible_pyfile
    endif
  endif
  :cd -
  " end
  " Set the ALE mypy option if python version is high enough
  let pyver = matchlist(system(pyfile . ' --version'), '\vPython (([0-9]+)\.([0-9]+))\.[0-9]+')
  let ver =  pyver[1]
  let maj = pyver[2]
  let min = pyver[3]
  if (maj == 3 && min > 6)
    let g:ale_python_mypy_options = '--python-version ' . ver .
      \ ' --python-executable ' . pyfile
  else
    let g:ale_python_mypy_options = '--no-site-packages'
  endif
  " Set the YCM options
  let g:ycm_python_interpreter_path = pyfile
  let g:ycm_python_sys_path = []
  let g:ycm_extra_conf_vim_data = [
    \  'g:ycm_python_interpreter_path',
    \  'g:ycm_python_sys_path'
    \]
  let g:ycm_global_ycm_extra_conf = '~/global_extra_conf.py'
endfunction
" }}}

" vim-indent-guides
let g:indent_guides_color_change_percent = 1
let g:indent_guides_start_level = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1

" vim-latex {{{
" REQUIRED. This makes vim invoke Latex-Suite when you open a tex file.
filetype plugin on

" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
set shellslash

" OPTIONAL: This enables automatic indentation as you type.
filetype indent on
set foldmethod=indent

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'
let g:Tex_FoldedCommands = ',caption'
let g:Tex_FoldedEnvironments = 'verbatim,comment,eq,gather,align,figure,table,sidewaystable,lstlisting,algorithm,algorithmic,tabular,enumerate,itemize,thebibliography,keywords,abstract,titlepage'
" }}}

"vim:foldmethod=marker:foldlevel=0

" Disable ALE linting between saves & enable spell for latex files
if (&ft == 'tex' || &ft == 'plaintex' || &ft == 'context')
  let g:ale_lint_on_text_changed = 'never'
  let g:ale_lint_on_insert_leave = 0
  :set spell
endif

" Python black plugin (for ale)
"let g:black_linelength = 80
"let g:ale_fixers = {}
"let g:ale_fixers.python = ['black']
