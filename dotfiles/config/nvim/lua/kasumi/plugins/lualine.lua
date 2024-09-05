local navic = require("nvim-navic")

require("lspconfig").clangd.setup({
	on_attach = function(client, bufnr)
		navic.attach(client, bufnr)
	end,
})

-- Llama a un plug para que indique los cambios en la barra de lualine
local function gitgutter_diff()
	local added, modified, removed = table.unpack(vim.fn["GitGutterGetHunkSummary"]())
	return {
		added = added,
		modified = modified,
		removed = removed,
	}
end

require("lualine").setup({
	options = {
		component_separators = { left = "›", right = "" },
		section_separators = { left = "", right = "" },
		-- theme = "catppuccin-macchiato",
	},
	disabled_filetypes = {
		statusline = {
			"neo-tree",
			"undotree",
		},
		winbar = {
			"neo-tree",
			"undotree",
		},
	},
	winbar = {
		-- lualine_a = {
		-- 	{
		-- 		"buffers",
		-- 		mode = 4,
		-- 		icons_enabled = true,
		-- 		show_filename_only = true,
		-- 		hide_filename_extensions = false,
		-- 	},
		-- },
		lualine_c = { "navic" },
	},
	sections = {
		lualine_b = {
			"branch",
			{
				"diff",
				symbols = {
					added = "󱐮 ",
					modified = "󱐯 ",
					removed = "󱐰 ",
				},
				source = gitgutter_diff,
			},
			"diagnostics",
		},
		lualine_c = {
			{
				"filename",
				path = 1, -- ruta relativa
				shorting_target = 24,
				symbols = {
					modified = "󰧢",
					readonly = "󰦝",
					newfile = "󰽃",
				},
			},
		},
	},
	extensions = {
		"fugitive",
		"neo-tree",
		"quickfix",
	},
})
