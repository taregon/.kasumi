-- Lineas de indentación / sangría
--
require("ibl").setup({
	indent = {
		char = "┊",
		tab_char = "│",
	},
	exclude = {
		filetypes = {
			"neo-tree",
			"checkhealth",
			"dashboard",
			"git",
			"help",
			"man",
			"markdown",
			"terminal",
			"text",
			"startify",
		},
		buftypes = {
			"terminal",
			"nofile",
			"quickfix",
			"prompt",
		},
	},
})
