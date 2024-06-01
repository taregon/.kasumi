" La primera ves hay que instalar el getor de plugins *vim-plug*
"
" Instalación de Plugins - https://stsewd.dev/es/posts/neovim-plugins/
" Top 50 Options https://www.shortcutfoo.com/blog/top-50-vim-configuration-options/
" Colores Catppuccin https://github.com/catppuccin/catppuccin/blob/main/docs/style-guide.md
"
" RUTA: ~/.config/nvim/init.vim
" Revisar dependencias: nvim +checkhealth
" =======================================================
" DIRECTORIO DE PLUGINS
" =======================================================
call plug#begin('~/.local/share/nvim/plugged')
  Plug 'catppuccin/nvim', { 'as': 'catppuccin' }                " - ColorScheme
  Plug 'fcancelinha/northern.nvim'                              " - ColorScheme
  Plug 'echasnovski/mini.nvim'                                  " - Pack de modulos
  Plug 'glepnir/dashboard-nvim'                                 " - Dashboard
  Plug 'junegunn/vim-easy-align'                                " - Alinear texto
  Plug 'norcalli/nvim-colorizer.lua'                            " - Colorea los codigos RGB/HEX
  Plug 'nvim-lualine/lualine.nvim'                              " - Barra de estado
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' } " - Language parser
  Plug 'preservim/nerdtree'                                     " - Explorador de archivos
  Plug 'ryanoasis/vim-devicons'                                 " - Iconos
  Plug 'Yggdroot/indentLine'                                    " - Lineas de sangria
call plug#end()

" =======================================================
" APARIENCIA
" =======================================================
syntax on                   " Habilita syntax highlighting'
set termguicolors           " Activa true-colors en la terminal

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
    },
  }
  require('catppuccin').setup {
    no_italic = true,
    dim_inactive = {
      enabled = true,
      shade = "dark",
      percentage = 0.9,
    },
    flavour = "macchiato",
    color_overrides = {
      macchiato = {
        flamingo  = "#AC89C9", -- De preferencia igual a 'text'
        red       = "#e23667", -- ALERTA
        maroon    = "#9B4834",
        pink      = "#EA9A97", -- Tono Rosado | Funcion
        mauve     = "#ea6a8e", -- Barra (visual) | Comando
        peach     = "#eabc7b", -- Barra (comando) | Sangria y valores
        yellow    = "#ffc574",
        green     = "#afd590", -- Barra (Normar) | ALERTA
        teal      = "#B9BB25",
        sky       = "#af6a8a", -- < = > >>
        sapphire  = "#99c792",
        blue      = "#5cbcd6", -- Barra lados
        lavender  = "#8dbba3",
        text      = "#bac2d0", -- Barra texto
        overlay2  = "#8793ab", -- , [] ()
        overlay1  = "#858585",
        overlay0  = "#4c5567", -- Comentarios
        surface2  = "#4d4d4d",
        surface1  = "#343C4B", -- Numero de linea
        surface0  = "#2E3440", -- Barra medio lado
        base      = "#1E222A", -- A. Fondo
        mantle    = "#1A1D23", -- B. Barra centro
        crust     = "#1A1D23", -- C. Divisor de paneles
      },
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
  require('colorizer').setup () -- Habilita los colores HEX
  require('mini.pairs').setup () -- Automaticamente completa el par de {[("'`
  require('mini.align').setup {
    mappings = {
      start = '<F7>', -- Atajo solo en VISUAL
    },
  }
EOF
" =======================================================
" EL TEMA DEBE CARGAR DESPUES DE LOS AJUSTES DE LUA
" =======================================================
" colorscheme rose-pine-moon
colorscheme catppuccin-macchiato

" =======================================================
" OPCIONES GENERALES
" =======================================================
set foldmethod=manual     " It folds a range of text, hiding it from display without actually deleting it
set lazyredraw            " Don’t update screen during macro and script execution
set noshowmode            " Hide the insert status in vim
set number relativenumber " Show line number on the current line and relative numbers on all other lines
set spelllang=en,es       " Corregir palabras usando diccionarios en inglés y español
set splitbelow splitright " Control the position of the new window {ctrl+w + s}
set ttyfast               " Acelera el scroll

" IDENTACION --------------------------------------------
set autoindent    " New lines inherit the indentation of previous lines
set expandtab     " Insertar espacios en lugar de TABs
set shiftwidth=2  " spaces for autoindenting
set softtabstop=2 " remove a full pseudo-TAB when i press <BS>

" TEXTO -------------------------------------------------
" set clipboard^=unnamed,unnamedplus       " In effect, the system clipboard becomes the default register.
" set guicursor=
set mouse=ivh       " disable mouse support in normal mode
set nowrap          " prevents long lines of text from wrapping
set scrolloff=8     " number of screen lines   to keep above and below          the cursor
set sidescrolloff=6 " number of screen columns to keep to the left and right of the cursor

" BUSQUEDA ----------------------------------------------
set ignorecase " Ignorar MAYUS al hacer busquedas
set nohlsearch " Clear search highlights
set smartcase  " No ignorar MAYUS si la palabra contiene mayusculas

" INDENTLINE --------------------------------------------
let g:indentLine_bufNameExclude = [ 'term:.*' ] " oculta las lineas al mostrar el arte ascii
let g:indentLine_char = '┊'
let g:indentLine_defaultGroup = 'Constant'      " con 'SpecialKey' las lineas son grices
set list lcs=tab:\|\                            " NO resalta los TABs. Es una mejora cosmetica.

" EXTRAS ------------------------------------------------
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard'] "Hide files in .gitignore
let g:ctrlp_show_hidden = 1                                                         "Show dotfiles

" NERDTree ----------------------------------------------
let g:NERDTreeQuitOnOpen=1      " Automatically close NERDTree when you open a file

" ATAJOS ------------------------------------------------
" https://stackoverflow.com/a/3776182
" https://getpocket.com/read/3758828321
" https://vrapper.sourceforge.net/documentation/?topic=configuration
" https://tuckerchapman.com/2018/06/16/how-to-use-the-vim-leader-key/
" -------------------------------------------------------
let mapleader = "`"                    " Change Your <leader> Key in Vim
nnoremap <F2> :set nowrap!<CR>        " Los parrafos no tiene salto de linea
nnoremap <F3> :IndentLinesToggle<CR>  " Oculta las lineas / sangrias
nnoremap <F4> :set nu! rnu!<CR>       " Oculta los numeros de lineas
nnoremap <F5> :NERDTreeToggle<CR>     " Panel de archivos
nnoremap tf   :NERDTreeFind<CR>       " Find the current file in the tree.

