require("telescope").setup({
	defaults = {
		-- scroll_strategy = "limit",
		-- layout_config = {
		-- 	vertical = {
		-- 		width = 0.5,
		-- 	},
		-- },
		sorting_strategy = "ascending",
		-- layout_strategy = "center",
		file_ignore_patterns = {
			"%.bak",
			"%.gif",
			"%.jpg",
			"%.mp3",
			"%.png",
			"%.svg",
			"%.wav",
			".git/[^h]",
		},
		winblend = 20,
		-- path_display = { "smart" },
		-- prompt_prefix = "",
		borderchars = {
			preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
			results = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
			-- preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
			prompt = { "═", "║", "═", "║", "╔", "╗", "╝", "╚" },
		},
	},
	pickers = {
		find_files = {
			hidden = true,
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			case_mode = "ignore_case",
		},
	},
})

-- Desde aquí se cargan extensiones
-- Ejemplos de uso para fzf:
-- https://github.com/nvim-telescope/telescope-fzf-native.nvim?tab=readme-ov-file#telescope-fzf-nativenvim
require("telescope").load_extension("fzf")
