local function get_repeat_amount(buffer)
	local utils = require("markview.utils")
	local window = utils.buf_getwin(buffer)
	local width = vim.api.nvim_win_get_width(window)
	local textoff = math.max(vim.fn.getwininfo(window)[1].textoff, 7)
	return width, textoff
end

require("markview").setup({
	enable = true,

	markdown = {
		enable = true,
		wrap = true,

		block_quotes = {

			default = {
				border = "🮌",
				hl = "MarkviewBlockQuoteDefault",
			},

			["NOTE"] = {
				hl = "MarkviewBlockQuoteNote",
				preview = "󰋽 Note",
				title = true,
				icon = "󰋽",
			},
			["TIP"] = {
				hl = "MarkviewBlockQuoteOk",
				preview = " Tip",
				title = true,
				icon = "",
			},
			["IMPORTANT"] = {
				hl = "MarkviewBlockQuoteSpecial",
				preview = " Important",
				title = true,
				icon = "",
			},
			["WARNING"] = {
				hl = "MarkviewBlockQuoteWarn",
				preview = "󰐕 Warning",
				title = true,
				icon = "󰐕",
			},
			["CAUTION"] = {
				hl = "MarkviewBlockQuoteError",
				preview = "󰳦 Caution",
				title = true,
				icon = "󰳦",
			},

			["ABSTRACT"] = {
				hl = "MarkviewBlockQuoteNote",
				preview = "󱉫 Abstract",
				title = true,
				icon = "󱉫",
			},
			["ATTENTION"] = {
				hl = "MarkviewBlockQuoteWarn",
				preview = "󰐕 Attention",
				title = true,
				icon = "󰐕",
			},
			["BUG"] = {
				hl = "MarkviewBlockQuoteError",
				preview = "󰅙 Bug",
				title = true,
				icon = "󰅙",
			},
			["CHECK"] = {
				hl = "MarkviewBlockQuoteOk",
				preview = "󰗠 Check",
				title = true,
				icon = "󰗠",
			},
			["CITE"] = {
				hl = "MarkviewBlockQuoteDefault",
				preview = "󰌱 Cite",
				title = true,
				icon = "󰌱",
			},
			["DANGER"] = {
				hl = "MarkviewBlockQuoteError",
				preview = "󰅙 Danger",
				title = true,
				icon = "󰅙",
			},
			["DONE"] = {
				hl = "MarkviewBlockQuoteOk",
				preview = "󰗠 Done",
				title = true,
				icon = "󰗠",
			},
			["ERROR"] = {
				hl = "MarkviewBlockQuoteError",
				preview = "󰅙 Error",
				title = true,
				icon = "󰅙",
			},
			["EXAMPLE"] = {
				hl = "MarkviewBlockQuoteSpecial",
				preview = "󱖫 Example",
				title = true,
				icon = "󱖫",
			},
			["FAIL"] = {
				hl = "MarkviewBlockQuoteError",
				preview = "󰅙 Fail",
				title = true,
				icon = "󰅙",
			},
			["FAILURE"] = {
				hl = "MarkviewBlockQuoteError",
				preview = "󰅙 Failure",
				title = true,
				icon = "󰅙",
			},
			["FAQ"] = {
				hl = "MarkviewBlockQuoteWarn",
				preview = "󰋗 Faq",
				title = true,
				icon = "󰋗",
			},
			["HELP"] = {
				hl = "MarkviewBlockQuoteWarn",
				preview = "󰋗 Help",
				title = true,
				icon = "󰋗",
			},
			["HINT"] = {
				hl = "MarkviewBlockQuoteOk",
				preview = "󰡕 Hint",
				title = true,
				icon = "󰡕",
			},
			["INFO"] = {
				hl = "MarkviewBlockQuoteNote",
				preview = "󰋽 Info",
				title = true,
				icon = "󰋽",
			},
			["MISSING"] = {
				hl = "MarkviewBlockQuoteError",
				preview = "󰅙 Missing",
				title = true,
				icon = "󰅙",
			},
			["QUESTION"] = {
				hl = "MarkviewBlockQuoteWarn",
				preview = "󰋗 Question",
				title = true,
				icon = "󰋗",
			},
			["QUOTE"] = {
				hl = "MarkviewBlockQuoteDefault",
				preview = "󰌱 Quote",
				title = true,
				icon = "󰌱",
			},
			["SUCCESS"] = {
				hl = "MarkviewBlockQuoteOk",
				preview = "󰗠 Success",
				title = true,
				icon = "󰗠",
			},
			["SUMMARY"] = {
				hl = "MarkviewBlockQuoteNote",
				preview = "󱉫 Summary",
				title = true,
				icon = "󱉫",
			},
			["TLDR"] = {
				hl = "MarkviewBlockQuoteNote",
				preview = "󱉫 Tldr",
				title = true,
				icon = "󱉫",
			},
			["TODO"] = {
				hl = "MarkviewBlockQuoteNote",
				preview = "󰋽 Todo",
				title = true,
				icon = "󰋽",
			},
		},

		code_blocks = {
			enable = true,
			style = "block",
			sign = true,

			min_width = 60,
			pad_amount = 2,
			pad_char = " ",

			border_hl = "MarkviewCode",
			info_hl = "MarkviewCodeInfo",

			label_direction = "right",

			default = {
				block_hl = "MarkviewCode",
				pad_hl = "MarkviewCode",
			},
		},

		headings = {
			enable = true,
			shift_width = 2,
			heading_1 = {
				style = "label",
				align = "center",
				-- padding_left = "🭪 🮤🮤🮤 ",
				-- padding_right = " 🮥🮥🮥 🭨",
				padding_left = " ❰ ",
				padding_right = " ❱ ",
				icon = "  ",
				hl = "MarkviewHeading1",
			},
            -- stylua: ignore start
			heading_2 = { style = "icon", icon = "  ",     hl = "MarkviewHeading2" },
			heading_3 = { style = "icon", icon = " ",       hl = "MarkviewHeading3" },
			heading_4 = { style = "icon", icon = "  ",     hl = "MarkviewHeading4" },
			heading_5 = { style = "icon", icon = "󰼓  ",     hl = "MarkviewHeading5" },
			heading_6 = { style = "icon", icon = "󰎴  ",     hl = "MarkviewHeading6" },
			-- stylua: ignore end
		},
		horizontal_rules = {
			enable = true,
			parts = {
				{
					type = "repeating",
					repeat_amount = function(buffer)
						local width, textoff = get_repeat_amount(buffer)
						return math.floor((width - textoff - 3) / 2)
					end,
					direction = "right",
					text = "🭹",
					hl = { "Comment" },
				},
				{
					type = "text",
					text = "  ",
					hl = { "Comment" },
				},
				{
					type = "repeating",
					repeat_amount = function(buffer)
						local width, textoff = get_repeat_amount(buffer)
						return math.ceil((width - textoff - 3) / 2)
					end,
					direction = "left",
					text = "🭹",
					hl = { "Comment" },
				},
			},
		},
		list_items = {
			enable = true,
			wrap = true,
			indent_size = 4,
			shift_width = 4,

			marker_minus = {
				add_padding = true,
				conceal_on_checkboxes = true,
				text = "󰄮",
				hl = "MarkviewListItemMinus",
			},
			marker_plus = {
				add_padding = true,
				conceal_on_checkboxes = true,
				text = "󰞱",
				hl = "MarkviewListItemPlus",
			},
			marker_star = {
				add_padding = true,
				conceal_on_checkboxes = true,
				text = "󰄬",
				hl = "MarkviewListItemStar",
			},
			marker_dot = {
				add_padding = true,
				conceal_on_checkboxes = true,
				hl = "@markup.list.markdown",
				text = function(_, item)
					return string.format("%d.", item.n)
				end,
			},
			marker_parenthesis = {
				add_padding = true,
				conceal_on_checkboxes = true,
				hl = "@markup.list.markdown",
				text = function(_, item)
					return string.format("%d)", item.n)
				end,
			},
		},

		tables = {
			enable = true,
			block_decorator = true,
		},

		metadata_minus = {
			enable = true,
		},
		metadata_plus = {
			enable = true,
		},
	},

	markdown_inline = {
		enable = true,

		checkboxes = {
			enable = true,

			checked = {
				text = "󰗠",
				hl = "MarkviewCheckboxChecked",
				scope_hl = "MarkviewCheckboxChecked",
			},
			unchecked = {
				text = "󰄰",
				hl = "MarkviewCheckboxUnchecked",
				scope_hl = "MarkviewCheckboxUnchecked",
			},
		},

		hyperlinks = {
			enable = true,

			default = {
				icon = "󰌷 ",
				hl = "MarkviewHyperlink",
			},

			["arxiv%.org"] = {
				icon = "󱂩 ",
				hl = "MarkviewPalette1Fg",
			},
			["discord%.com"] = {
				icon = "󰤴 ",
				hl = "MarkviewPalette2Fg",
			},
			["^https?://doi%.org"] = {
				icon = "󱂩 ",
				hl = "MarkviewPalette1Fg",
			},
			["github%.com"] = {
				icon = "󰊤 ",
				hl = "MarkviewPalette0Fg",
			},
			["google%.com"] = {
				icon = "󰀸 ",
				hl = "MarkviewPalette5Fg",
			},
			["linkedin%.com"] = {
				icon = "󰌻 ",
				hl = "MarkviewPalette5Fg",
			},
			["pypi%.org"] = {
				icon = "󰆦 ",
				hl = "MarkviewPalette0Fg",
			},
			["reddit%.com"] = {
				icon = "󰑹 ",
				hl = "MarkviewPalette2Fg",
			},
			["twitter%.com"] = {
				icon = "󰌹 ",
				hl = "MarkviewPalette0Fg",
			},
			["x%.com"] = {
				icon = "󰀄 ",
				hl = "MarkviewPalette0Fg",
			},
			["youtube[^.]*%.com"] = {
				icon = "󰵾 ",
				hl = "MarkviewPalette1Fg",
			},
			["youtu%.be"] = {
				icon = "󰵾 ",
				hl = "MarkviewPalette1Fg",
			},
			["wikipedia%.org"] = {
				icon = "󰖬 ",
				hl = "MarkviewPalette5Fg",
			},
			["^http"] = {
				icon = "󰈙 ",
				hl = "MarkviewHyperlink",
			},
		},

		images = {
			enable = true,

			default = {
				icon = "󰋵  ",
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
				icon = "󰌷 ",
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

	preview = {
		enable = nil,
		modes = { "n" },
		debounce = 200,
	},
})
