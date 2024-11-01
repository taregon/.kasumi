-- Lineas de indentación / sangría
--
require("ibl").setup({
	indent = {
		char = "┊",
		tab_char = "│",
	},
	exclude = {
		filetypes = {
			"checkhealth",
			"comment-box",
			"dashboard",
			"git",
			"help",
			"man",
			"markdown",
			"neo-tree",
			"startify",
			"terminal",
			"text",
		},
		buftypes = {
			"terminal",
			"nofile",
			"quickfix",
			"prompt",
		},
	},
})
