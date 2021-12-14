set nocompatible

" Prevent Neovim Terminal Nesting
if has('nvim')
  let $VISUAL = 'nvr -cc split --remote-wait-silent'
endif

" FileType shortcuts & identifiers
au FileType * vnoremap <Space><Bar> :EasyAlign*<Bar><Enter>
au FileType markdown set list
au BufNewFile,BufRead * :call DetectLang()
au BufNewFile,BufRead /etc/nginx/sites-* set filetype=conf
au TermOpen * setlocal nonumber norelativenumber nospell
au BufRead,BufNewFile *.md setlocal spell
au FileType gitcommit setlocal spell

" au BufWritePost *.py :call CcAction('runCommand', 'editor.action.organizeImport')
" au BufWritePost *.py :Black

" Plugins
call plug#begin()

" Shortcuts
Plug 'tpope/vim-commentary'

" CSV
Plug 'chrisbra/csv.vim'

" netrw
Plug 'tpope/vim-vinegar'

" Editorconfig
Plug 'editorconfig/editorconfig-vim'

" Fuzzysearch

" Git wrappers
Plug 'tpope/vim-fugitive'
Plug 'rbong/vim-flog'
Plug 'airblade/vim-gitgutter'

" SQL
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" Python formatting
Plug 'psf/black', { 'branch': 'stable' }

" Colorscheme
Plug 'KKPMW/distilled-vim'
Plug 'altercation/vim-colors-solarized'

" Distraction-free mode
Plug 'junegunn/goyo.vim'

Plug 'gyim/vim-boxdraw'

" LSP
Plug 'neovim/nvim-lspconfig'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

" Completion + Snippets
Plug 'hrsh7th/nvim-compe'


" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Lazy-load
Plug 'mxw/vim-jsx', { 'for': 'jsx' }
Plug 'othree/yajs.vim', { 'for': 'javascript' }
Plug 'othree/es.next.syntax.vim', { 'for': 'javascript' }
Plug 'HerringtonDarkholme/yats.vim', { 'for': ['typescript', 'typescriptreact'] }

Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoInstallBinaries' }
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'tpope/vim-markdown', { 'for': 'markdown' }
Plug 'junegunn/vim-easy-align', { 'for': 'markdown' }
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'stephpy/vim-yaml', { 'for': 'yaml' }

" requires: https://github.com/myint/autoflake
Plug 'tell-k/vim-autoflake', { 'for': 'python' }

call plug#end()

" LSP
lua << EOF
require'lspconfig'.pyright.setup{}
require'lspconfig'.gopls.setup{}
require'lspconfig'.sqlls.setup{}
require'lspconfig'.bashls.setup{}
require'lspconfig'.solargraph.setup{}
require'lspconfig'.svelte.setup{}
require'lspconfig'.vuels.setup{}
require'telescope'.setup{}

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

local nvim_lsp = require('lspconfig')

vim.cmd [[autocmd ColorScheme * highlight NormalFloat guibg=#000]]
vim.cmd [[autocmd ColorScheme * highlight FloatBorder guifg=white guibg=#333]]

local border = {
    {"🭽", "FloatBorder"},
    {"▔", "FloatBorder"},
    {"🭾", "FloatBorder"},
    {"▕", "FloatBorder"},
    {"🭿", "FloatBorder"},
    {"▁", "FloatBorder"},
    {"🭼", "FloatBorder"},
    {"▏", "FloatBorder"},
}

-- Border Styles
vim.lsp.handlers["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border})
vim.lsp.handlers["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = border})

-- vim.o.updatetime = 250
-- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.lsp.diagnostic.show_line_diagnostics({focusable=true})]]

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end


  local signs = { Error = "● ", Warning = ". ", Hint = "! ", Information = "| " }

  for type, icon in pairs(signs) do
    local hl = "LspDiagnosticsSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pyright', 'gopls', 'sqlls', 'tsserver' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF

" Editor settings
filetype plugin on
filetype indent off
set number relativenumber
set nu rnu
set textwidth=80
set wrap
set nosmartindent
set tabstop=2
set shiftwidth=2
set expandtab
set clipboard+=unnamed
set listchars=tab:\\t,extends:›,precedes:‹,nbsp:•,trail:•
set ruler
" set spell spelllang=en_us
syntax enable

" Visual settings
set termguicolors
set background=dark
color spring-night
" Statusline
set statusline=[%M%n]\ %y\ %t\ %=\ %l:%c

" presentation
nnoremap <Left> :silent bp<CR> :redraw!<CR>
nnoremap <Right> :silent bn<CR> :redraw!<CR>
nmap <leader>p :set relativenumber! number! showmode! showcmd! hidden! ruler! spell!<CR>
nmap <leader>2 :.!toilet -w 200 -f standard
nmap <leader>3 :.!toilet -w 200 -f small
nmap <leader>1 :.!toilet -w 200 -f term -F border<CR>

" Coc
set nobackup
set nowritebackup
set updatetime=300
set shortmess+=c

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" ale
let g:ale_sign_error = '●'
let g:ale_sign_warning = '.'
let g:ale_lint_on_enter = 1
let g:ale_linters_explicit = 1
let g:ale_echo_msg_info_str = 'Info'
let g:ale_echo_msg_warning_str = 'Warn'
let g:ale_echo_msg_error_str = 'Error'
let g:ale_fix_on_save = 1

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['black'],
\}

" SQL
let g:LanguageClient_serverCommands = {
\   'sql': ['sql-language-server', 'up', '--method', 'stdio'],
\}

" Neovim/Python
let g:python3_host_prog='/usr/local/bin/python3'

" autoflake
let g:autoflake_remove_all_unused_imports=1
let g:autoflake_disable_show_diff=1

" Editorconfig
let g:EditorConfig_core_mode = 'external_command'

" Map leader
let mapleader = "\<Space>"

" Plug-in settings
let g:vim_markdown_folding_disabled=1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_term_enabled = 1
let g:go_term_mode = "split"
let g:EditorConfig_core_mode = 'external_command'
let g:netrw_banner = 0
let g:netrw_list_hide= '.*\.swp$,.DS_Store,__pycache__,\.mypy_cache,*/tmp/*,*.so,*.swp,*.zip,*.git,^\.\=/\=$'

" vim-go
set autowrite
set updatetime=200
let g:go_auto_type_info = 1
let g:go_fmt_command = "goimports"
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <leader>i <Plug>(go-info)
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

" Edit and source vimrc on the fly
nnoremap <leader>ev :vsp $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

nnoremap <leader>eb :vsp ~/.bashrc<cr>
nnoremap <leader>ea :vsp ~/.config/alacritty/alacritty.yml<cr>
" nnoremap <leader>en :vsp ~/.config/ncspot/config.yaml<cr>

" Tab Controls
nnoremap <Tab>l :tabn<cr>
nnoremap <Tab>h :tabp<cr>

" for insert mode
inoremap <S-Tab> <C-d>

" distraction-free mode
nnoremap <leader>df :Goyo<cr>

" Format code
nnoremap fa <Plug>(coc-format-selected)
nnoremap fj :%!jq .<cr>
nnoremap fpj :%!python -c 'import ast; import sys; import json; sys.stdout.write(json.dumps(ast.literal_eval(sys.stdin.readlines()[0]), indent=2))' .<cr>
nnoremap fp :Black<cr>
nnoremap fx :%!xmllint --format %<cr>
nnoremap rt :%s/\t/  /g<cr>
nnoremap r' :%s/\"/\'/g<cr>

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>


" Coc GoTo code navigation.
" nmap <silent> gd :sp<CR><Plug>(coc-definition)
" nmap <silent> gy :sp<CR><Plug>(coc-type-definition)
" nmap <silent> gi :sp<CR><Plug>(coc-implementation)
" nmap <silent> gr :sp<CR><Plug>(coc-references)

" Ctrl-Direction to switch panels when in term emulator
tnoremap ,j <c-\><c-n><c-w>j tnoremap ,k <c-\><c-n><c-w>k
tnoremap ,l <c-\><c-n><c-w>l
tnoremap ,h <c-\><c-n><c-w>h
tnoremap <esc> <c-\><c-n>
tnoremap <c-\> <esc>
tnoremap ,tq <c-\>:tabclose<cr>

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

" Morning shortcuts
nnoremap <leader>E :Explore<cr>
nnoremap <leader>V :vsp<cr>
nnoremap <leader>S :sp<cr>
nnoremap <leader>st :sp<cr>:term<cr>
nnoremap <leader>vt :vsp<cr>:term<cr>
nnoremap <leader>w :call ToggleWrap()<cr>
nnoremap <leader>c :set list!<cr>

" Search adjustments
nnoremap <leader>n :set hls!<cr>
nnoremap / :set hlsearch<cr>/

" Notes
" nnoremap <leader>en :vsp ~/notes/<cr>

" Save and Delete Buffer
nnoremap Q :w\|bd<cr>

" TODO 80th col
" if has('nvim')
"   highlight link OverLength Error
"   match OverLength /\%81v.\+/
" endif

" Syntax Identifier
nmap <leader>sf :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" Toggle Line Wrap
function! ToggleWrap()
  if &wrap
    set nowrap
  else
    set wrap
  endif
endfunc

" Format Markdown files
function! MarkdownFormat()
  let save_pos = getpos(".")
  let query = getreg('/')
  execute ":0,$!tidy-markdown"
  call setpos(".", save_pos)
  call setreg('/', query)
endfunction

" Detect Shebang language
function! DetectLang()
  let shebang = getline(1)

  " check if shebag
  if shebang =~ '#!'
    if shebang =~ 'node'
      set ft=javascript
    elseif shebang =~ 'bash'
      set ft=sh
    else
      set ft=text
    endif
  endif
endfun

" Tabline
function! Tabline()
  let s = ''
  for tabnum in range(tabpagenr('$'))
    let tabnr = tabnum + 1
    let winnr = tabpagewinnr(tabnr)
    let tabcwd = getcwd(winnr, tabnr)
    let tabname = (tabcwd != '' ? fnamemodify(tabcwd, ':t') . ' ' : '[No Name] ')

    " check if it's a term instance (neovim only)
    let buflist = tabpagebuflist(tabnr)
    let bufnr = buflist[winnr - 1]
    let bufname = bufname(bufnr)
    if len(buflist) == 1
      if bufname =~ 'term://'
        let tabname = 'term '
      endif
    endif

    " format
    let s .= (tabnr == tabpagenr() ? ' %#TabLineSel#' : '%#TabLine#')
    let s .= ' ' . tabnr .' '
    let s .= (tabnr == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
    let s .= tabname
  endfor

  let s .= '%#TabLineFill#'
  return s
endfunction
set tabline=%!Tabline()

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

function! SwapWords(dict, ...)
    let words = keys(a:dict) + values(a:dict)
    let words = map(words, 'escape(v:val, "|")')
    if(a:0 == 1)
        let delimiter = a:1
    else
        let delimiter = '/'
    endif
    let pattern = '\v(' . join(words, '|') . ')'
    exe '%s' . delimiter . pattern . delimiter
        \ . '\=' . string(Mirror(a:dict)) . '[S(0)]'
        \ . delimiter . 'g'
endfunction

" CoC Colors
" hi clear CocErrorSign
" hi clear CocWarningSign
" hi clear CocInfoSign
" hi clear CocHintSign
" hi clear CocCodeLens
" " hi link CocErrorSign    ErrorMsg
" " hi link CocWarningSign  WarningMsg
" hi link CocInfoSign     Visual
" hi link CocHintSign     Visual
" hi link CocCodeLens     Visual 
