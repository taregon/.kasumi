-- Lineas de indentación / sangría
--
require("ibl").setup({
	indent = {
		char = "│",
		tab_char = "│", -- hack para los tabs. Sino saldrían flechas
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
