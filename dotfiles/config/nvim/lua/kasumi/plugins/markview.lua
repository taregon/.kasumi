local function get_sizes(buffer)
	local utils = require("markview.utils")
	local window = utils.buf_getwin(buffer)

	local width = vim.api.nvim_win_get_width(window)
	local textoff = vim.fn.getwininfo(window)[1].textoff

	return width, textoff
end

require("markview").setup({

	--[[ yaml = {
        -- https://github.com/OXY2DEV/markview.nvim/wiki/YAML
		enabled = true,

		properties = {
			enable = true, -- ← Activa los iconos y decoraciones en las claves

			-- Tipos de datos con iconos por defecto
			data_types = {
				["text"] = { text = "󰗊 ", hl = "MarkviewIcon4" },
				["list"] = { text = "󰝖 ", hl = "MarkviewIcon5" },
				["number"] = { text = " ", hl = "MarkviewIcon6" },
				["checkbox"] = {
					text = function(_, item)
						return item.value == "true" and "󰄲 " or "󰄱 "
					end,
					hl = "MarkviewIcon6",
				},
			},

			-- Propiedades especiales (las más usadas en frontmatter)
			["^tags$"] = { text = "󰓹 ", hl = "MarkviewIcon0" },
			["^aliases$"] = { text = "󱞫 ", hl = "MarkviewIcon2" },
			["^description$"] = { text = "󰋼 ", hl = "MarkviewIcon0" },
			["^image$"] = { text = "󰋫 ", hl = "MarkviewIcon4" },
			-- Agrega aquí las que uses
		},
	}, ]]

	markdown = {
		enable = true,
		wrap = true,
		block_quotes = { -- ────────────────────────────────────────────────────────────
			enable = true,
			wrap = true,

			default = {
				border = "🮌",
				hl = "MarkviewBlockQuoteDefault",
			},
            -- stylua: ignore start
			["ABSTRACT"]  = { hl = "MarkviewBlockQuoteNote", preview    = "󱉫  Abstract", title  = true, icon = "󱉫 " },
			["ATTENTION"] = { hl = "MarkviewBlockQuoteWarn", preview    = "󰀪  Attention", title = true, icon = "󰀪 " },
			["BUG"]       = { hl = "MarkviewBlockQuoteError", preview   = "󰨰  Bug", title       = true, icon = "󰨰 " },
			["CAUTION"]   = { hl = "MarkviewBlockQuoteError", preview   = "󰳦  Caution", title   = true, icon = "󰳦 " },
			["CHECK"]     = { hl = "MarkviewBlockQuoteOk", preview      = "󰄬  Check", title     = true, icon = "󰄬 " },
			["CITE"]      = { hl = "MarkviewBlockQuoteDefault", preview = "󱆨  Cite", title      = true, icon = "󱆨 " },
			["DANGER"]    = { hl = "MarkviewBlockQuoteError", preview   = "󱐌  Danger", title    = true, icon = "󱐌 " },
			["DONE"]      = { hl = "MarkviewBlockQuoteOk", preview      = "󰄬  Done", title      = true, icon = "󰄬 " },
			["ERROR"]     = { hl = "MarkviewBlockQuoteError", preview   = "󱐌  Error", title     = true, icon = "󱐌 " },
			["EXAMPLE"]   = { hl = "MarkviewBlockQuoteSpecial", preview = "󰉹  Example", title   = true, icon = "󰉹 " },
			["FAIL"]      = { hl = "MarkviewBlockQuoteError", preview   = "󰅖  Fail", title      = true, icon = "󰅖 " },
			["FAILURE"]   = { hl = "MarkviewBlockQuoteError", preview   = "󰅖  Failure", title   = true, icon = "󰅖 " },
			["FAQ"]       = { hl = "MarkviewBlockQuoteWarn", preview    = "󰘥  Faq", title       = true, icon = "󰘥 " },
			["HELP"]      = { hl = "MarkviewBlockQuoteWarn", preview    = "󰘥  Help", title      = true, icon = "󰘥 " },
			["HINT"]      = { hl = "MarkviewBlockQuoteOk", preview      = "󰌶  Hint", title      = true, icon = "󰌶 " },
			["IMPORTANT"] = { hl = "MarkviewBlockQuoteSpecial", preview = "󰅾  Important", title = true, icon = "󰅾 ",},
			["INFO"]      = { hl = "MarkviewBlockQuoteNote", preview    = "󰋽  Info", title      = true, icon = "󰋽 " },
			["MISSING"]   = { hl = "MarkviewBlockQuoteError", preview   = "󰅖  Missing", title   = true, icon = "󰅖 " },
			["NOTE"]      = { hl = "MarkviewBlockQuoteNote", preview    = "󰋽  Note", title      = true, icon = "󰋽 " },
			["QUESTION"]  = { hl = "MarkviewBlockQuoteWarn", preview    = "󰘥  Question", title  = true, icon = "󰘥 " },
			["QUOTE"]     = { hl = "MarkviewBlockQuoteDefault", preview = "󱆨  Quote", title     = true, icon = "󱆨 " },
			["SUCCESS"]   = { hl = "MarkviewBlockQuoteOk", preview      = "󰄬  Success", title   = true, icon = "󰄬 " },
			["SUMMARY"]   = { hl = "MarkviewBlockQuoteNote", preview    = "󰨸  Summary", title   = true, icon = "󰨸 " },
			["TIP"]       = { hl = "MarkviewBlockQuoteOk", preview      = "󰡕  Tip", title       = true, icon = "󰡕 " },
			["TLDR"]      = { hl = "MarkviewBlockQuoteNote", preview    = "󰨸  Tldr", title      = true, icon = "󰨸 " },
			["TODO"]      = { hl = "MarkviewBlockQuoteNote", preview    = "󰗡  Todo", title      = true, icon = "󰗡 " },
			["WARNING"]   = { hl = "MarkviewBlockQuoteWarn", preview    = "󰀪  Warning", title   = true, icon = "󰀪 " },
			-- stylua: ignore end
		},

		hyperlinks = {
			enable = true,

			default = {
				icon = " ",
				hl = "MarkviewHyperlink",
			},
            -- stylua: ignore start
			["^http"]              = { icon = "󰈹 ", hl = "MarkviewHyperlink" },
			["^https?://doi%.org"] = { icon = " ", hl = "MarkviewPalette1Fg" },
			["arxiv%.org"]         = { icon = " ", hl = "MarkviewPalette1Fg" },
			["discord%.com"]       = { icon = " ", hl = "MarkviewPalette2Fg" },
			["github%.com"]        = { icon = " ", hl = "MarkviewPalette0Fg" },
			["google%.com"]        = { icon = " ", hl = "MarkviewPalette5Fg" },
			["linkedin%.com"]      = { icon = " ", hl = "MarkviewPalette5Fg" },
			["pypi%.org"]          = { icon = " ", hl = "MarkviewPalette0Fg" },
			["reddit%.com"]        = { icon = " ", hl = "MarkviewPalette2Fg" },
			["twitter%.com"]       = { icon = " ", hl = "MarkviewPalette0Fg" },
			["wikipedia%.org"]     = { icon = "󰖬 ", hl = "MarkviewPalette5Fg" },
			["x%.com"]             = { icon = " ", hl = "MarkviewPalette0Fg" },
			["youtu%.be"]          = { icon = " ", hl = "MarkviewPalette1Fg" },
			["youtube[^.]*%.com"]  = { icon = " ", hl = "MarkviewPalette1Fg" },
			-- stylua: ignore end
		},

		code_blocks = { -- ────────────────────────────────────────────────────────────
			enable = true,
			style = "block",
			sign = true,
			label_hl = "MarkviewCodeInfo",

			min_width = 60,
			pad_amount = 3,

			label_direction = "right",

			default = {
				block_hl = "MarkviewCode",
				pad_hl = "MarkviewCode",
			},
		},

		headings = { -- ────────────────────────────────────────────────────────────
			enable = true,
			shift_width = 2,

			heading_1 = {
				style = "label",
				align = "center",
				padding_left = " ❰ ",
				padding_right = " ❱ ",
				icon = "  ",
				-- sign = "🮐",
				hl = "MarkviewHeading1",
			},
			-- stylua: ignore start
			heading_2 = {
			    style = "icon",
			    icon = "  ",
                sign = "🮐",
			    hl = "MarkviewHeading2"
			},
			heading_3 = {
				style = "label",
				corner_left = "🭘",
				corner_right = "🭈",
				padding_left = " ",
				padding_right = " ",
				icon = "",
                -- sign = "🭬",
                sign_hl = "Comment",
				hl = "MarkviewHeading2"
			},
			heading_4 = { style = "icon", icon = "  ", hl = "MarkviewHeading4" },
			heading_5 = { style = "icon", icon = "󰎯  ", hl = "MarkviewHeading5" },
			heading_6 = { style = "icon", icon = "󰎴  ", hl = "MarkviewHeading6" },
			-- stylua: ignore end
		},

		horizontal_rules = { -- ────────────────────────────────────────────────────────────
			enable = true,

			parts = {
				{
					type = "repeating",
					direction = "left",
					repeat_amount = function(buffer)
						local width, textoff = get_sizes(buffer)
						return math.floor((width - textoff - 3) / 2)
					end,
					text = "━",
					hl = {
						"MarkviewGradient1",
						"MarkviewGradient1",
						"MarkviewGradient2",
						"MarkviewGradient2",
						"MarkviewGradient3",
						"MarkviewGradient3",
						"MarkviewGradient4",
						"MarkviewGradient4",
						"MarkviewGradient5",
						"MarkviewGradient5",
						"MarkviewGradient6",
						"MarkviewGradient6",
						"MarkviewGradient7",
						"MarkviewGradient7",
						"MarkviewGradient8",
						"MarkviewGradient8",
						"MarkviewGradient9",
						"MarkviewGradient9",
					},
				},
				{
					type = "text",
					text = "   ",
					hl = "LineNr",
				},
				{
					type = "repeating",
					direction = "right",
					repeat_amount = function(buffer)
						local width, textoff = get_sizes(buffer)
						return math.ceil((width - textoff - 3) / 2)
					end,
					text = "━",
					hl = {
						"MarkviewGradient1",
						"MarkviewGradient1",
						"MarkviewGradient2",
						"MarkviewGradient2",
						"MarkviewGradient3",
						"MarkviewGradient3",
						"MarkviewGradient4",
						"MarkviewGradient4",
						"MarkviewGradient5",
						"MarkviewGradient5",
						"MarkviewGradient6",
						"MarkviewGradient6",
						"MarkviewGradient7",
						"MarkviewGradient7",
						"MarkviewGradient8",
						"MarkviewGradient8",
						"MarkviewGradient9",
						"MarkviewGradient9",
					},
				},
			},
		},

		list_items = { -- ────────────────────────────────────────────────────────────
			enable = true,
			wrap = true,
			indent_size = 4,
			shift_width = 4,

			marker_minus = {
				enable = true,
				add_padding = true,
				conceal_on_checkboxes = true,
				text = "▭",
				hl = "MarkviewListItemMinus",
			},
			marker_plus = { enable = false },
			marker_star = { enable = false },
			marker_dot = {
				enable = true,
				add_padding = true,
				conceal_on_checkboxes = true,
				hl = "@markup.list.markdown",
			},
			marker_parenthesis = {
				enable = true,
				add_padding = true,
				conceal_on_checkboxes = true,
				hl = "@markup.list.markdown",
			},
		},

		tables = {
			enable = true,
			block_decorator = true,
			use_virt_lines = true,
		},

		metadata_minus = {
			enable = true,
		},
		metadata_plus = {
			enable = true,
		},

		reference_definitions = {
			enable = true,

			default = {
				icon = "󰌷 ",
				hl = "MarkviewHyperlink",
			},
		},
	},

	markdown_inline = {
		enable = true,

		checkboxes = {
			enable = true,

			checked = {
				text = " ",
				hl = "MarkviewCheckboxChecked",
				scope_hl = "MarkviewCheckboxChecked",
			},
			unchecked = {
				text = " ",
				hl = "MarkviewCheckboxUnchecked",
				scope_hl = "MarkviewCheckboxUnchecked",
			},
		},

		images = {
			enable = true,

			default = {
				icon = "󰋵 ",
				hl = "MarkviewImage",
			},
		},

		inline_codes = {
			enable = true,
			hl = "MarkviewInlineCode",
			padding_left = " ",
			padding_right = " ",
		},

		footnotes = {
			enable = true,

			default = {
				icon = "󱝂 ",
				hl = "MarkviewHyperlink",
			},
		},

		emails = {
			enable = true,

			default = {
				icon = "󰇯 ",
				hl = "MarkviewEmail",
			},
		},

		uri_autolinks = {
			enable = true,

			default = {
				icon = "󰌹 ",
				hl = "MarkviewEmail",
			},
		},

		block_references = {
			enable = true,

			default = {
				icon = "󰿨 ",
				hl = "MarkviewPalette6Fg",
				file_hl = "MarkviewPalette0Fg",
			},
		},

		internal_links = {
			enable = true,

			default = {
				icon = "󰌱 ",
				hl = "MarkviewPalette7Fg",
			},
		},

		highlights = {
			enable = true,

			default = {
				padding_left = " ",
				padding_right = " ",
				hl = "MarkviewPalette3",
			},
		},

		emoji_shorthands = {
			enable = true,
		},

		entities = {
			enable = true,
			hl = "Special",
		},

		escapes = {
			enable = true,
		},
	},
})
