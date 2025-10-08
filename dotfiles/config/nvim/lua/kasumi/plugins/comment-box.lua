-- ┌───────────────────────────────────────────┐
--   Algunos ajustes para que las lineas
--   presenten la misma longitud que las cajas
-- └───────────────────────────────────────────┘
--
require("comment-box").setup({
	doc_width = 80, -- Se usa para centrar las cajas y las líneas generadas.
	box_width = 62, -- Debe ser menor o igual a `doc_width` para que encaje correctamente
	line_width = 60, -- Longitud de las líneas horizontales. Se recomienda mantener coherencia con `box_width`.
	outer_blank_lines_above = true, -- Deja líneas en blanco antes de..., para mejorar la separación visual.
})
