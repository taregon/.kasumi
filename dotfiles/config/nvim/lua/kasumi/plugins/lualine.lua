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

-- Función que devuelve el color según el modo actual de Neovim
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

-- ─[ FILE SIZE ]────────────────────────────────────────────
-- Devuelve el tamaño de un archivo expresado en bytes, kilobytes (KB),
-- megabytes (MB) o gigabytes (GB), según corresponda.
local function filesize()
	local file = vim.fn.expand("%:p")
	if file == "" then
		return ""
	end
	local size = vim.fn.getfsize(file)
	if size < 0 then
		return ""
	end
	if size < 1024 then
		return size .. "B"
	elseif size < 1024 * 1024 then
		return string.format("%.1fKB", size / 1024)
	elseif size < 1024 * 1024 * 1024 then
		return string.format("%.1fMB", size / (1024 * 1024))
	else
		return string.format("%.1fGB", size / (1024 * 1024 * 1024))
	end
end

-- ────────────────────────────────────────────────────────────
-- Ajustar el color del nombre del archivo dependiendo si ha sido modificado o no.
-- https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets#changing-filename-color-based-on--modified-status
local highlight = require("lualine.highlight")
local file_status_name = require("lualine.components.filename"):extend()

-- Define colores usando la paleta de Catppuccin
local fname_colors = {
	saved = { fg = u.darken(catppuccin.surface1, 1.5, catppuccin.base) }, -- color opaco
	modified = { fg = u.darken(catppuccin.yellow, 0.7, catppuccin.base) }, -- color opaco
}

function file_status_name:init(options)
	file_status_name.super.init(self, options)

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

function file_status_name:update_status()
	local data = file_status_name.super.update_status(self)
	local color_group = vim.bo.modified and self.status_colors.modified or self.status_colors.saved
	data = highlight.component_format_highlight(color_group) .. data
	return data
end

-- ╒═══════════════════════════════════════════════════════════╕
-- │                          LUALINE                          │
-- ╘═══════════════════════════════════════════════════════════╛
lualine.setup({
	options = {
		component_separators = { left = "›", right = "" },
		section_separators = { left = "", right = "" },
		globalstatus = true, -- Una barra para cuando hay mas ventanas
	},
	disabled_filetypes = {
		statusline = {
			-- "neo-tree", -- Quite el plug
			-- "undotree",
		},
		winbar = {
			-- "neo-tree", -- Quite el plug
			-- "undotree",
		},
	},
	-- winbar = { lualine_c = { "navic" } },
	sections = {
		lualine_a = {
			{
				"mode",
				separator = { left = "▒", right = "" },
			},
		},

		lualine_b = {
			"branch",
			{
				"diff",
				source = diff_source,
				symbols = { added = "󱐮 ", modified = "󱐯 ", removed = "󱐰 " },
			},
		},
		lualine_c = {
			{
				-- "filename",  -- Si un día la función falla, solo descomenta
				-- shorting_target = 24,
				file_status_name,
				path = 4, -- Carpeta principal y nombre
				symbols = { modified = "", readonly = "󰞀", unnamed = "" },
			},
		},
		lualine_x = {
			{
				filesize,
				color = get_mode_color,
			},
			{
				"fileformat",
				symbols = { unix = "󰻀", dos = "󰍲", mac = "" },
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

		lualine_z = {
			{
				"location",
				separator = { left = "", right = "▒" },
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
