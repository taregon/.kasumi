-- ██╗     ██╗   ██╗ █████╗ ██╗     ██╗███╗   ██╗███████╗
-- ██║     ██║   ██║██╔══██╗██║     ██║████╗  ██║██╔════╝
-- ██║     ██║   ██║███████║██║     ██║██╔██╗ ██║█████╗
-- ██║     ██║   ██║██╔══██║██║     ██║██║╚██╗██║██╔══╝
-- ███████╗╚██████╔╝██║  ██║███████╗██║██║ ╚████║███████╗
-- ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═══╝╚══════╝
local lualine = require("lualine")

-- ─[ CATPPUCCIN ]───────────────────────────────────────────
local catppuccin = require("catppuccin.palettes").get_palette()
local u = require("catppuccin.utils.colors")

-- Función global para obtener el color basado en el modo actual de nvim
local function get_mode_color()
	local mode_color = {
		n = u.darken(catppuccin.blue, 0.5, catppuccin.base), -- Normal mode
		i = u.darken(catppuccin.green, 0.5, catppuccin.base), -- Insert mode
		v = u.darken(catppuccin.mauve, 0.5, catppuccin.base), -- Visual mode
		V = u.darken(catppuccin.mauve, 0.5, catppuccin.base), -- Visual line mode
		c = u.darken(catppuccin.peach, 0.5, catppuccin.base), -- Command mode
		R = u.darken(catppuccin.red, 0.5, catppuccin.base), -- Replace mode
		[""] = u.darken(catppuccin.pink, 0.5, catppuccin.base), -- Visual block mode
	}
	return { fg = mode_color[vim.fn.mode()], gui = "bold" }
end

-- ─[ GITSIGNS ]─────────────────────────────────────────────
-- https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets#using-external-source-for-diff
local function diff_source()
	local gitsigns = vim.b.gitsigns_status_dict
	if gitsigns then
		return {
			added = gitsigns.added,
			modified = gitsigns.changed,
			removed = gitsigns.removed,
		}
	end
end

-- ────────────────────────────────────────────────────────────
-- Changing filename color based on modified status
-- https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets#changing-filename-color-based-on--modified-status
local highlight = require("lualine.highlight")
local Fname = require("lualine.components.filename"):extend()

-- Define colores usando la paleta de Catppuccin
local fname_colors = {
	saved = { fg = u.darken(catppuccin.text, 0.5, catppuccin.base) }, -- gris claro o neutro
	modified = { fg = catppuccin.red }, -- rojo tenue
}

function Fname:init(options)
	Fname.super.init(self, options)

	-- Define grupos de color para los dos estados
	self.status_colors = {
		saved = highlight.create_component_highlight_group(fname_colors.saved, "lualine_fname_saved", self.options),
		modified = highlight.create_component_highlight_group(
			fname_colors.modified,
			"lualine_fname_modified",
			self.options
		),
	}

	if self.options.color == nil then
		self.options.color = ""
	end
end

function Fname:update_status()
	local data = Fname.super.update_status(self)
	local color_group = vim.bo.modified and self.status_colors.modified or self.status_colors.saved
	data = highlight.component_format_highlight(color_group) .. data
	return data
end

-- ╒═══════════════════════════════════════════════════════════╕
-- │                          LUALINE                          │
-- ╘═══════════════════════════════════════════════════════════╛
lualine.setup({
	options = {
		-- theme = "catppuccin",
		component_separators = { left = "›", right = "" },
		section_separators = { left = "", right = "" },
		globalstatus = true, -- Una barra para cuando hay mas ventanas
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
		lualine_c = { "navic" },
	},
	sections = {
		lualine_b = {
			"branch",
			{
				"diff",
				source = diff_source,
				symbols = {
					added = "󱐮 ",
					modified = "󱐯 ",
					removed = "󱐰 ",
				},
			},
			"diagnostics",
		},
		lualine_c = {
			{
				-- "filename",  -- Si un día la función falla, solo descomenta
				Fname,
				path = 4, -- Carpeta principal y nombre
				shorting_target = 24,
				symbols = {
					modified = "",
					readonly = "󰍁",
					newfile = "󰽃",
				},
			},
		},
		lualine_x = {
			{
				"fileformat",
				symbols = {
					unix = "󰻀",
					dos = "󰍲",
					mac = "",
				},
				color = get_mode_color,
			},
			{
				"encoding",
				fmt = string.upper,
				color = get_mode_color,
			},
			{
				"filetype",
				-- Colorea el texto según el icono
				color = function()
					local _, color = require("nvim-web-devicons").get_icon_cterm_color_by_filetype(vim.bo.filetype)
					return { fg = color }
				end,
			},
		},
	},
	extensions = {
		-- "fugitive",
		-- "neo-tree",
		"quickfix",
		"fzf",
	},
})
