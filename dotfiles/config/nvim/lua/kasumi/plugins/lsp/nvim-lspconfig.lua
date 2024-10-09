-- Configura y gestiona servidores de lenguaje (LSPs) en Neovim
-- Previamente deben estar instalados por medio de mason-lspconfig.lua
local lspconfig = require("lspconfig")
local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.bashls.setup({
	capabilities = lsp_capabilities,
})

lspconfig.dockerls.setup({
	capabilities = lsp_capabilities,
})

lspconfig.graphql.setup({
	capabilities = lsp_capabilities,
})

lspconfig.html.setup({
	capabilities = lsp_capabilities,
})

lspconfig.jsonls.setup({
	capabilities = lsp_capabilities,
})

lspconfig.pyright.setup({
	capabilities = lsp_capabilities,
})

-- Configuración para YAML (YAML Language Server)
lspconfig.yamlls.setup({
	capabilities = lsp_capabilities,
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
	capabilities = lsp_capabilities,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
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
