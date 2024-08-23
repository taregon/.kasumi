local status_ok, ibl = pcall(require, "ibl")
if not status_ok then
	print("Error al cargar el módulo ndent-blankline:", ibl)
end

ibl.setup({ -- Lineas de identacion
	indent = { char = "┊" },
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
