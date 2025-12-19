require("fzf-lua").setup({
	winopts = {
		border = "single",
	},
	preview = {
		-- layout = "vertical", -- o 'horizontal', según prefieras
		-- vertical = "down:45%", -- tamaño relativo de la vista previa
		border = "single",
	},
})

require("bqf").setup({
	preview = {
		border = "single",
	},
})
