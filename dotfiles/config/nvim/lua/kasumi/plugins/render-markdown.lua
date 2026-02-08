-- Ver iconos nerds https://nerdfonts.ytyng.com/
-- {"󰭄 ", "󰚟", "󰵲 ", "󰻴 ", "󰙴 ", "󰅴 ", "󰗢 ", " ", " ", " ", "◆ ", " ", "󰡕 ", "◇", "󰲌 ", "󰐾 ", " ", "󰣉 ",}

local function bullet_config()
	return {
		-- enabled = false,

		-- Bullet según nivel
		icons = function(ctx)
			local icons = { "✧ ", " ", "", "" }
			return icons[((ctx.level - 1) % #icons) + 1]
		end,

		-- Numeración estable en listas ordenadas
		-- ordered_icons = function(ctx)
		-- 	local value = vim.trim(ctx.value)
		-- 	local num = tonumber(value:match("^(%d+)"))
		-- 	return string.format("%d.", num or ctx.index)
		-- end,

		-- Padding progresivo según nivel
		left_pad = function(ctx)
			return math.max(ctx.level + 1, 2)
		end,

		right_pad = 1,

		-- Solo el icono tiene highlight
		-- highlight = "RenderMarkdownBullet",
		-- scope_highlight = {},
		-- scope_priority = nil,
	}
end

require("render-markdown").setup({
	render_modes = { "n" },

	bullet = bullet_config(), -- personaliza viñetas
	checkbox = { left_pad = 4, unchecked = { icon = "󰄰 " }, checked = { icon = "󰄳 " } },
	completions = { lsp = { enabled = true } },
	dash = { icon = "🭹" },
	debounce = 200, -- retraso en ms antes de actualizar render
	file_types = { "markdown", "vimwiki" }, -- si usas vimwiki
	max_file_size = 1.5, -- en MB. Evita render en archivos muy grandes
	paragraph = { left_margin = 2 },
	quote = { icon = "🮌" },

	code = {
		sign = false,
		style = "full", -- full = bloque ancho con fondo
		border = "thin",
		width = "block",
		position = "center",
		left_margin = 4, -- separación del bloque de código desde el lado inquiero
		left_pad = 2, -- al interno del código
		right_pad = 2, -- al interno del código
		-- min_width = 0.6,
		inline_pad = 1,
		min_width = 60,
		language_left = "██",
		language_right = "██",
		language_border = "🮒",
	},
	heading = {
		signs = false,
		width = "block",
		border = true,
		-- border_virtual = true,
		below = "▀", -- 🮂🮂▀▀▀
		above = "▂",
		min_width = 82,
		icons = function(ctx)
			-- Muestra iconos en los encabezados ocultando los `#`.
			-- La sangría comienza desde el tercer nivel y crece de dos en dos:
			-- H1 y H2 quedan alineados, H3 tiene 2 espacios, H4 tiene 4, etc.
			-- El icono cambia según el nivel y se separa del texto para mejor lectura.
			local icons = {
				"🮌   ❱",
				"  ",
				" ",
				" ",
				"󰎯 ",
				"󰎴 ",
			}
			local icon = icons[ctx.level] or icons[#icons]
			local spaces = math.max((ctx.level - 2) * 2, 0)
			local pad = string.rep(" ", spaces)
			return pad .. icon .. " "
		end,
	},
})
