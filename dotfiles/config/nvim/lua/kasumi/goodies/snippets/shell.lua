local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

ls.add_snippets("sh", {
	s("if", {
		t({ "if [[ " }),
		i(1, "condition"),
		t({ " ]]; then", "\t" }),
		i(0),
		t({ "", "fi", "" }),
	}),
	s("case", {
		t({ 'case "$' }),
		i(1, "VAR"),
		t({ '" in', "\t" }),
		i(2, "pattern"),
		t({ ") echo match", "\t;;", "\t*) echo default", "\t;;", "esac", "" }),
		i(0),
	}),
	s("for_in", {
		t({ "for " }),
		i(1, "var"),
		t(" in "),
		i(2, "list"),
		t({ " do", "\t" }),
		i(0),
		t({ "", "done", "" }),
	}),
	s("for_i", {
		t({ "for ((" }),
		i(1, "i"),
		t(" = 0; "),
		i(2, "i"),
		t(" < "),
		i(3, "10"),
		t("; "),
		i(4, "i"),
		t({ "++)); do", "\t" }),
		i(0),
		t({ "", "done", "" }),
	}),
	s("while", {
		t({ "while [[ " }),
		i(1, "condition"),
		t({ " ]]; then", "\t" }),
		i(0),
		t({ "", "done", "" }),
	}),
	s("function", {
		i(1, "name"),
		t({ "()", "\t" }),
		i(0),
		t({ "", "}", "" }),
	}),
})
