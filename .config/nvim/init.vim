" nvim vim-plug install curl
" sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

call plug#begin()
Plug 'neovim/nvim-lspconfig'
Plug 'jdhao/better-escape.vim'
Plug 'tpope/vim-fugitive'
Plug 'pangloss/vim-javascript'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'yggdroot/indentline'
Plug 'airblade/vim-gitgutter'
Plug 'fatih/vim-go'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'glepnir/lspsaga.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'nvim-lualine/lualine.nvim'
Plug 'bluz71/vim-nightfly-guicolors'

call plug#end()

" Editor settings
filetype plugin on
filetype indent off

" Mappings
" Map leader
let mapleader = "\<Space>"

" Better Escape
let g:better_escape_shortcut = 'jj'

" Indent Guides
let g:indent_guides_enable_on_vim_startup = 1

" Indent Line
let g:indentLine_enabled = 1

" JS JSX Files
let g:jsx_ext_required = 0

" Neovim/Python
let g:python3_host_prog='/usr/bin/python3'

