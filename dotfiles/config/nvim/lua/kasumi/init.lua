vim.loader.enable()
-- Nota: importa el orden
require("kasumi/vim-plug")
require("kasumi/settings")
require("kasumi/autocmd")
require("kasumi/keymaps")

-- PLUGS
require("kasumi/plugins/catppuccin")
require("kasumi/plugins/colorizer")
require("kasumi/plugins/comment")
require("kasumi/plugins/gitgutter")
require("kasumi/plugins/indent-blankline")
require("kasumi/plugins/lualine")
require("kasumi/plugins/mini")
require("kasumi/plugins/scrollbar")
require("kasumi/plugins/treesitter")
require("kasumi/plugins/which-key")
require("kasumi/plugins/fidget")
require("kasumi/plugins/neo-tree")
require("kasumi/plugins/bufferline")

-- Formatting & Linting
require("kasumi/plugins/lsp/conform")
require("kasumi/plugins/lsp/mason")
require("kasumi/plugins/lsp/mason-lspconfig")
require("kasumi/plugins/lsp/mason-tool-installer")
require("kasumi/plugins/lsp/nvim-cmp")
require("kasumi/plugins/lsp/nvim-lint")
require("kasumi/plugins/lsp/nvim-lspconfig")
-- require("kasumi/plugins/lsp/nvim-supermaven")

-- require("kasumi/plugins/lsp/nvim-navbuddy")

-- WIN BAR
require("kasumi/plugins/lsp/nvim-navic")
