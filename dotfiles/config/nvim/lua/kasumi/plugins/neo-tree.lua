require("neo-tree").setup({
	popup_border_style = "single",
	source_selector = {
		winbar = false,
		statusline = false,
	},
	filesystem = {
		follow_current_file = {
			enabled = true,
		},
	},
	event_handlers = {
		{
			-- Mantener el foco en el panel de Neo-tree después de abrir un archivo
			event = "file_opened",
			handler = function()
				vim.cmd("wincmd p")
			end,
		},
	},
	default_component_configs = {
		git_status = {
			symbols = {
				untracked = "󰘥",
				unstaged = "󰦘", -- "󰿦"
			},
		},
	},
})
