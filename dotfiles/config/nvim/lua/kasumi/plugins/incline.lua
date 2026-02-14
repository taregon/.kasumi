local devicons = require("nvim-web-devicons")

require("incline").setup({
	render = function(props)
		local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
		if filename == "" then
			filename = "[No Name]"
		end

		-- Ícono del archivo
		local ft_icon, ft_color = devicons.get_icon_color(filename)

		-- Cambios de gitsigns
		local signs = vim.b[props.buf].gitsigns_status_dict
		local diff = {}
		if signs then
			if signs.added and signs.added > 0 then
				table.insert(diff, { "󱐮 " .. signs.added .. " ", group = "DiffAdded" })
			end
			if signs.changed and signs.changed > 0 then
				table.insert(diff, { "󱐯 " .. signs.changed .. " ", group = "DiffChanged" })
			end
			if signs.removed and signs.removed > 0 then
				table.insert(diff, { "󱐰 " .. signs.removed .. " ", group = "DiffRemoved" })
			end
		end

		return {
			{ (ft_icon or "") .. " ", guifg = ft_color },
			{ filename, gui = vim.bo[props.buf].modified and "bold,italic" or "bold" },
			(#diff > 0) and { " / " } or nil,
			diff,
		}
	end,
})
