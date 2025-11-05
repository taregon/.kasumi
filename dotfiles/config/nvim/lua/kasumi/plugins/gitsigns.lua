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
	-- Opciones ajustadas (el resto se hereda por defecto)
	attach_to_untracked = true, -- permite mostrar signos en archivos no rastreados
})

-- Color personalizado del signo untracked
-- basado en catppuccin
local catppuccin = require("catppuccin.palettes").get_palette()

vim.api.nvim_set_hl(0, "GitSignsUntracked", { fg = catppuccin.overlay0, bg = "NONE" })
