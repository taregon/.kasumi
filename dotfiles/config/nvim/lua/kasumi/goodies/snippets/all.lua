local ls = require("luasnip")
local snip = ls.snippet
local text = ls.text_node

ls.add_snippets("all", {
	snip("sndiv", {
		text({
			"---------------------------------------------------------",
			"-- ",
			"---------------------------------------------------------",
			"",
		}),
	}),
})
