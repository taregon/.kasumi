-- ┌──────────────────────────────────────────┐
-- │░█░░░█▀▀░█▀█░░░█▀▀░█▀▀░█▀▄░█░█░█▀▀░█▀▄░█▀▀│
-- │░█░░░▀▀█░█▀▀░░░▀▀█░█▀▀░█▀▄░▀▄▀░█▀▀░█▀▄░▀▀█│
-- │░▀▀▀░▀▀▀░▀░░░░░▀▀▀░▀▀▀░▀░▀░░▀░░▀▀▀░▀░▀░▀▀▀│
-- └──────────────────────────────────────────┘
-- Conecta "mason.nvim" con "nvim-lspconfig" para facilitar
-- la INSTALACIÓN de servidores de lenguaje (LSP)
-- Los ajustes los realizas en "nvim-lspconfig"

require("mason-lspconfig").setup({
	ensure_installed = {
		"awk_ls",
		"bashls",
		"dockerls",
		"graphql",
		"html",
		"jsonls",
		"lua_ls",
		"pyright",
		"sqlls",
		"yamlls",
	},
	automatic_installation = true,
})
