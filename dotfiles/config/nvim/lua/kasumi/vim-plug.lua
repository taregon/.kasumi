-- ██╗   ██╗██╗███╗   ███╗██████╗ ██╗     ██╗   ██╗ ██████╗
-- ██║   ██║██║████╗ ████║██╔══██╗██║     ██║   ██║██╔════╝
-- ██║   ██║██║██╔████╔██║██████╔╝██║     ██║   ██║██║  ███╗
-- ╚██╗ ██╔╝██║██║╚██╔╝██║██╔═══╝ ██║     ██║   ██║██║   ██║
--  ╚████╔╝ ██║██║ ╚═╝ ██║██║     ███████╗╚██████╔╝╚██████╔╝
--   ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝     ╚══════╝ ╚═════╝  ╚═════╝
-- La primera ves hay que instalar el gestor de plugins *vim-plug
-- Instalación: https://stsewd.dev/es/posts/neovim-plugins
-- Revisar dependencias: nvim +checkhealth
-- Lazy-loading: ['for'] define los filetypes que activan el plugin.

local Plug = vim.fn["plug#"]

vim.call("plug#begin")

-- ╒═════════════════════════════════════════════════════════╕
-- │                          TEMAS                          │
-- ╘═════════════════════════════════════════════════════════╛
Plug("catppuccin/nvim", { ["as"] = "catppuccin" }) -- Tema Mocha/Macchiato/Latte con colores pastel y alto personalizable
Plug("crispybaccoon/aurora") -- Tema cálido inspirado en Nord para programación acogedora
Plug("navarasu/onedark.nvim") -- Tema oscuro/claro basado en Atom One Dark (8 variantes de estilo)
Plug("EdenEast/nightfox.nvim") -- Tema personalizable con soporte LSP, treesitter y 7 variantes (nightfox, dayfox...)

-- ╒═════════════════════════════════════════════════════════╕
-- │                         PLUGINS                         │
-- ╘═════════════════════════════════════════════════════════╛
-- Plug("MeanderingProgrammer/render-markdown.nvim") -- Renderiza Markdown con estilos e iconos en el buffer
-- Plug("norcalli/nvim-colorizer.lua") -- Previsualiza colores HEX/RGB directamente en el buffer
-- Plug("nvim-neo-tree/neo-tree.nvim") -- Navegador de archivos
Plug("akinsho/bufferline.nvim") -- Lista buffers en formato de pestañas con soporte LSP y diagnósticos
Plug("b0o/incline.nvim") -- Barra flotante por ventana con nombre de buffer y estado contextual
Plug("brenoprata10/nvim-highlight-colors") -- Resalta colores HEX/RGB/HSL/named en tiempo real con fondo, texto o virtual text
Plug("echasnovski/mini.nvim") -- Colección modular de utilidades ligeras (mini.ai, mini.surround, mini.pairs, etc.)
Plug("folke/todo-comments.nvim") -- Detecta y resaltado TODO/FIX/NOTE con integración en búsqueda y Telescope
Plug("folke/which-key.nvim") -- Muestra combinaciones de teclas disponibles en popup al escribir atajos
Plug("lewis6991/gitsigns.nvim") -- Indicadores Git en gutter (signs) con acciones por hunk y blame en línea
Plug("LudoPinelli/comment-box.nvim") -- Genera cajas y separadores decorativos en comentarios (22 estilos predefined)
Plug("lukas-reineke/indent-blankline.nvim") -- Guías visuales de indentación y alcance de bloques con soporte treesitter
Plug("MagicDuck/grug-far.nvim") -- Interfaz interactiva para búsqueda y reemplazo masivo con ripgrep
Plug("numToStr/Comment.nvim") -- Comentado rápido de líneas y bloques con operadores (gc, gcc, gcb)
Plug("nvim-lualine/lualine.nvim") -- Barra de estado configurable y ligera con soporte themes
Plug("olimorris/codecompanion.nvim") -- Integración de asistentes IA (CodeGPT, Codeium, Copilot) dentro de Neovim
Plug("OXY2DEV/markview.nvim") -- Preview de Markdown, LaTeX, Typst, HTML y Asciidoc con modo híbrido y splitview
Plug("petertriho/nvim-scrollbar") -- Barra de desplazamiento con marcas de diagnóstico, Git y search
Plug("rmagatti/alternate-toggler") -- Alterna pares de valores opuestos bajo el cursor (true/false, yes/no, etc.)
Plug("Wansmer/treesj") -- Divide/une bloques de código (arrays, objetos, funciones) usando Treesitter
Plug("romus204/tree-sitter-manager.nvim")

-- ────────────────────────────────────────────────────────────
-- PLUGINS que no requieren "require" obligatoriamente
-- ────────────────────────────────────────────────────────────
Plug("ibhagwan/fzf-lua") -- Integración con FZF en Lua (requerido por nvim-bqf y Telescope)
Plug("kevinhwang91/nvim-bqf") -- Mejora la vista y navegación del quickfix list con preview
Plug("mechatroner/rainbow_csv", { ["for"] = { "csv", "tsv" } }) -- Colorea archivos CSV/TSV con columnas diferenciadas y Rainbow
Plug("mhinz/vim-startify") -- Dashboard con pantalla de inicio personalizable
Plug("nvim-lua/plenary.nvim") -- Dependencia: nvim-bqf, codecompanion, todo-comments, fidget
Plug("nvim-tree/nvim-web-devicons") -- Iconos para Lua/Neovim (requerido por muchos plugins)
Plug("sindrets/diffview.nvim") -- Panel de diff interactivo para compares de Git
Plug("tpope/vim-fugitive") -- Comandos de Git (:Git, :G status, :G blame, :G log, etc.)

-- ────────────────────────────────────────────────────────────
-- PLUGINS relacionados con LSP
-- ────────────────────────────────────────────────────────────
Plug("j-hui/fidget.nvim") -- Barra de carga de LSP en la esquina inferior (status notifications)
Plug("mfussenegger/nvim-lint") -- Linter asíncrono con múltiples motores (eslint, pylint, golint...)
Plug("neovim/nvim-lspconfig") -- Configura servidores LSP (pyright, tsserver, rust_analyzer, etc.)
Plug("onsails/lspkind-nvim") -- Iconos para autocompletado LSP (method, property, snippet, etc.)
Plug("SmiteshP/nvim-navic") -- Winbar/breadcrumb que muestra ubicación LSP (función, clase, scope)
Plug("stevearc/conform.nvim") -- Formateador al guardar con soporte 80+ formatters
Plug("WhoIsSethDaniel/mason-tool-installer.nvim") -- Instala automáticamente linters/formatters para Mason
Plug("williamboman/mason.nvim") -- Instalador de LSP servers, linters y formatters (interfaz unificada)

-- ╒═══════════════════════════════════════════════════════════╕
-- │                      AUTO COMPLETADO                      │
-- ╘═══════════════════════════════════════════════════════════╛
Plug("L3MON4D3/LuaSnip") -- Motor de snippets con soporte VS Code, SnipMate y Lua
Plug("hrsh7th/cmp-buffer") -- Completado de palabras en buffers abiertos
Plug("hrsh7th/cmp-nvim-lsp") -- Completado de símbolos LSP (functions, fields, methods)
Plug("hrsh7th/cmp-nvim-lua") -- Completado de APIs de Neovim (vim.api, vim.lsp, etc)
Plug("hrsh7th/cmp-path") -- Completado de rutas de archivos
Plug("hrsh7th/nvim-cmp") -- Motor de autocompletado principal
Plug("junegunn/fzf", {
	["do"] = function()
		vim.fn["fzf#install"]()
	end,
}) -- Fuzzy finder CLI (instala binary de fzf)
Plug("junegunn/fzf.vim") -- Plugins de FZF para Vim (Rg, Files, Buffers, etc.)
Plug("saadparwaiz1/cmp_luasnip") -- Integración de LuaSnip con nvim-cmp

-- ╒═══════════════════════════════════════════════════════════╕
-- │                  PEND: PLUGS DE PRUEBAS                   │
-- ╘═══════════════════════════════════════════════════════════╛
-- Plug("epwalsh/obsidian.nvim")
-- Plug("nvim-pack/nvim-spectre")
-- Plug("nvim-telescope/telescope-fzf-native.nvim", { ["do"] = "make" })
-- Plug("nvim-telescope/telescope-live-grep-args.nvim")
-- Plug("nvim-telescope/telescope.nvim", { tag = "0.1.x" })
-- Plug("nvimdev/lspsaga.nvim") -- Tiene una barra como navic, hay que colocar un require vació.
-- Plug("smoka7/multicursors.nvim") -- Editar multiples lineas
-- Plug("stevearc/dressing.nvim") -- Mejoras en la UI (que hace, no se) y ya pa que, lo archivaron
-- Plug("williamboman/mason-lspconfig.nvim") -- Conecta Mason con LSPConfig para instalar servidores LSP
-- Plug("windwp/nvim-ts-autotag") -- Para renombrará etiquetas de html
Plug("lanej/hotreload.nvim") -- Recarga automática de archivos visibles cuando cambian en disco

-- ────────────────────────────────────────────────────────────
-- FIN
vim.call("plug#end")
