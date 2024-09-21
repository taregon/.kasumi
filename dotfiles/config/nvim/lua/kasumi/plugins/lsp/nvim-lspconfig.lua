-- Configura y gestiona servidores de lenguaje (LSPs) en Neovim
-- Previamente deben estar instalados por medio de mason-lspconfig.lua
local lspconfig = require("lspconfig")

lspconfig.bashls.setup({})
lspconfig.dockerls.setup({})
lspconfig.graphql.setup({})
lspconfig.html.setup({})
lspconfig.jsonls.setup({})
lspconfig.pyright.setup({})

-- Configuración para YAML (YAML Language Server)
lspconfig.yamlls.setup({
	settings = {
		yaml = {
			schemas = {
				kubernetes = "*.yaml", -- Esquema para archivos Kubernetes YAML
			},
		},
	},
})

-- Configuración para Lua (sumneko_lua)
lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" }, -- Reconocer 'vim' como global
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true), -- Soporte para Neovim runtime
				checkThirdParty = false, -- Opcional: Desactivar chequeo de terceros
			},
			telemetry = {
				enable = false, -- Desactivar telemetría
			},
		},
	},
})
