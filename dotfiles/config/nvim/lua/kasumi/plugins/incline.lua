require("incline").setup({
	render = function(props)
		local buf = props.buf
		local modified = vim.bo[buf].modified
		local path = vim.api.nvim_buf_get_name(buf)
		local filename = vim.fn.fnamemodify(path, ":t")
		local remote = path:match("^/mnt/servers/([^/]+)") or ""

		-- Detectar clientes LSP activos (Neovim 0.11.6 usa get_clients)
		local lsp_clients = vim.lsp.get_clients({ bufnr = buf })
		local lsp_active = #lsp_clients > 0

		-- Rama de Git (si usas gitsigns)
		local branch = vim.b.gitsigns_head or ""

		local segments = {}

		-- Nombre del archivo con ícono si está modificado
		table.insert(segments, {
			(modified and "✎ " or "") .. (filename ~= "" and filename or "[No Name]"),
			group = modified and "DiagnosticWarn" or "InclineNormalNC",
		})

		-- Remote
		if remote ~= "" then
			table.insert(segments, {
				" | " .. remote,
				group = props.focused and "DiagnosticInfo" or "InclineNormalNC",
			})
		end

		-- Icono de LSP activo
		if lsp_active then
			table.insert(segments, {
				"  ",
				group = props.focused and "DiagnosticInfo" or "InclineNormalNC",
			})
		end

		-- Rama de Git
		if branch ~= "" then
			table.insert(segments, {
				"  " .. branch,
				group = props.focused and "DiagnosticHint" or "InclineNormalNC",
			})
		end

		return segments
	end,
})
