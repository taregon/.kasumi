" La primera ves hay que instalar el gestor de plugins *vim-plug*
"
" Instalación de Plugins https://stsewd.dev/es/posts/neovim-plugins/
" Top 50 Options https://www.shortcutfoo.com/blog/top-50-vim-configuration-options/
" Colores Catppuccin https://github.com/catppuccin/catppuccin/blob/main/docs/style-guide.md
"
" RUTA: ~/.config/nvim/init.vim
" Revisar dependencias: nvim +checkhealth
"  Plug 'romgrk/barbar.nvim'

" =======================================================
" DIRECTORIO DE PLUGINS
" =======================================================
call plug#begin('~/.local/share/nvim/plugged')
  Plug 'catppuccin/nvim', { 'as': 'catppuccin' }                 " - ColorScheme
  Plug 'rebelot/kanagawa.nvim'
  Plug 'navarasu/onedark.nvim'
  Plug 'sainnhe/sonokai'
  Plug 'crispybaccoon/aurora'
  Plug 'savq/melange-nvim'
  Plug 'mellow-theme/mellow.nvim'
  Plug 'echasnovski/mini.nvim'                                   " - Pack de modulos
  Plug 'glepnir/dashboard-nvim'                                  " - Dashboard
  Plug 'norcalli/nvim-colorizer.lua'                             " - Colorea los codigos RGB/HEX
  Plug 'nvim-lualine/lualine.nvim'                               " - Barra de estado
  Plug 'preservim/nerdtree'                                      " - Explorador de archivos
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }  " - Syntax Highlighting
  Plug 'ryanoasis/vim-devicons'                                  " - Iconos
  Plug 'folke/which-key.nvim'                                    " - Muestra atajos al comenzar a escribir
  Plug 'airblade/vim-gitgutter'                                  " - Resalta lineas con cambios git
  Plug 'lukas-reineke/indent-blankline.nvim'                     " - Lineas de identacion
  Plug 'petertriho/nvim-scrollbar'                               " - Barra de scroll
  Plug 'dense-analysis/ale'                                      " - Revisa el codigo / linting and formatting
  Plug 'willothy/nvim-cokeline'                                  " - Para ver buffers
  Plug 'nvim-lua/plenary.nvim'                                   " - Depende: cokeline
  Plug 'tpope/vim-fugitive'
  Plug 'numToStr/Comment.nvim'                                   " - Comenta por lineas o en bloque (/* */)
call plug#end()

" =======================================================
" APARIENCIA
" =======================================================
syntax on         "Habilita syntax highlighting'
set termguicolors "Activa true-colors (24 bits)

" Activar resaltado de sintaxis para archivos INI
au BufReadPost *.conf set syntax=dosini

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

  local u = require("catppuccin.utils.colors")


  local function gitgutter_diff()
    local added, modified, removed = unpack(vim.fn['GitGutterGetHunkSummary']())
    return {
      added = added,
      modified = modified,
      removed = removed
    }
  end

  require('lualine').setup {
    options = {
      component_separators = "",
      section_separators = { left = '', right = '' },
    },
    winbar = {
      lualine_a = {
        {
          'buffers',
          mode = 4,
          icons_enabled = true,
          show_filename_only = true,
          hide_filename_extensions = false
        }
      },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = { 'tabs' }
    },
    extensions = { 'fugitive', 'quickfix' },
    sections = {
      lualine_b = { 'branch', { 'diff', symbols = { added = '󰔧 ', modified = '󱋅 ', removed = '󱕟 ' }, source = gitgutter_diff }, 'diagnostics' },
      lualine_c = {
        {
          'filename',
          path = 1,            -- ruta relativa
          shorting_target = 24,
          symbols = {
            modified = '󰧢',
            readonly = '󰦝',
            newfile  = '󰽃',
          },
        },
      },
    },
  }
  require('catppuccin').setup {
      --    dim_inactive = {
      --      enabled = true,
      --      shade = "dark",
      --      percentage = 0.9,
      --    },
    background = { dark = "macchiato", },
    flavour = "macchiato",
    color_overrides = {
      macchiato = {
        rosewater = "#7d9aa2", -- Links #86b9c7
        flamingo  = "#84719b", -- { | resaltado menu desplegable #bf407b #AC89C9 #AD8FE5
        red       = "#ff6d74", -- ALERTA #e23667 #FF4235 #aa3151 #E54874
        pink      = "#ffa697", -- Tono Rosado | #fa9e9e $ \n { ┊
        mauve     = "#ff97bc", -- Barra (visual) | Comando (set, remap) #ea6a8e #E6527C #ed6a92
        peach     = "#f2bf85", -- Barra (comando) | Valores #F0C483 #ffd1ac
        yellow    = "#FFE78F", -- ALERTA Warning
        green     = "#cceca4", -- Barra (Normar) | ALERTA | STRINGS
        teal      = "#608f8b", -- (plug)
        sky       = "#fff35a", -- < = > >> is not #756cab
        maroon    = "#97a5c3", -- Parametros de script #d89287 #d27990
        sapphire  = "#9EEFC0", -- EOF - Esta bonito
        blue      = "#81d1d3", -- Barra lados #4AC4E5 #75D2EB #27d3d4
        lavender  = "#B087CC", -- Texto en los conf | Nro linea actual #B9CFD4 #a8abbe
        text      = "#f5e8e8", -- Barra: texto #c8c4bb #c3bbb4 #c7c2ce #d7d8da #f7e2d3 #f5e3d6
        subtext1  = "#bdde96",
        overlay2  = "#80a487", -- . , [] () : { Letras menu desplegable
        overlay1  = "#c4c0d0", -- ahora Texto
        overlay0  = "#5a636f", -- Comentarios
        surface2  = "#3d423b", -- Resaltado de linea , caracteres especiales
        surface1  = "#434959", -- Numero de linea
        surface0  = "#2e323c", -- Barra: medio lado, ┊
        base      = "#272c33", -- A. Fondo #1F2127 #2d2d45
        mantle    = "#31353F", -- B. Barra centro & letras
        crust     = "#2e3136", -- C. Divisor de paneles
      },
    },
    integrations = { -- Extiende los colores a los plug soportados
      gitgutter = true,
      mini = {
        enabled = true,
        indentscope_color = "pink",
      },
    },
    styles = { -- Sino sabes que cambia, coloca: standout
      types        = { "bold" },
      booleans     = { "underdotted" },
      numbers      = { "underdotted" },
      functions    = { "italic" },
      comments     = { }, -- NONE
      conditionals = { "italic" },
      properties   = { "italic" },
      keywords     = { "italic" },
      strings      = { }, -- NONE
      variables    = { "altfont"},
      types        = { "altfont" },
      operators    = { "altfont" },
    },
    custom_highlights = function(colors)
      return {
        CursorLine = { bg = u.vary_color({ macchiato =
          u.lighten(colors.base, 0.70, colors.surface1) },
          u.darken(colors.base, 0.70, colors.surface1))        -- https://github.com/catppuccin/nvim/discussions/448#discussioncomment-5560230
        },
        NonText      = { fg = colors.surface2 },
        String       = { fg = colors.subtext1 },
        CursorLineNr = { fg = colors.peach, bg = colors.surface0 },
        -- LineNr = { bg = colors.surface0 },
        -- SignColumn = { bg = colors.surface0 },
      }
    end,
  }
  -- require('barbar').setup()
  require('Comment').setup { -- Comenta de forma inteligente
    ignore = '^$', -- ignora lineas vacias
    -- opleader = {
    --   line = '<F3>',
    --   block = '<Nop>',
    -- },
  }
  require('mini.notify').setup()
  require('cokeline').setup()
  require('colorizer').setup()       -- Habilita los colores HEX
  require('mini.cursorword').setup() -- Subraya palabras bajo el cursor
  require('scrollbar').setup {
    marks = {
      Cursor = {
        text = "◆",
      },
    },
  }
  require("ibl").setup {              -- Lineas de identacion
    indent = { char = "┊" },
  }
  require('which-key').setup ()
  require("which-key.health").check ()
  require('mini.indentscope').setup { -- Animacion del ident
    symbol = '┊',
  }
  require('mini.pairs').setup ()      -- Automaticamente completa el par de {[("'`
  require('mini.align').setup {       -- Habilita los metodos de alineado. https://tinyurl.com/4zp3rts9
    mappings = {
      start = '<F7>',                 -- Atajo solo en VISUAL
    },
  }
  require('nvim-treesitter.configs').setup {
    ensure_installed = "all",         -- Tal vez se colapse la PC
    sync_install = true,
    auto_install = true,

    highlight = {
      enable = true,
      use_languagetree = true,
      additional_vim_regex_highlighting = false,
    },
    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = { "BufWrite", "CursorHold" },
    },
    rainbow = {
      enable = true,
      extended_mode = true,
    },
  }
  -- CARACTERES INVISIBLES
  local vo  = vim.opt
  local cmd = vim.cmd
  vo.list = true     -- habilita el ver caracteres ocultos
  vo.showbreak = "↪"
  vo.listchars = {
    tab      = "→ ",
    eol      = "↲",
    trail    = "•",
    extends  = "⟩",
    precedes = "⟨",
    nbsp     = "☠"
  }
  -- LINTERS
  vim.g.ale_linters = {
    python = { 'flake8' },
    vim = { 'vint' }
    }
  -- FIXERS
  vim.g.ale_fixers = {
    python = {'black', 'isort'},
  }
  -- atajos
  local map = vim.api.nvim_set_keymap
  local NS = { noremap = true, silent = true }
  map('n', '.f', 'gcA', NS)


EOF
" =======================================================
" EL TEMA DEBE CARGAR DESPUES DE LOS AJUSTES DE LUA
" =======================================================
" colorscheme rose-pine-moon
colorscheme catppuccin-macchiato

" =======================================================
" OPCIONES GENERALES
" =======================================================
set cursorline            " Resalta la linea actual
set foldmethod=manual     " It folds a range of text, hiding it from display without actually deleting it
set lazyredraw            " Don’t update screen during macro and script execution
set noshowmode            " Oculta el aviso que indica en que modo estas
set number                " Muestra en numero de linea actual (absoluto)
set relativenumber        " Muestra las lineas relativas al la actual
set spelllang=en,es       " Corregir palabras usando diccionarios en inglés y español
set splitbelow splitright " Control the position of the new window {ctrl+w + s}
set ttyfast               " Acelera el scroll

" hi CursorLine guibg=#b1a6c9

" set backspace=indent,eol,start " NI IDEA


" IDENTACION --------------------------------------------
set autoindent    " New lines inherit the indentation of previous lines
set expandtab     " Utilizar espacios en lugar de TABs
set shiftwidth=2  " Cuando usas TAB. traduce a esa cantidad de espacios
set softtabstop=2 " Cuando eliminas, cuantos espacios debe quitar
set tabstop=2   " Esto solo es visual, ELIMINALO sino llegar a ver los tabs

" TEXTO -------------------------------------------------
" set clipboard^=unnamed,unnamedplus       " In effect, the system clipboard becomes the default register.
" set guicursor=
set mouse=ivh        " disable mouse support in normal mode
set nowrap           " Desactiva el ajuste de linea.
set scrolloff=20     " Mantiene ciertas lineas visibles antes de llegar al final o comienzo
set sidescrolloff=10 " Margen de espacio a la izquierda o derecha

" BUSQUEDA ----------------------------------------------
set hlsearch   " Resalta todas las coincidencias de la búsqueda
set ignorecase " Ignorar MAYUS al hacer busquedas
set incsearch  " Muestra coincidencias a medida que escribes
set magic      " Evita que utiices '\' cuando empleas regex
set smartcase  " No ignorar MAYUS si la palabra contiene mayusculas

" INDENTLINE --------------------------------------------
" set list " Activa la opcion de ver caracteres invisibles
" hi NonText guifg=#4A4749
hi SpecialKey guifg=#AD8FE5
" set listchars=trail:•,eol:↲,extends:›,precedes:‹,nbsp:☠,tab:→\
set fillchars+=vert:│

let g:ale_completion_enabled = 1 "ALE puede proporcionar sugerencias y completar codigo automáticamente
let g:ale_fix_on_save        = 1 "Siempre que guardas, aplica los fixers de ale
let g:ale_fixers = { '*': ['remove_trailing_lines', 'trim_whitespace'], }      " Elimina los espacios el blanco al final de linea y al final del archivo
" let g:ale_linters = { 'python': ['flake8'], }



"set showbreak=↪
"set listchars=nbsp:_
"set listchars=extends:⟩,precedes:⟨, space:·
"set listchars=nbsp:~   ❯  ❮  ^
autocmd VimEnter * match InfoMsg '\s\+$'

" EXTRAS ------------------------------------------------
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard'] "Hide files in .gitignore
let g:ctrlp_show_hidden = 1                                                         "Show dotfiles
" let g:indent_blankline_char_highlight = 'Red'

" NERDTree ----------------------------------------------
let g:NERDTreeQuitOnOpen=1      " Automatically close NERDTree when you open a file

" highlight GitGutterAdd    guifg=#ABF6BF
" highlight GitGutterChange guifg=#FFDD9A
" highlight GitGutterDelete guifg=#FF5549

let g:gitgutter_sign_allow_clobber = 1
let g:gitgutter_sign_added    = '󱐱'
let g:gitgutter_sign_modified = '󰴔'
let g:gitgutter_sign_removed  = '󰯈'
let g:gitgutter_set_sign_backgrounds = 1  " Para que integre el fondo con los iconos

" ATAJOS ------------------------------------------------
" https://stackoverflow.com/a/3776182
" https://getpocket.com/read/3758828321
" https://vrapper.sourceforge.net/documentation/?topic=configuration
" https://tuckerchapman.com/2018/06/16/how-to-use-the-vim-leader-key/
" -------------------------------------------------------
" let mapleader = "\<Space>"                    " Change Your <leader> Key in Vimi

let mapleader = ","
nnoremap <F2> :set nowrap!<CR>         " Los parrafos no tiene salto de linea
" nnoremap <F3> :IndentLinesToggle<CR>   " Oculta las lineas / sangrias
nnoremap <F4> :set nu! rnu!<CR>        " Oculta los numeros de lineas
nnoremap <F5> :NERDTreeToggle<CR>      " Panel de archivos
nnoremap tf   :NERDTreeFind<CR>        " Find the current file in the tree.
nmap h[  <Plug>(GitGutterPrevHunk)
nmap h]  <Plug>(GitGutterNextHunk)
nmap hhs <Plug>(GitGutterStageHunk)
nmap hhu <Plug>(GitGutterUndoHunk)
" nmap <leader>hp <Plug>(GitGutterPreviewHunk)

" nnoremap - :new<CR>
" nnoremap \| :vnew<CR>

nnoremap <C-->     :vsplit<CR>
nnoremap <C-=>     :split<CR>
" nnoremap <silent>  <C-S-Right> <cmd>vertical resize -2<CR>
" nnoremap <silent>  <C-S-Left>  <cmd>vertical resize +2<CR>
" nnoremap <silent>  <C-S-Up>    <cmd>resize   -2<CR>
" nnoremap <silent>  <C-S-Down>  <cmd>resize   +2<CR>
nnoremap <SPACE>   <Nop>
nnoremap <M-q>     :q<CR>
nnoremap <leader>q :copen<CR>
nnoremap <leader>Q :cclose<CR>

nnoremap Y y$
