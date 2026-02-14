require("incline").setup({
	highlight = {
		groups = {
			InclineNormal = "StatusLine", -- usa el mismo fondo que la barra de estado
			InclineNormalNC = "StatusLineNC", --usa el fondo de la barra inactiva
		},
	},

	render = function(props)
		local buf = props.buf
		local modified = vim.bo[buf].modified and "[+]" or ""
		local readonly = vim.bo[buf].readonly and "[RO]" or ""
		local path = vim.api.nvim_buf_get_name(buf)
		local remote = path:match("^/mnt/sshfs/([^/]+)") or ""

		-- Diagnósticos
		local diagnostics = vim.diagnostic.get(buf)
		local errors = #vim.tbl_filter(function(d)
			return d.severity == vim.diagnostic.severity.ERROR
		end, diagnostics)
		local warnings = #vim.tbl_filter(function(d)
			return d.severity == vim.diagnostic.severity.WARN
		end, diagnostics)
		local hints = #vim.tbl_filter(function(d)
			return d.severity == vim.diagnostic.severity.HINT
		end, diagnostics)
		local info = #vim.tbl_filter(function(d)
			return d.severity == vim.diagnostic.severity.INFO
		end, diagnostics)

		return {
			{ modified .. readonly },
			{ remote ~= "" and (" | " .. remote) or "" },
			errors > 0 and { " 󰇴 " .. errors, group = "DiagnosticError" } or "",
			warnings > 0 and { " 󰇶 " .. warnings, group = "DiagnosticWarn" } or "",
			hints > 0 and { "  " .. hints, hl = "DiagnosticHint" } or "",
			info > 0 and { " 󰇵 " .. info, hl = "DiagnosticInfo" } or "",
		}
	end,
})
