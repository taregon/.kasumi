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

local vim = vim -- REVISAR: esta linea la veo innecesaria
local Plug = vim.fn["plug#"]

vim.call("plug#begin")
-- ╒═════════════════════════════════════════════════════════╕
-- │                          TEMAS                          │
-- ╘═════════════════════════════════════════════════════════╛
Plug("catppuccin/nvim", { ["as"] = "catppuccin" })
Plug("crispybaccoon/aurora")
Plug("navarasu/onedark.nvim")
Plug("EdenEast/nightfox.nvim")

-- ╒═════════════════════════════════════════════════════════╕
-- │                         PLUGINS                         │
-- ╘═════════════════════════════════════════════════════════╛
-- Plug("nvim-neo-tree/neo-tree.nvim") -- Navegador de archivos
-- Plug("nvim-treesitter/nvim-treesitter-context") -- una referencia en la parte superior. Debes habilitarlo en el *.lua
Plug("akinsho/bufferline.nvim") -- Lista buffers en formato de pestañas con soporte LSP y diagnósticos
Plug("b0o/incline.nvim") -- Barra flotante por ventana con nombre de buffer y estado contextual
Plug("echasnovski/mini.nvim") -- Colección modular de utilidades ligeras (indent, surround, splitjoin, etc.)
Plug("folke/todo-comments.nvim") -- Detecta y resalta TODO/FIX/NOTE con integración en búsqueda
Plug("folke/which-key.nvim") -- Muestra combinaciones de teclas disponibles en tiempo real
Plug("lewis6991/gitsigns.nvim") -- Indicadores Git en el gutter con acciones por hunk y blame
Plug("LudoPinelli/comment-box.nvim") -- Genera cajas y separadores decorativos en comentarios
Plug("lukas-reineke/indent-blankline.nvim") -- Guías visuales de indentación y alcance de bloques
Plug("MagicDuck/grug-far.nvim") -- Interfaz interactiva para búsqueda y reemplazo masivo (ripgrep)
Plug("MeanderingProgrammer/render-markdown.nvim") -- Renderiza Markdown con estilos e iconos en el buffer
Plug("norcalli/nvim-colorizer.lua") -- Previsualiza colores HEX/RGB directamente en el buffer
Plug("numToStr/Comment.nvim") -- Comentado rápido de líneas y bloques con operadores
Plug("nvim-lualine/lualine.nvim") -- Barra de estado configurable y ligera
Plug("nvim-treesitter/nvim-treesitter") -- Resaltado y parsing sintáctico basado en Treesitter
Plug("olimorris/codecompanion.nvim") -- Integración de asistentes IA dentro de Neovim
Plug("petertriho/nvim-scrollbar") -- Barra de desplazamiento con marcas de diagnóstico y Git
Plug("rmagatti/alternate-toggler") -- Alterna pares de valores opuestos bajo el cursor

-- ────────────────────────────────────────────────────────────
-- PLUGINS que no requieren "require" obligatoriamente
-- ────────────────────────────────────────────────────────────
Plug("ibhagwan/fzf-lua") -- Integración con FZF en Lua (requerido por nvim-bqf)
Plug("kevinhwang91/nvim-bqf") -- Mejora la vista y navegación del quickfix list
Plug("mechatroner/rainbow_csv", { ["for"] = { "csv", "tsv" } }) -- Colora archivos CSV
Plug("mhinz/vim-startify") -- Dashboard
Plug("nvim-lua/plenary.nvim") -- Depende: nvim-bqf, codecompanion
Plug("nvim-tree/nvim-web-devicons") -- Iconos para LUA/Nvim
Plug("sindrets/diffview.nvim") -- Ajustes en settins.lua  Presiona F5 (sin require)
Plug("tpope/vim-fugitive") -- Habilita comandos de git

-- ────────────────────────────────────────────────────────────
-- PLUGINS relacionados con LSP
-- ────────────────────────────────────────────────────────────
Plug("j-hui/fidget.nvim") -- Barra de carga, para los lsp. Aparece en la esquina abajo
Plug("mfussenegger/nvim-lint") -- Configura los linter. Muestra mensajes con relación al formato
Plug("neovim/nvim-lspconfig") -- Configura los servidores LSP
Plug("onsails/lspkind-nvim") -- Iconos para LSP
Plug("SmiteshP/nvim-navic") -- Winbar que usa LSP
Plug("stevearc/conform.nvim") -- Configura los formatter. Da formato al guardar
Plug("WhoIsSethDaniel/mason-tool-installer.nvim") -- Le indicas a mason que linter o formatter instalar
Plug("williamboman/mason-lspconfig.nvim") -- Conecta mason con lspconfig, para instalar los servidores LSP
Plug("williamboman/mason.nvim") -- Instalador de linter, formatter, LSP server

-- ╒═══════════════════════════════════════════════════════════╕
-- │                      AUTO COMPLETADO                      │
-- ╘═══════════════════════════════════════════════════════════╛
Plug("L3MON4D3/LuaSnip") -- Motor de snippets (sin require)
Plug("hrsh7th/cmp-buffer")
Plug("hrsh7th/cmp-nvim-lsp")
Plug("hrsh7th/cmp-path")
Plug("hrsh7th/nvim-cmp")
Plug("junegunn/fzf", {
	["do"] = function()
		vim.fn["fzf#install"]()
	end,
})
Plug("junegunn/fzf.vim")
Plug("saadparwaiz1/cmp_luasnip") -- Así los snippets aparecen en las sugerencias de CMP (sin require)

-- ╒═══════════════════════════════════════════════════════════╕
-- │                  PEND: PLUGS DE PRUEBAS                   │
-- ╘═══════════════════════════════════════════════════════════╛
-- Plug("nvim-telescope/telescope-fzf-native.nvim", { ["do"] = "make" })
-- Plug("nvim-telescope/telescope-live-grep-args.nvim")
-- Plug("nvim-telescope/telescope.nvim", { tag = "0.1.x" })
-- Plug("smoka7/multicursors.nvim") -- Editar multiples lineas
-- Plug("stevearc/dressing.nvim") -- Mejoras en la UI (que hace, no se) y ya pa que, lo archivaron
-- Plug("supermaven-inc/supermaven-nvim")
-- Plug("windwp/nvim-ts-autotag") -- Para renombrará etiquetas de html
-- Plug("nvimdev/lspsaga.nvim") -- Tiene una barra como navic, hay que colocar un require vació.
-- Plug("nvim-pack/nvim-spectre")
-- ────────────────────────────────────────────────────────────
-- FIN
vim.call("plug#end")
