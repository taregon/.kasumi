-- ╒═══════════════════════════════════════════════════════════╕
-- │                 NEOVIM MAIN CONFIGURATION                 │
-- ╘═══════════════════════════════════════════════════════════╛
-- Configuración principal de Neovim. Define:
--    - Carga inicial de plugins y ajustes base.
--    - Integración con LSP, autocompletado, formato y diagnóstico.
--    - Configuración visual y atajos globales.
-- Se recomienda dividir en módulos la configuración.
-- para facilitar mantenimiento y depuración.
-- WARN: El orden de las líneas define la secuencia de carga
-- ─────────────────────────< GENERAL >─────────────────────────
vim.loader.enable()
require("kasumi/vim-plug")
require("kasumi/settings")
require("kasumi/autocmd")
require("kasumi/keymaps") -- PEND: Evaluar la posibilidad de mover esta linea a which-key

-- ╒═══════════════════════════════════════════════════════════╕
-- │                        COLORSCHEME                        │
-- ╘═══════════════════════════════════════════════════════════╛
require("kasumi/plugins/catppuccin") -- No mover

-- ╒═══════════════════════════════════════════════════════════╕
-- │                           PLUGS                           │
-- ╘═══════════════════════════════════════════════════════════╛
-- require("kasumi/plugins/lsp/nvim-navbuddy")
-- require("kasumi/plugins/lsp/nvim-supermaven") -- se me acabo el demo
-- require("kasumi/plugins/nvim-web-devicons") -- Esta de mas por que no tengo ajustes
-- require("kasumi/plugins/telescope") -- Ta potente el asunto
require("kasumi/plugins/bufferline")
require("kasumi/plugins/colorizer")
require("kasumi/plugins/comment")
require("kasumi/plugins/comment-box")
require("kasumi/plugins/fidget")
require("kasumi/plugins/gitsigns")
require("kasumi/plugins/diffview")
require("kasumi/plugins/indent-blankline")
require("kasumi/plugins/lualine")
require("kasumi/plugins/mini")
-- require("kasumi/plugins/neo-tree")
require("kasumi/plugins/scrollbar")
require("kasumi/plugins/treesitter")
require("kasumi/plugins/which-key")
require("kasumi/plugins/todo")
-- require("kasumi/plugins/fzf")
require("kasumi/plugins/bqf") -- Quickfix integrada con fzf
require("kasumi/plugins/ai/codecompanion")
require("kasumi/plugins/render-markdown")
-- require("kasumi/plugins/spectre")
-- ╒═══════════════════════════════════════════════════════════╕
-- │                   Formatting & Linting                    │
-- ╘═══════════════════════════════════════════════════════════╛
-- ─[ 1. Gestores de herramientas ]──────────────────────────
require("kasumi/plugins/lsp/mason")
require("kasumi/plugins/lsp/mason-tool-installer")

-- ─[ 2. Configuración base del LSP ]────────────────────────
require("kasumi/plugins/lsp/nvim-lspconfig")

-- ─[ 3. Integración Mason-LSP ]─────────────────────────────
require("kasumi/plugins/lsp/mason-lspconfig")

-- ─[ 4. Complementos ]──────────────────────────────────────
require("kasumi/plugins/lsp/nvim-cmp") -- Autocompletado
require("kasumi/plugins/lsp/nvim-lint") -- Linter
require("kasumi/plugins/lsp/conform") -- Formateador

-- ╒═══════════════════════════════════════════════════════════╕
-- │                          WIN BAR                          │
-- ╘═══════════════════════════════════════════════════════════╛
require("kasumi/plugins/lsp/nvim-navic")
require("kasumi/plugins/incline")
