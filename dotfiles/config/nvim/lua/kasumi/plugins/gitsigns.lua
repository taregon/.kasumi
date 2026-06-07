-- ┌────────────────────────────────┐
-- │░█▀▀░▀█▀░▀█▀░█▀▀░▀█▀░█▀▀░█▀█░█▀▀│
-- │░█░█░░█░░░█░░▀▀█░░█░░█░█░█░█░▀▀█│
-- │░▀▀▀░▀▀▀░░▀░░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀│
-- └────────────────────────────────┘
-- Integra Git en Neovim:
--  - Muestra signos en el margen para líneas añadidas, modificadas o eliminadas
--  - Permite navegar, hacer stage/reset de hunks directamente desde el editor
--  - Ofrece blame en línea para ver autor, fecha y commit de cada línea
--  - Abre preview flotante con el diff del hunk actual
--  - Incluye comandos de diff y estado del repositorio sin salir de Neovim

require("gitsigns").setup({
    -- stylua: ignore start
	signs = {
		add          = { text = "󱐱" },
		change       = { text = "󰴔" },
		delete       = { text = "󱐳" },
		topdelete    = { text = "󱐳" },
		changedelete = { text = "󰴔" },
		untracked    = { text = "󰛞" },
	},
	signs_staged = {
		add          = { text = "󱐱" },
		change       = { text = "󰴔" },
		delete       = { text = "󱐳" },
		topdelete    = { text = "󱐳" },
		changedelete = { text = "󰴔" },
		untracked    = { text = "󰛞" },
	},
	-- stylua: ignore end
	attach_to_untracked = true, -- Adjunta gitsigns a archivos nuevos archivos no rastreados
	current_line_blame = true, -- Muestra automáticamente el autor y commit de la línea actual
	current_line_blame_opts = {
		delay = 1500, -- Espera (ms) antes de mostrar el blame virtual
		ignore_whitespace = true, -- Ignora commits donde solo cambió el espaciado
		virt_text_pos = "right_align", -- Texto virtual alineado a la derecha (default: "eol")
	},
	max_file_length = 10000, -- Evita gitsigns en archivos grandes
	update_debounce = 400, -- Tiempo de espera (ms) antes de actualizar los indicadores de Git tras una edición.

	-- Controla cómo se muestra la ventana flotante al usar preview_hunk.
	preview_config = {
		border = "single", -- Borde recto doble
		style = "minimal", -- Contenido simplificado
		relative = "cursor", -- Posición relativa al editor
		row = 1, -- Ajusta posición vertical
		col = 3, -- Ajusta posición horizontal
		-- width = 36, -- Ancho de la ventana
		-- height = 20, -- Alto de la ventana
	},
})

-- Define el color del indicador "untracked"
-- tomando como referencia la paleta Catppuccin ^. .^₎⟆
local catppuccin = require("catppuccin.palettes").get_palette()

vim.api.nvim_set_hl(0, "GitSignsUntracked", { fg = catppuccin.overlay0, bg = "NONE" })
