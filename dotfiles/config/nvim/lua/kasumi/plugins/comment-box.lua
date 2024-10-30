-- ┌───────────────────────────────────────────┐
--   Algunos ajustes para que las lineas
--   presenten la misma longitud que las cajas
-- └───────────────────────────────────────────┘
--
require("comment-box").setup({
	doc_width = 80, -- Width of the document. It is used to center the boxes and lines.
	box_width = 62, -- Width of the fixed size boxes (must be <= doc_width).
	line_width = 60,
})
