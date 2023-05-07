Plug 'xolox/vim-misc'
Plug 'xolox/vim-shell'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'

Plug 'simnalamburt/vim-mundo'
"Plug 'ruanyl/coverage.vim'

"Plug 'jceb/vim-orgmode'
Plug 'svermeulen/vim-macrobatics'

Plug 'jremmen/vim-ripgrep'
let g:rg_derive_root=1

""""""
" IDE stuff
""""""
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
"Plug 'jelera/vim-javascript-syntax'
Plug 'pangloss/vim-javascript'
Plug 'GutenYe/json5.vim'
Plug 'arzg/vim-sh'
Plug 'Galicarnax/vim-regex-syntax'
Plug 'godlygeek/tabular'
"Plug 'preservim/vim-markdown'
Plug 'chrisbra/Colorizer'
Plug 'imsnif/kdl.vim'

" Colors
Plug 'vim-scripts/mayansmoke'
Plug 'vim-scripts/candycode.vim'
Plug 'rainux/vim-desert-warm-256'
Plug 'altercation/vim-colors-solarized'

" Handy QOL stuff
Plug 'nacitar/a.vim'
Plug 'gitusp/yanked-buffer'

" Url linking
Plug 'vim-scripts/utl.vim'

" Searching niceness
Plug 'markonm/traces.vim'
"
" Completion
Plug 'Shougo/ddc.vim'
Plug 'vim-denops/denops.vim'
Plug 'Shougo/ddc-matcher_head'
Plug 'Shougo/ddc-sorter_rank'
Plug 'Shougo/ddc-ui-native'

if !has('nvim')
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif
