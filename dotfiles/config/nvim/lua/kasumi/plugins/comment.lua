-- AGREGA CIERTAS MEJORAS AL MOMENTO DE COMENTAR
require("Comment").setup({
	ignore = "^$", -- ignora lineas vacías
	-- Modo NORMAL
	toggler = {
		line = "<F2>",
		block = "<F3>",
	},
	-- Modo VISUAL
	opleader = {
		line = "<F2>",
		block = "<F3>",
	},
	-- Desactiva los mappings por defecto del plugin
	mappings = {
		basic = true,
		extra = false,
	},
})
