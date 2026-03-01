--[[
NOTA: Callouts: Es como poner un post-it o una caja de alerta dentro de Markdown.
Los callouts no funcionan sin el > inicial; no son bloques independientes,
son una mejora/visualización especial de los blockquotes.
https://github.com/MeanderingProgrammer/render-markdown.nvim/wiki/Callouts

raw             | category  | descripción
----------------|-----------|--------------------------------------
[!ABSTRACT]     | obsidian  | Resumen teórico o abstracto
[!ATTENTION]    | obsidian  | Prestar atención (similar warning)
[!BUG]          | obsidian  | Reporte de error / bug
[!CAUTION]      | github    | Peligro / precaución alta
[!CHECK]        | obsidian  | Verificado / completado
[!CITE]         | obsidian  | Cita bibliográfica
[!DANGER]       | obsidian  | Peligro grave
[!DONE]         | obsidian  | Tarea terminada
[!ERROR]        | obsidian  | Error crítico
[!EXAMPLE]      | obsidian  | Ejemplo práctico
[!FAIL]         | obsidian  | Fallo / no exitoso
[!FAILURE]      | obsidian  | Fracaso / fallo
[!FAQ]          | obsidian  | Preguntas frecuentes
[!HELP]         | obsidian  | Necesita ayuda
[!HINT]         | obsidian  | Consejo / pista
[!IMPORTANT]    | github    | Muy importante
[!INFO]         | obsidian  | Información general
[!MISSING]      | obsidian  | Falta contenido / incompleto
[!NOTE]         | github    | Nota adicional
[!QUESTION]     | obsidian  | Pregunta / duda
[!QUOTE]        | obsidian  | Cita textual
[!SUCCESS]      | obsidian  | Éxito / logrado
[!SUMMARY]      | obsidian  | Resumen breve
[!TIP]          | github    | Consejo útil
[!TLDR]         | obsidian  | Muy resumen (too long; didn't read)
[!TODO]         | obsidian  | Pendiente por hacer
[!WARNING]      | github    | Advertencia media

Uso rápido:
> [!NOTE]
> Texto de la nota...

Categorías principales:
- github:   los 5 estándares oficiales de GitHub
- obsidian: amplia variedad usada en Obsidian y otros editores
--]]

-- ┌──────────────────────────────────────────────────────────┐
-- │░█▀▄░█▀▀░█▀█░█▀▄░█▀▀░█▀▄░░░█▄█░█▀█░█▀▄░█░█░█▀▄░█▀█░█░█░█▀█│
-- │░█▀▄░█▀▀░█░█░█░█░█▀▀░█▀▄░░░█░█░█▀█░█▀▄░█▀▄░█░█░█░█░█▄█░█░█│
-- │░▀░▀░▀▀▀░▀░▀░▀▀░░▀▀▀░▀░▀░░░▀░▀░▀░▀░▀░▀░▀░▀░▀▀░░▀▀▀░▀░▀░▀░▀│
-- └──────────────────────────────────────────────────────────┘
-- Ver iconos nerds https://nerdfonts.ytyng.com/
local function bullet_config()
	return {
		-- enabled = false,

		-- Bullet según nivel
		icons = function(ctx)
			local icons = { "♢", "🟆 ", " ", "", "" }
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
	enabled = true, -- Permite desactivar globalmente el plugin desde esta aquí
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
	-- indent = { enabled = true, skip_heading = true, icon = "" },

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
				"❰   ❱",
				"  ",
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
    -- stylua: ignore
	callout = {
		note      = { rendered = "  Note" },
		tip       = { rendered = "󰡕  Tip" },
		important = { rendered = "  Important" },
		warning   = { rendered = "  Warning" },
		caution   = { rendered = "  Caution" },
	},
	link = {
		image = "󰋵  ",
		email = "󰇯  ",
		hyperlink = "  ",
		footnote = { icon = "󱝂 " },
        -- stylua: ignore
		custom = {
			arxiv         = { pattern = "arxiv%.org", icon         = "  " }, -- Papers ML/AI
			discord       = { pattern = "discord%.com", icon       = "  " }, -- comunidades/soporte (creciendo fuerte)
			doi           = { pattern = "^https?://doi%.org", icon = "  " }, -- DOIs
			github        = { pattern = "github%.com", icon        = "  " }, -- #1 absoluto: repos, issues, PRs
			google        = { pattern = "google%.com", icon        = "  " }, -- búsquedas/docs
			linkedin      = { pattern = "linkedin%.com", icon      = "  " }, -- perfiles/autores
			pypi          = { pattern = "pypi%.org", icon          = "  " }, -- Python pkgs
			reddit        = { pattern = "reddit%.com", icon        = "  " }, -- discusiones/subreddits
			twitter       = { pattern = "twitter%.com", icon       = "  " }, -- cuentas de autores (aún común)
			web           = { pattern = "^http", icon              = "󰈹  " }, -- fallback para cualquier http/https
			wikipedia     = { pattern = "wikipedia%.org", icon     = "󰖬  " }, -- referencias rápidas
			x             = { pattern = "x%.com", icon             = "  " }, -- migración a X, cada vez más
			youtube       = { pattern = "youtube[^.]*%.com", icon  = "  " }, -- tutoriales/demos (muy alto)
			youtube_short = { pattern = "youtu%.be", icon          = "  " }, -- shorts (mismo icono)
		},
	},
})

-- {"󰭄 ", "󰚟", "󰵲 ", "󰻴 ", "󰙴 ", "󰅴 ", "󰗢 ", " ", " ", " ", "◆ ", " ", "󰡕 ", "◇", "󰲌 ", "󰐾 ", " ", "󰣉 ",}
