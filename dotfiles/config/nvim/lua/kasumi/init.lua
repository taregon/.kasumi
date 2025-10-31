-- ─────────────────────────< GENERAL >─────────────────────────
-- Carga las demás configuraciones
-- INFO: importa el orden
vim.loader.enable()
require("kasumi/vim-plug")
require("kasumi/settings")
require("kasumi/autocmd")
require("kasumi/keymaps")

-- ╒═══════════════════════════════════════════════════════════╕
-- │                           PLUGS                           │
-- ╘═══════════════════════════════════════════════════════════╛
require("kasumi/plugins/catppuccin") -- No mover
-- ────────────────────────────────────────────────────────────
-- require("kasumi/plugins/dressing") -- Lo archivaron
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
require("kasumi/plugins/neo-tree")
require("kasumi/plugins/scrollbar")
require("kasumi/plugins/treesitter")
require("kasumi/plugins/which-key")
require("kasumi/plugins/todo")

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
