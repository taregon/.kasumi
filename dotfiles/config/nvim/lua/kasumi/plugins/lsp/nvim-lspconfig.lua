-- Configura y gestiona servidores de lenguaje (LSPs) en Neovim
local lspconfig = require("lspconfig")

lspconfig.dockerls.setup({})
lspconfig.jsonls.setup({})
lspconfig.bashls.setup({})
-- lspconfig.bashls.setup({
-- 	settings = {
-- 		bashIde = {
-- 			globPattern = "*@(.sh|.inc|.bash|.command)", -- Definir patrones de archivos
-- 		},
-- 	},
-- })

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
				-- library = vim.api.nvim_get_runtime_file("", true), -- Soporte para Neovim runtime
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false, -- Opcional: Desactivar chequeo de terceros
			},
			telemetry = {
				enable = false, -- Desactivar telemetría
			},
		},
	},
})
