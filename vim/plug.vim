Plug 'xolox/vim-misc'
Plug 'xolox/vim-shell'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'

Plug 'simnalamburt/vim-mundo'
Plug 'ruanyl/coverage.vim'

"Plug 'jceb/vim-orgmode'
Plug 'svermeulen/vim-macrobatics'

Plug 'jremmen/vim-ripgrep'
let g:rg_derive_root=1

""""""
" IDE stuff
""""""
" Plug 'Valloric/YouCompleteMe'
Plug 'vim-syntastic/syntastic'

Plug 'honza/vim-snippets'


" Git stuff
Plug 'airblade/vim-gitgutter'

" Node stuff
Plug 'eliba2/vim-node-inspect'
Plug 'heavenshell/vim-jsdoc', { 
  \ 'for': ['javascript', 'javascript.jsx','typescript'], 
  \ 'do': 'make install'
\}

Plug 'idanarye/vim-vebugger'

" Formatting suff
Plug 'rhysd/vim-clang-format'
let g:clang_format#command = 'clang-format-6.0'
Plug 'w0rp/ale'
Plug 'kamykn/spelunker.vim'
" Dynamic spell checking, so we don't freak out on large files
let g:spelunker_check_type=2

""""
" Other misc
""""
" Syntax
Plug 'bfrg/vim-cpp-modern'
Plug 'rust-lang/rust.vim'
Plug 'rodjek/vim-puppet'
Plug 'justinj/vim-pico8-syntax'
Plug 'joukevandermaas/vim-ember-hbs'
Plug 'jelera/vim-javascript-syntax'
Plug 'GutenYe/json5.vim'
Plug 'arzg/vim-sh'
Plug 'Galicarnax/vim-regex-syntax'

" Colors
Plug 'vim-scripts/mayansmoke'
Plug 'vim-scripts/candycode.vim'
Plug 'rainux/vim-desert-warm-256'
Plug 'altercation/vim-colors-solarized'

" Header/cpp jump
Plug 'nacitar/a.vim'

" Url linking
Plug 'vim-scripts/utl.vim'

" Searching niceness
Plug 'markonm/traces.vim'

if !has('nvim')
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif
