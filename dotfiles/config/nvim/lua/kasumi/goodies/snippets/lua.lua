local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

ls.add_snippets("lua", {
	s("M", {
		t({ "local M = {}", "", "" }),
		i(0),
		t({ "", "", "return M" }),
	}),
})
