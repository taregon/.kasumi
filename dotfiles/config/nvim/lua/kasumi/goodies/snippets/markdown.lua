local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node

ls.add_snippets("markdown", {
	s({ trig = "link", namr = "markdown_link", dscr = "Create markdown link [txt](url)" }, {
		t("["),
		i(1),
		t("]("),
		f(function(_, snip)
			return snip.env.TM_SELECTED_TEXT[1] or {}
		end, {}),
		t(")"),
		i(0),
	}),
	s({ trig = "codewrap", namr = "markdown_code_wrap", dscr = "Wrap selected text in code block" }, {
		t("``` "),
		i(1, "Language"),
		t({ "", "" }),
		f(function(_, snip)
			local tmp = snip.env.TM_SELECTED_TEXT
			tmp[0] = nil
			return tmp or {}
		end, {}),
		t({ "", "```", "" }),
		i(0),
	}),
	s({ trig = "h1", namr = "markdown_h1", dscr = "Header level 1" }, {
		t("# "),
		i(1),
		t({ "", "" }),
		i(0),
	}),
	s({ trig = "h2", namr = "markdown_h2", dscr = "Header level 2" }, {
		t("## "),
		i(1),
		t({ "", "" }),
		i(0),
	}),
	s({ trig = "h3", namr = "markdown_h3", dscr = "Header level 3" }, {
		t("### "),
		i(1),
		t({ "", "" }),
		i(0),
	}),
	s({ trig = "h4", namr = "markdown_h4", dscr = "Header level 4" }, {
		t("#### "),
		i(1),
		t({ "", "" }),
		i(0),
	}),
	s({ trig = "h5", namr = "markdown_h5", dscr = "Header level 5" }, {
		t("##### "),
		i(1),
		t({ "", "" }),
		i(0),
	}),
	s({ trig = "h6", namr = "markdown_h6", dscr = "Header level 6" }, {
		t("###### "),
		i(1),
		t({ "", "" }),
		i(0),
	}),
	s({ trig = "b", namr = "markdown_bold", dscr = "Bold text" }, {
		t("**"),
		i(1),
		t("**"),
		i(0),
	}),
	s({ trig = "i", namr = "markdown_italic", dscr = "Italic text" }, {
		t("*"),
		i(1),
		t("*"),
		i(0),
	}),
	s({ trig = "code", namr = "markdown_inline_code", dscr = "Inline code" }, {
		t("`"),
		i(1),
		t("`"),
		i(0),
	}),
	s({ trig = "codeblock", namr = "markdown_codeblock", dscr = "Empty code block" }, {
		t({ "``` " }),
		i(1, "Language"),
		t({ "", "", "```", "" }),
		i(0),
	}),
	s({ trig = "task", namr = "markdown_task", dscr = "Task list item" }, {
		t("- [ ] "),
		i(1),
		t({ "", "" }),
		i(0),
	}),
	s({ trig = "img", namr = "markdown_image", dscr = "Image ![alt](path)" }, {
		t("!["),
		i(1, "alt text"),
		t("]("),
		i(2, "path"),
		t(")"),
		i(0),
	}),
	s({ trig = "quote", namr = "markdown_quote", dscr = "Blockquote" }, {
		t("> "),
		i(1),
		i(0),
	}),
	s({ trig = "table", namr = "markdown_table", dscr = "3x3 table" }, {
		t({ "| " }),
		i(1, "Column1"),
		t(" | "),
		i(2, "Column2"),
		t(" | "),
		i(3, "Column3"),
		t({ " |", "| ------------- | -------------- | -------------- |", "| " }),
		i(4, "Item1"),
		t(" | "),
		i(5, "Item2"),
		t(" | "),
		i(6, "Item3"),
		t({ " |", "| " }),
		i(7, "Item4"),
		t(" | "),
		i(8, "Item5"),
		t(" | "),
		i(9, "Item6"),
		t({ " |", "" }),
		i(0),
	}),
	s({ trig = "note", namr = "markdown_note", dscr = "GitHub callout NOTE" }, {
		t({ "> [!NOTE]", "> " }),
		i(1),
		i(0),
	}),
	s({ trig = "tip", namr = "markdown_tip", dscr = "GitHub callout TIP" }, {
		t({ "> [!TIP]", "> " }),
		i(1),
		i(0),
	}),
	s({ trig = "warning", namr = "markdown_warning", dscr = "GitHub callout WARNING" }, {
		t({ "> [!WARNING]", "> " }),
		i(1),
		i(0),
	}),
})
