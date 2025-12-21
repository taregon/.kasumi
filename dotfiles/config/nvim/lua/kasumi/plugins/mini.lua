require("mini.animate").setup() -- El efecto cuando haces scroll

-- DIVIDE LOS ARGUMENTOS SI ESTÁN EN UNA SOLA LÍNEA, DE LO CONTRARIO LOS UNE
-- Atajo por defecto: gS
require("mini.splitjoin").setup({
	mappings = {
		toggle = "<F4>",
	},
})

-- MUEVE EL TEXTO
require("mini.move").setup({
	mappings = {
		left = "mh",
		right = "ml",
		down = "mj",
		up = "mk",

		line_left = "mh",
		line_right = "ml",
		line_down = "mj",
		line_up = "mk",
	},
})

-- SUBRAYA PALABRAS BAJO EL CURSOR
require("mini.cursorword").setup()

-- Animación del indent scope
-- Las otras lineas verticales están en indent-blankline
require("mini.indentscope").setup({
	symbol = "┆",
	draw = {
		delay = 300, -- en ms
		priority = 50,
	},
})

-- AUTOMÁTICAMENTE COMPLETA EL PAR DE {[("'`
require("mini.pairs").setup()

-- HABILITA LOS MÉTODOS DE ALINEADO.
-- https://tinyurl.com/4zp3rts9
require("mini.align").setup({
	-- Atajo solo en VISUAL
	mappings = {
		start = "<F12>",
	},
})

-- MANIPULA DELIMITADORES DE TEXTO: PARÉNTESIS, CORCHETES Y COMILLAS.
-- require("mini.surround").setup({
-- 	mappings = {
-- 		add = "<leader>sa", -- Añadir delimitador
-- 		delete = "<leader>sd", -- Eliminar delimitador
-- 		replace = "<leader>sr", -- Reemplazar delimitador
-- 		highlight = "<leader>sh", -- Resaltar delimitador
-- 	},
-- 	search_method = "cover_or_nearest", -- cómo buscar delimitadores
-- 	highlight_duration = 250, -- duración del resaltado en ms
-- })
