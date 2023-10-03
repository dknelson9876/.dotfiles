set encoding=utf-8
" --- BEGIN VIMRC TEMPLATE ---------
" Use Vim settings, rather than Vi settings
set nocompatible
colorscheme desert256

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set history=50
set ruler
set showcmd
set nu
set rnu
set incsearch

map Q gq

" ^U in insert mode deletes a lot. Use ^Gu to first break undo,
" so that you can undo ^U after inserting aline break
inoremap <C-U> <C-G>u<C-U>

set mouse=a
syntax on
set hlsearch

if has("autocmd")
    " Enable file type detection
    " Use the default filetype settings, so that mail gets 'tw' set to 72,
    " 'cindent' is on in C files, etc.
    " Also load indent files, to automatically do language-dependent indenting.
    filetype plugin indent on

    " Put thse in an autocmd group, so that we can delete them easily
    augroup vimrcEx
    au!

    " For all text files set 'textwidth' to 78 characters
    autocmd FileType text setlocal textwidth=78

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an evetn handler
    " (happens when dropping a file on gvim).
    " Also don't do it when the mark is in the first line, that is the default
    " position when opening a file.
    autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \ exe "normal! g`\"" |
        \ endif

    augroup END
endif " has ("autocmd")

if has('langmap') && exists('+langnoremap')
    " Prevent that the langmap option applies to characters that result from a
    " mapping. If unset (default), this may break plugins (but it's backward
    " compatible).
    set langnoremap
endif

" ----------------------- Copied from Walt's vimrc -----------
set autoindent
"set smartindent
set smarttab
set shiftround
set ignorecase
set smartcase
set foldcolumn=3

source $VIMRUNTIME/menu.vim
set wildmenu
set cpo-=<
set wcm=<c-z>
map <f4> :emenu <c-z>

set undolevels=1000

" ------------------------ My edits ----------------
hi Normal guibg=NONE ctermbg=NONE

" toggle block and line cursor as appropriate
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
" reset the cursor on start
augroup myCmds
au!
augroup END

" Bind F5 to trim trailing whitespace (while preserving current search term)
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" set <tab> as 4 spaces
set tabstop=4
set shiftwidth=4
set expandtab

" remap Ctrl+hjkl to move windows
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

" remap Ctrl+BS to delete previous word
inoremap <C-w> <C-\><C-o>dB
inoremap <C-BS> <c-\><C-o>db

" Stop shouting when I don't let go of shift fast enough
command! W w

" automatically save and load folds
augroup remember_folds
    autocmd!
    autocmd BufWinLeave ?* mkview
    autocmd BufWinEnter ?* silent! loadview
augroup END


" Enable true color support?
" if !has('nvim')
"   let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
"   let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
" endif

let g:mapleader = "\<Space>"
let g:maplocalleader = ','
set timeoutlen=500

" Bindings for buffer navigation
map <leader>bn :bn<CR>
map <leader>bp :bp<CR>
" close the current buffer and open the next
map <leader>bd :b#<bar>bd#<CR>

" --------Netrw keymaps
" keybind to open netrw's shortcuts window when netrw is open
autocmd FileType netrw nnoremap ? :help netrw-quickmap<CR>
" tree-like view
let g:netrw_liststyle = 3
map <silent> <leader>e :call ToggleVExplorer()<CR>
" opening a file with <CR> opens it in a new split to the right"
let g:netrw_browse_split = 4
let g:netrw_altv = 1
" hide banner
let g:netrw_banner = 0
" change dir to the current buffer when opening files
set autochdir

" Toggle Vexplore
function! ToggleVExplorer()
    if exists("t:expl_buf_num")
        let expl_win_num = bufwinnr(t:expl_buf_num)
        let cur_win_num = winnr()
        if expl_win_num != -1
            while expl_win_num != cur_win_num
                exec "wincmd w"
                let cur_win_num = winnr()
            endwhile
            close
        endif
        unlet t:expl_buf_num
    else
        Vexplore
        vertical resize 30
        let t:expl_buf_num = bufnr("%")
    endif
endfunction

" <leader>h to toggle search highlights"
let hlstate=0
nnoremap <silent> <leader>h :if (hlstate == 0) \| nohlsearch \| else \| set hlsearch \| endif \| let hlstate=1-hlstate<CR>

" Vim Plug declarations
call plug#begin('~/.vim/plugged')
" Plug 'liuchengxu/vim-which-key'
Plug 'vim-airline/vim-airline'
Plug 'junegunn/vim-easy-align'
" Plug unbleveable/quick-scope'
Plug 'justinmk/vim-sneak'
" Plug 'preservim/nerdtree'
call plug#end()

" -- vim which key config----
" let g:which_key_map = {'w': 'asdf'}
" let g:which_key_map.t = {'name': '+file'}
" call which_key#register('<Space>', "g:which_key_map")
" nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
" vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>

" -- vim airline config-----
" Enable tabs at the top showing open buffers
"let g:airline#extensions#tabline#enabled = 1

" -- vim easy align config -----
" Start interactive EasyAlign in visual mode (e.g. vipga)
"xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
"nmap ga <Plug>(EasyAlign)

" -- quick scope config-----
" Only enable highlights after starting a relevant command
"let g:qs_highlight_on_kyes = ['f', 'F', 't', 'T']

" -- NERDTree config --------
"nnoremap <leader>f :NERDTreeToggle<CR>"
