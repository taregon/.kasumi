-- ┌────────────────────┐
-- │░█▀█░█▀█░█░█░▀█▀░█▀▀│
-- │░█░█░█▀█░▀▄▀░░█░░█░░│
-- │░▀░▀░▀░▀░░▀░░▀▀▀░▀▀▀│
-- └────────────────────┘
local navic = require("nvim-navic")

navic.setup({
	lsp = { auto_attach = true },
	separator = " ❯ ",
	highlight = true,
	click = true,
})
