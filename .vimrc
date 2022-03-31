" misc {{{
set updatetime=100
set hidden
set timeoutlen=500
" }}}

" vim-plug {{{
call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'rhysd/vim-clang-format'
Plug 'valloric/vim-indent-guides'
Plug 'fedorenchik/VimCalc3'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdtree'
Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'dense-analysis/ale'
Plug 'johngrib/vim-game-snake'
Plug 'gsiano/vmux-clipboard'
Plug 'jrozner/vim-antlr'
Plug 'vim-latex/vim-latex'
Plug 'mbbill/undotree'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
call plug#end()
" }}}

" Colors {{{
"GRUVBOX
colorscheme gruvbox
set background=dark

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

function FoldCloseAll()
  let _s=@/
  let l = line(".")
  let c = col(".")

  execute "normal zR"
  execute "normal ggzj"
  let lprev = line(".")
  execute "normal zj"
  silent! foldclose
  let lnow = line(".")
  while lnow != lprev
    execute "normal zj"
    silent! foldclose
    let lprev = lnow
    let lnow = line(".")
  endwhile
  execute "normal ggzj"
  silent! foldclose

  let @/=_s
  call cursor(l, c)
endfunction

function Reorder()
  let _s=@/
  let l = line(".")
  let c = col(".")

  let len = strwidth(getline("."))
  if len < 80
    execute "normal M"
  endif
  let len = strwidth(getline("."))
  while len > 80
    execute "normal 80|"
    if (Break() == 0)
      call search("\\s", 'b', line("."))
      call Break()
    endif
    if getline(line(".")+1) =~ '^\s*$'
      break
    endif
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

function Comment()
  let l = line(".")
  let c = col(".")
  let line=getline('.')
  let ext = expand('%:e')

  if ext == "java"
    let com = "//"
    let len = 2
  elseif ext == "c"
    let com = "//"
    let len = 2
  elseif ext == "tex"
    let com = "%"
    let len = 1
  elseif ext == "py"
    let com = "#"
    let len = 1
  elseif ext == "hs"
    let com = "--"
    let len = 2
  else
    let com = "#"
    let len = 1
  endif

  if line =~ '^\s*' . com
    "echo "Found comment"
    if len == 2
      execute "normal _xx"
    elseif len == 1
      execute "normal _x"
    endif
  call cursor(l, c-len)
  else
    "echo "Comment not found"
    execute "normal _i" . com
  call cursor(l, c+len)
  endif
endfunction

function Controlc()
  let extension = expand('%:e')
  if extension == "md"
    :execute "silent !mark %" | redraw!
  elseif extension == "tex"
    :execute "silent !pdftex %" | redraw!
  else
    :!mmake
  endif
endfunction
" }}}
" COMMANDS {{{
" Merge current changes with original file
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
    \ | wincmd p | diffthis
"show trailing white spaces by default

" remove all whitespaces when done
autocmd BufWrite * :call <SID>StripTrailingWhiteSpaces()
nnoremap  <leader>s :call <SID>StripTrailingWhiteSpaces()<CR>
nnoremap F :call FoldCloseAll()<CR>
nnoremap R :call Reorder()<CR>
nnoremap <leader>c  :call Comment()<CR>
vnoremap <leader>c  :call Comment()<CR>
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
nnoremap <C-l> :IndentGuidesToggle<return>
nnoremap <C-\> :NERDTreeToggle<CR>
nnoremap <C-u> :UndotreeToggle<CR>
vnoremap p	"0p
"Join lines
noremap M J
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
"Open in normal
nnoremap <leader>o  o<Esc>
nnoremap <leader>O O<Esc>
"Ale next
nnoremap <leader><TAB> :ALENextWrap<CR>
"Script running
nnoremap <C-c> :call Controlc()<CR>
vnoremap p	"0p
"Spell check
nnoremap <C-s>  :setlocal spell spelllang=en_us<CR>
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
set textwidth=80
"END FOLD SETTINGS
syntax enable
set cursorline
set wildmenu
set modelines=1
set synmaxcol=100
" }}}

" air-line {{{
let g:Powerline_symbols = 'fancy'
let g:airline_theme='base16'
let g:airline_solorized_bg='dark'
set t_Co=256

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#syntastic#enabled = 1
set laststatus=2
let g:airline_symbols={}

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
"let g:airline_left_sep = '»'
"let g:airline_left_sep = '▶'
"let g:airline_right_sep = '«'
"let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'
" }}}


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
let g:Tex_FoldedEnvironments = 'verbatim,comment,eq,gather,align,figure,table,lstlisting,algorithm,algorithmic,enumerate,itemize,thebibliography,keywords,abstract,titlepage'
" }}}

"vim:foldmethod=marker:foldlevel=0
