
" Pane navigation
" Ctrl-Direction to switch panels
nnoremap <leader>j <c-w>j
nnoremap <leader>k <c-w>k
nnoremap <leader>l <c-w>l
nnoremap <leader>h <c-w>h

" Dirty habits
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
inoremap <del> <nop>
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>

" Save and Delete Buffer
nnoremap Q :w\|bd<cr>


" Tab Controls
nnoremap <Tab>l :tabn<cr>
nnoremap <Tab>h :tabp<cr>

" for insert mode
inoremap <S-Tab> <C-d>

map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

nnoremap <c-\> <cmd>SymbolsOutline<cr>

