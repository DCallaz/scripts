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

function Comment()
  let l = line(".")
  let c = col(".")
  let line=getline('.')
  
  if line =~ '^\s*//'
    "echo "Found comment"
    execute "normal _xx"
  call cursor(l, c-2)
  else
    "echo "Comment not found"
    execute "normal _i//"
  call cursor(l, c+2)
  endif
endfunction
" }}}
" COMMANDS {{{
"show trailing white spaces by default

" remove all whitespaces when done
nnoremap <silent> <F5> :call <SID>StripTrailingWhiteSpaces()<CR>
nnoremap F :call FoldCloseAll()<CR>
nnoremap <leader>c  :call Comment()<CR>
vnoremap <leader>c  :call Comment()<CR>
autocmd BufWritePre *.txt, *.c :call <SID>StripTrailingWhiteSpaces()
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
nnoremap <C-\> :ToggleNumber()<CR>
nnoremap <C-l> :IndentGuidesToggle<return>
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <C-c> :!pdftex %<CR><CR>
nnoremap <C-m> :!mmake<CR>
vnoremap p	"0p
"Tmux copy
noremap <C-y>  y :WriteToVmuxClipboard<CR>
noremap <C-p>  :ReadFromVmuxClipboard<CR> p
"Open in normal
nnoremap <leader>o  o<Esc>
nnoremap <leader>O O<Esc>
"Script running
nnoremap <C-c> :!pdftex %<CR><CR>
nnoremap <C-m> :!mmake<CR>
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
inoremap `<Tab>	<C-p>
" Ale commands
" nmap <C-k> <Plug>(ale_previous_wrap)
" nmap <C-j> <Plug>(ale_next_wrap)
" }}}

" ALL SETS {{{
set colorcolumn=80
set number
set relativenumber
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

"vim:foldmethod=marker:foldlevel=0
