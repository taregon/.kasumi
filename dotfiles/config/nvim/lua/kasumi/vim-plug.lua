-- La primera ves hay que instalar el gestor de plugins *vim-plug
-- Instalación: https://stsewd.dev/es/posts/neovim-plugins
-- Revisar dependencias: nvim +checkhealth

local vim = vim
local Plug = vim.fn["plug#"]

vim.call("plug#begin")

-- ╒═════════════════════════════════════════════════════════╕
-- │                          TEMAS                          │
-- ╘═════════════════════════════════════════════════════════╛
-- Plug("AlexvZyl/nordic.nvim")
-- Plug("chriskempson/base16-vim")
-- Plug("lunarvim/horizon.nvim")
-- Plug("rose-pine/neovim")
Plug("catppuccin/nvim", { ["as"] = "catppuccin" })
Plug("crispybaccoon/aurora")
Plug("navarasu/onedark.nvim")
Plug("profesorpaiche/toytiza.nvim")
Plug("shawilly/ponokai")
Plug("vague2k/vague.nvim")

-- ╒═════════════════════════════════════════════════════════╕
-- │                         PLUGINS                         │
-- ╘═════════════════════════════════════════════════════════╛
Plug("LudoPinelli/comment-box.nvim") -- Agrega atajos para comentar con boxes
Plug("airblade/vim-gitgutter") -- Resalta lineas con cambios git
Plug("akinsho/bufferline.nvim") -- Muestra los buffer en pestañas
Plug("echasnovski/mini.nvim") -- Pack de módulos. Tengo varios en uso
Plug("folke/which-key.nvim") -- Muestra atajos al comenzar a escribir
Plug("iamcco/markdown-preview.nvim", { ["do"] = "cd app && npx --yes yarn install" }) -- Vista previa de markdown
Plug("lukas-reineke/indent-blankline.nvim") -- Lineas de identacion
Plug("norcalli/nvim-colorizer.lua") -- Colorea los códigos RGB/HEX
Plug("numToStr/Comment.nvim") -- Para comentar lineas o bloques  con F2 / F3
Plug("nvim-lua/plenary.nvim") -- Depende: cokeline, neo-tree
Plug("nvim-lualine/lualine.nvim") -- Barra de estado
Plug("nvim-neo-tree/neo-tree.nvim") -- Navegador de archivos
Plug("nvim-treesitter/nvim-treesitter", { ["do"] = ":TSUpdate" }) -- Syntax Highlighting / colorea el código
Plug("nvim-treesitter/nvim-treesitter-context") -- una referencia en la parte superior. Debes habilitarlo en el *.lua
Plug("petertriho/nvim-scrollbar") -- Barra de scroll

-- PLUGINS que no requieren "require" obligatoriamente
-- ────────────────────────────────────────────────────────────
Plug("nvim-tree/nvim-web-devicons") -- Iconos para LUA/Nvim
-- Plug("DaikyXendo/nvim-material-icon") -- Alternativa a nvim-web-devicons
Plug("MunifTanjim/nui.nvim") -- Depende: neo-tree
Plug("mechatroner/rainbow_csv") -- Colora archivos CSV
Plug("mhinz/vim-startify") -- Dashboard
Plug("tpope/vim-fugitive") -- Habilita comandos de git

-- PLUGINS relacionados con LSP
-- ────────────────────────────────────────────────────────────
Plug("SmiteshP/nvim-navic") -- Winbar que usa LSP
Plug("WhoIsSethDaniel/mason-tool-installer.nvim") -- Le indicas a mason que linter o formatter instalar
Plug("j-hui/fidget.nvim") -- Barra de carga, para los lsp. Aparece en la esquina abajo
Plug("mfussenegger/nvim-lint") -- Configura los linter. Muestra mensajes con relación al formato
Plug("neovim/nvim-lspconfig") -- Configura los servidores LSP
Plug("onsails/lspkind-nvim") -- Iconos para LSP
Plug("stevearc/conform.nvim") -- Configura los formatter. Da formato al guardar
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
Plug("junegunn/fzf", { ["do"] = vim.fn["fzf#install()"] })
Plug("junegunn/fzf.vim")
Plug("saadparwaiz1/cmp_luasnip") -- Así los snippets aparecen en las sugerencias de CMP (sin require)

-- ╒═══════════════════════════════════════════════════════════╕
-- │                       Probando FIX                        │
-- ╘═══════════════════════════════════════════════════════════╛
-- Plug("folke/todo-comments.nvim") -- Resalta las lineas con comentarios
Plug("nvim-telescope/telescope-fzf-native.nvim", { ["do"] = "make" })
Plug("nvim-telescope/telescope-live-grep-args.nvim")
Plug("nvim-telescope/telescope.nvim", { tag = "0.1.x" })
Plug("sindrets/diffview.nvim") -- sin require
Plug("stevearc/dressing.nvim") -- Mejoras en la UI (que hace, no se)
Plug("supermaven-inc/supermaven-nvim")
Plug("windwp/nvim-ts-autotag") -- Para renombrará etiquetas de html

vim.call("plug#end")
