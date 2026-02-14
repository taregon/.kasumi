require("incline").setup({
	render = function(props)
		local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
		if filename == "" then
			filename = "[No Name]"
		end

		-- Cambios de gitsigns
		local signs = vim.b[props.buf].gitsigns_status_dict
		local diff = {}
		if signs then
			if signs.added and signs.added > 0 then
				table.insert(diff, { "󱐮 " .. signs.added .. " ", group = "DiffAdded" })
			end
			if signs.changed and signs.changed > 0 then
				table.insert(diff, { "󱐯 " .. signs.changed .. " ", group = "WarningMsg" })
			end
			if signs.removed and signs.removed > 0 then
				table.insert(diff, { "󱐰 " .. signs.removed .. " ", group = "DiffRemoved" })
			end
		end

		-- Diagnósticos de LSP
		local function get_diagnostic_label()
			local icons = { error = " ", warn = "󰗖 ", info = "󰋽 ", hint = "󰄰 " }
			local label = {}
			for severity, icon in pairs(icons) do
				local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
				if n > 0 then
					table.insert(label, { icon .. n .. " ", group = "DiagnosticSign" .. severity })
				end
			end
			return label
		end

		-- ────────────────────────────────────────────────────────────
		return {
			get_diagnostic_label(),
			{ filename, gui = vim.bo[props.buf].modified and "bold,italic" or "bold" },
			(#diff > 0) and { " / " } or nil, -- separador solo si hay diff
			diff,
		}
	end,
})
