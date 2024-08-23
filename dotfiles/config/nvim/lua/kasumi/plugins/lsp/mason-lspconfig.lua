-- Conecta "mason.nvim" con "nvim-lspconfig" para facilitar la instalación y
-- configuración de servidores de lenguaje (LSP)

require("mason-lspconfig").setup({
	ensure_installed = {
		"bashls",
		"dockerls",
		"jsonls",
		"lua_ls",
		"yamlls",
	},
	automatic_installation = true,
})
