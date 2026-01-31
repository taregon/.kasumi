-- ┌────────────────────────────────┐
-- │░█▀▀░▀█▀░▀█▀░█▀▀░▀█▀░█▀▀░█▀█░█▀▀│
-- │░█░█░░█░░░█░░▀▀█░░█░░█░█░█░█░▀▀█│
-- │░▀▀▀░▀▀▀░░▀░░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀│
-- └────────────────────────────────┘
require("gitsigns").setup({
	signs = {
        -- stylua: ignore start
		add          = { text = "󱐱" },
		change       = { text = "󰴔" },
		delete       = { text = "󱐳" },
		topdelete    = { text = "󱐳" },
		changedelete = { text = "󰴔" },
		untracked    = { text = "󰛞" },
		-- stylua: ignore end
	},
	signs_staged = {
        -- stylua: ignore start
		add          = { text = "󱐱" },
		change       = { text = "󰴔" },
		delete       = { text = "󱐳" },
		topdelete    = { text = "󱐳" },
		changedelete = { text = "󰴔" },
		untracked    = { text = "󰛞" },
		-- stylua: ignore end
	},
	attach_to_untracked = true, -- Adjunta gitsigns a archivos nuevos archivos no rastreados
	current_line_blame = true, -- Muestra automáticamente el autor y commit de la línea actual
	current_line_blame_opts = {
		delay = 1500, -- Espera (ms) antes de mostrar el blame virtual
		ignore_whitespace = true, -- Ignora commits donde solo cambió el espaciado
		virt_text_pos = "right_align", -- Texto virtual alineado a la derecha (default: "eol")
	},
	max_file_length = 10000, -- Evita gitsigns en archivos grandes
	update_debounce = 300, -- Prioriza estabilidad sobre reacción inmediata
})

-- Color personalizado del signo untracked
-- basado en catppuccin
local catppuccin = require("catppuccin.palettes").get_palette()

vim.api.nvim_set_hl(0, "GitSignsUntracked", { fg = catppuccin.overlay0, bg = "NONE" })
