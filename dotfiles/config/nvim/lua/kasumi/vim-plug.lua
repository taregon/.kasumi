-- La primera ves hay que instalar el gestor de plugins *vim-plug*
-- Instalación de Plugins https://stsewd.dev/es/posts/neovim-plugins/
-- Revisar dependencias: nvim +checkhealth

local vim = vim
local Plug = vim.fn["plug#"]

vim.call("plug#begin")

-- TEMAS
Plug("catppuccin/nvim")
Plug("crispybaccoon/aurora")
Plug("lunarvim/horizon.nvim")
Plug("sainnhe/sonokai")
Plug("sho-87/kanagawa-paper.nvim")

-- PLUGINS
Plug("airblade/vim-gitgutter") -- Resalta lineas con cambios git
Plug("echasnovski/mini.nvim") -- Pack de módulos
Plug("folke/which-key.nvim") -- Muestra atajos al comenzar a escribir
Plug("lukas-reineke/indent-blankline.nvim") -- Lineas de identacion
Plug("norcalli/nvim-colorizer.lua") -- Colorea los códigos RGB/HEX
Plug("numToStr/Comment.nvim") -- Para comentar lineas o bloques  con F2 / F3
Plug("nvim-lua/plenary.nvim") -- Depende: cokeline, neo-tree
Plug("nvim-lualine/lualine.nvim") -- Barra de estado
Plug("nvim-treesitter/nvim-treesitter", { ["do"] = "TSUpdate" }) -- Syntax Highlighting / colorea el código
Plug("nvim-treesitter/nvim-treesitter-context") -- una referencia en la parte superior. Debes habilitarlo en el *.lua
Plug("petertriho/nvim-scrollbar") -- Barra de scroll

-- PLUGINS que no requieren "require" obligatoriamente
Plug("mhinz/vim-startify") -- Dashboard
Plug("mechatroner/rainbow_csv") -- Colora archivos CSV
Plug("nvim-tree/nvim-web-devicons") -- Iconos para LUA/Nvim
Plug("MunifTanjim/nui.nvim") -- Depende: neo-tree

-- PLUGINS relacionados con LSP
Plug("WhoIsSethDaniel/mason-tool-installer.nvim") -- Le indicas a mason que linter o formatter instalar
Plug("williamboman/mason-lspconfig.nvim") -- Conecta mason con lspconfig, para instalar los servidores LSP
Plug("neovim/nvim-lspconfig") -- Configura los servidores LSP
Plug("mfussenegger/nvim-lint") -- Configura los linter. Muestra mensajes con relación al formato
Plug("stevearc/conform.nvim") -- Configura los formatter. Da formato al guardar
Plug("williamboman/mason.nvim") -- Instalador de linter, formatter, LSP server
Plug("j-hui/fidget.nvim") -- Barra de carga, para los lsp. Aparece en la esquina abajo

Plug("nvim-neo-tree/neo-tree.nvim") -- Navegador de archivos
Plug("akinsho/bufferline.nvim") -- Muestra los buffer en pestañas
Plug("SmiteshP/nvim-navic") -- Winbar que usa LSP
Plug("Bekaboo/dropbar.nvim") -- Menu en el Winbar
Plug("gbprod/yanky.nvim")
Plug("mbbill/undotree")

-- Auto completado
Plug("hrsh7th/cmp-buffer")
Plug("hrsh7th/cmp-path")
Plug("hrsh7th/nvim-cmp")
-- Plug("L3MON4D3/LuaSnip") -- Motor de snippets

vim.call("plug#end")
