" La primera ves hay que instalar el getor de plugins *vim-plug*
" 
" Instalación de Plugins - https://stsewd.dev/es/posts/neovim-plugins/
" Top 50 Options https://www.shortcutfoo.com/blog/top-50-vim-configuration-options/
"
" RUTA: ~/.config/nvim/init.vim
" Revisar dependencias: nvim +checkhealth
" =======================================================
" DIRECTORIO DE PLUGINS
" =======================================================
call plug#begin('~/.local/share/nvim/plugged')
  Plug 'nvim-lualine/lualine.nvim'                              " Barra de estado 
  Plug 'ryanoasis/vim-devicons'                                 " Iconos
"  Plug 'nvim-tree/nvim-web-devicons'                            " Iconos con color
  Plug 'glepnir/dashboard-nvim'                                 " Dashboard
  Plug 'mhartington/oceanic-next'                               " ColorScheme
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' } " Language parser
  Plug 'norcalli/nvim-colorizer.lua'                            " Colorea los codigos RGB/HEX
  Plug 'Yggdroot/indentLine'                                    " Lineas de sangria
  Plug 'nvim-tree/nvim-tree.lua'                                " Explorador de archivos
  Plug 'dyng/ctrlsf.vim'                                        " Atajo de busqueda
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
"  Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }  " Buscador con ventana flotante. [:Clamp]
  Plug 'dense-analysis/ale'                                     " syntax checking and semantic errors
" Detalla informacion de las funciones
  Plug 'neoclide/coc.nvim', { 'branch': 'release', 'do': ':CocInstall coc-pyright'} 
  Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins' }      " Python highlights
  Plug 'preservim/nerdtree'
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
call plug#end()

" =======================================================
" APARIENCIA
" =======================================================
syntax on                   " Habilita syntax highlighting'
set termguicolors           " Activa true-colors en la terminal
let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 0
colorscheme OceanicNext     " Activa el tema. No cambies la ubicacion de esta linea.

" Habilita la transparencia -----------------------------
" https://tinyurl.com/293mnur4
"   hi Normal guibg=NONE ctermbg=NONE
"   hi LineNr guibg=NONE ctermbg=NONE
"   hi SignColumn guibg=NONE ctermbg=NONE
"   hi EndOfBuffer guibg=NONE ctermbg=NONE
"
" =======================================================
" DASHBOARD
" =======================================================
" Para agregar los delimitarores al princpio y final
" https://xflea.github.io/nv-dashboard-header-maker/
let g:dashboard_custom_header = [
    \' ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⡿⠁⠀⠀⠀⠀⠘⣿⡇⢀⡤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ',
    \' ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠀⠛⠛⠱⢗⣶⣶⣤⣈⠀⣰⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ',
    \' ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣔⢴⠶⣻⢽⠽⡳⡶⣤⡈⠙⢿⣿⣷⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ',
    \' ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣶⣹⣫⢽⣿⣸⡪⡺⣎⢎⣞⣦⣀⣻⣿⣿⣧⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ',
    \' ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣜⡷⣟⡾⣞⣗⣽⡻⡾⣽⣳⣳⣳⠋⣀⠨⣿⡿⣕⢕⡵⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ',
    \' ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣳⣟⡽⡽⡹⣞⡾⡽⣽⣺⣳⣳⣁⠀⠱⡑⢹⣿⡷⣵⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ',
    \' ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣗⣗⣗⡯⠷⣌⣗⡯⡯⣗⢇⠹⣷⣿⣳⣵⠾⢿⣿⣿⣕⢵⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ',
    \' ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡮⣞⢞⢮⠧⠰⠹⠗⠇⠙⠥⢼⣦⣈⣗⢗⣯⡠⠊⠙⣿⡺⣕⢵⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ',
    \' ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣝⡮⣏⢯⣇⠀⠑⠁⠀⠀⠀⢐⠿⠻⣮⢧⠃⠈⠂⠀⢹⣪⡺⣷⣕⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ',
    \' ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢜⡮⣞⣾⡵⣿⣄⠀⠀⠁⠀⠀⠀⢀⡔⣗⣍⢒⠀⠀⠀⣿⣷⡽⣸⡳⡽⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ',
    \' ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣞⣞⣷⢟⣽⣾⣿⠦⠀⠀⠁⠀⢀⢩⠜⣷⠽⠺⠀⠀⢠⠰⠋⠹⢲⢯⡻⣟⢦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ',
    \' ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⢇⣗⡯⡳⡵⣿⣿⢁⣜⢧⠂⠈⠈⠎⠂⡯⢺⠃⠀⠀⢢⢬⠀⠀⠀⠁⢻⢺⣯⡧⡀⠀⠀⠀⠀⠀⠀⠀⠀ ',
    \' ⠀⠀⠀⠀⠀⠀⠀⠀⠀⡰⠃⠰⣕⣯⢳⣫⡟⢋⡿⠀⠀⠀⠀⡂⠀⠈⢁⠈⢪⠀⠀⠈⢆⠀⢄⠀⠀⠡⣗⢽⣿⡵⡀⠀⠀⠀⠀⠀⠀⠀ ',
    \' ⠀⠀⠀⠀⠀⠀⠀⠠⠊⠀⠀⢠⡳⣹⢕⠏⢀⡾⠁⠀⠀⠀⠠⣷⠾⠉⠉⠀⠀⠆⠀⠀⠈⢯⠂⠀⠀⠐⡯⡪⣿⣞⡵⡀⠀⠀⠀⠀⠀⠀ ',
    \' ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡚⢸⡪⡇⢀⡾⡇⠀⠀⠀⠀⣜⠁⠀⠀⠀⠀⠀⢸⡀⠀⠀⠀⢣⠀⠀⢈⣿⡜⡜⣽⡜⡜⡄⠀⠀⠀⠀⠀ ',
    \' ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡜⡇⣜⢜⣮⠟⠀⣇⠀⠀⠀⡸⡂⠀⠀⠀⠀⠀⢀⡿⢁⠀⠀⠀⠀⠱⡀⠠⣿⣿⣎⢵⣷⠙⡔⡀⠀⠀⠀⠀ ',
    \' ⠀⠀⠀⠀⠀⠀⠀⠀⠀⡰⠁⣗⢕⣗⠏⡀⠂⠘⣆⠀⠀⢵⠀⠀⠀⠀⢀⣠⠾⢳⠈⡀⠀⠀⠀⠀⢰⠨⣺⣿⣿⣧⣿⡆⢘⢄⠀⡀⠀⠀ ',
    \' ⠀⠀⠀⠀⠀⠀⠀⠀⡠⠃⡰⡳⣝⢮⣷⡤⡐⠀⢈⠓⡦⡵⣄⣤⠤⠖⠃⢁⠀⠠⣣⢁⠀⠀⠀⠀⠨⡍⠏⠙⠛⠿⣿⡃⠈⣚⡠⢲⢙⠀ ',
    \' ⠀⠀⠀⠀⠀⠀⠀⠠⡎⡰⣹⠺⣕⢯⢿⣿⡿⣪⡦⣕⣦⠦⢄⠀⠄⠂⠈⠀⡀⢢⢫⡻⣆⡀⠀⠀⠀⡺⠀⠀⠀⠀⢀⣕⡭⣴⣿⣑⠘⠀ ',
    \' ⠀⠀⠀⠀⠀⠀⢀⠾⡰⡵⢁⡟⣜⢎⣿⡿⣝⢜⣿⣿⣿⡈⠀⠈⠒⠰⠨⠢⡪⠎⠇⠋⠉⠢⠀⠀⠰⡌⠀⠀⡠⡺⠘⠀⠁⠑⠹⡯⡁⠀ ',
    \' ⠀⠀⠀⠀⠀⠀⢬⡳⠉⢀⢶⡹⣪⣻⡽⣝⡜⡵⣿⣿⣿⣧⠀⠀⠀⢘⢖⣄⡀⠀⢀⡀⠀⠀⠈⠉⠁⠀⢀⢜⠜⠀⠀⠀⠀⠀⠀⠘⣽⡄ ',
    \' ⠀⠀⠀⠀⠀⡠⣫⠀⢀⢮⡣⣳⣳⢯⡫⡪⣞⢭⣿⣿⣿⣿⣧⠀⠀⠀⢿⡌⠘⢦⡀⠈⠁⠀⠀⡀⡠⢔⢞⠍⠀⠀⠀⠀⠀⠀⠀⠀⠱⣿ ',
    \' ⠀⠀⠀⠀⠐⣝⢞⢀⢮⢺⡪⣗⢯⢃⣝⡞⡵⣱⣻⣿⢟⡵⡳⣅⠀⠀⠘⠀⠀⠀⠈⠪⢍⢉⠑⢀⡂⡱⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿ ',
    \' ⠀⠀⠀⠀⢠⢳⢅⣖⢽⡱⣯⡫⠱⣘⢮⡺⣜⣞⢾⡽⣝⢎⢧⣳⣆⠀⠀⢁⠀⠀⠀⠀⠀⠉⠚⢖⡾⡑⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿ ',
    \' ⠀⢀⠌⠀⢸⢕⣟⢼⢕⣟⠎⠀⢆⡏⣧⣳⢗⣗⡽⡺⡪⣳⣽⣿⣿⢂⠀⠠⠢⡀⠀⠀⠀⠀⠀⢸⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡏ ',
    \' ⢀⢲⠀⠀⢸⢕⢵⢝⣯⠎⠀⣰⡺⣪⣗⢗⡝⣖⢽⡱⣽⣺⣿⣿⡟⡸⠀⠁⠀⠌⡆⠀⠀⠀⢠⠎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠀ ',
    \' ⣼⡅⠀⠀⠸⣏⢮⢿⠍⠀⣰⣳⣟⢷⡹⡪⡮⡯⣺⣼⣿⣿⢿⢏⠪⢨⠀⠀⠀⠨⡂⠀⠀⢠⠗⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠏⠀ ',
    \' ⣿⠀⠀⠀⢀⡳⣽⡏⠀⣰⣿⢏⡗⡵⣹⢪⣟⢼⣺⣿⠟⣡⣿⡜⠄⠀⢁⠡⠁⡇⠀⠀⠀⣞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠟⠀⠀ ',
  \ ]

" =======================================================
" LUA WRAPPER
" =======================================================
lua << EOF
  require('lualine').setup {
    options = {
      component_separators = "",
      section_separators = { left = '', right = '' },
      theme = 'onedark',
    },
  }
  require('nvim-treesitter.configs').setup {
    ensure_installed = "all",
    auto_install = true,
    highlight = { 
      enable = true, 
      use_languagetree = true,
    },
  }
  require('colorizer').setup {'*'}
  require('nvim-tree').setup {} 
EOF

" =======================================================
" OPCIONES GENERALES
" =======================================================
set foldmethod=manual       " It folds a range of text, hiding it from display without actually deleting it
set lazyredraw              " Don’t update screen during macro and script execution
set noshowmode              " Hide the insert status in vim
set number relativenumber   " Show line number on the current line and relative numbers on all other lines
set spelllang=en,es         " Corregir palabras usando diccionarios en inglés y español
set splitbelow splitright   " Control the position of the new window {ctrl+w + s}
set ttyfast                 " Acelera el scroll

" IDENTACION --------------------------------------------
set autoindent      " New lines inherit the indentation of previous lines
set expandtab       " Insertar espacios en lugar de TABs
set shiftwidth=2    " spaces for autoindenting
set softtabstop=2   " remove a full pseudo-TAB when i press <BS>

" TEXTO -------------------------------------------------
" set clipboard^=unnamed,unnamedplus       " In effect, the system clipboard becomes the default register.
" set guicursor=
set mouse=ivh               " disable mouse support in normal mode
set nowrap                  " prevents long lines of text from wrapping
set scrolloff=8             " number of screen lines   to keep above and below          the cursor
set sidescrolloff=6         " number of screen columns to keep to the left and right of the cursor

" BUSQUEDA ----------------------------------------------
set ignorecase      " Ignorar MAYUS al hacer busquedas
set nohlsearch      " Clear search highlights
set smartcase       " No ignorar MAYUS si la palabra contiene mayusculas

" INDENTLINE --------------------------------------------
let g:indentLine_bufNameExclude = [ 'term:.*' ] " oculta las lineas al mostrar el arte ascii
let g:indentLine_char = '┊'
let g:indentLine_defaultGroup = 'Constant'      " con 'SpecialKey' las lineas son grices
set list lcs=tab:\|\                            " NO resalta los TABs. Es una mejora cosmetica.

" ALE ---------------------------------------------------
let g:ale_sign_error = '❌' 
let g:ale_sign_warning = '⚠️'
let g:ale_fix_on_save = 1
let g:ale_echo_msg_error_str = 'ERROR'
let g:ale_echo_msg_warning_str = 'WARN'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_python_flake8_options = '--max-line-length 110 --ignore=F403,F405 --extend-ignore=E203'
" let g:ale_linters = {'python': ['flake8'],}      " https://vi.stackexchange.com/a/18587
" let g:ale_linters = {'python': ['pycodestyle'],} " https://pypi.org/project/pycodestyle/

" EXTRAS ------------------------------------------------
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard'] "Hide files in .gitignore
let g:ctrlp_show_hidden = 1                                                         "Show dotfiles

" NERDTree ----------------------------------------------
" autocmd VimEnter * NERDTree | wincmd p
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1

" ATAJOS ------------------------------------------------
" :setlocal nonumber norelativenumber
" nmap <space> <leader>
map <F2>            :set nowrap!<CR>
map <F3>            :IndentLinesToggle<CR>              " en vim NORMAL, oculta las lineas
map <F4>            :set nu! rnu!<CR>

nmap <C-F>f         <Plug>CtrlSFPrompt                  
nmap <C-F>n         <Plug>CtrlSFCwordPath
nmap <C-F>p         <Plug>CtrlSFPwordPath
nnoremap <C-f>      :NERDTreeFind<CR>
nnoremap <C-n>      :NERDTree<CR>
nnoremap <C-t>      :NERDTreeToggle<CR>
nnoremap <leader>n  :NERDTreeFocus<CR>
