require("telescope").setup({
	defaults = {
		scroll_strategy = "limit",
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
	},
	pickers = {
		find_files = {
			hidden = true,
		},
	},
	-- extensions = {
	-- 	fzf = {
	-- 		fuzzy = true, -- false will only do exact matching
	-- 		override_generic_sorter = true, -- override the generic sorter
	-- 		override_file_sorter = true, -- override the file sorter
	-- 		case_mode = "smart_case", -- or "ignore_case" or "respect_case"
	-- 	},
	-- },
})

-- require("telescope").load_extension("live_grep_args")
require("telescope").load_extension("fzf")
