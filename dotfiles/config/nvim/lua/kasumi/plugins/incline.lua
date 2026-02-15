-- ┌────────────────────────────┐
-- │░▀█▀░█▀█░█▀▀░█░░░▀█▀░█▀█░█▀▀│
-- │░░█░░█░█░█░░░█░░░░█░░█░█░█▀▀│
-- │░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀│
-- └────────────────────────────┘
--
require("incline").setup({
	render = function(props)
		-- Buffer actual
		local buf = props.buf

		-- Estado de modificado del buffer
		local modified = vim.bo[buf].modified

		-- Ruta y nombre del archivo
		local path = vim.api.nvim_buf_get_name(buf)
		local filename = vim.fn.fnamemodify(path, ":t")

		-- Detectar si el archivo proviene de un sistema remoto (ej. sshfs)
		local remote = path:match("^/mnt/servers/([^/]+)") or ""

		-- Detectar clientes LSP activos (Neovim 0.11.6 usa get_clients)
		local lsp_clients = vim.lsp.get_clients({ bufnr = buf })
		local lsp_active = #lsp_clients > 0

		-- NOTE: Muestra la rama de Git (si usas gitsigns.nvim)
		local branch = vim.b.gitsigns_head or ""

		-- Lista de segmentos que se mostrarán en la barra
		local segments = {}

		-- NOMBRE DEL ARCHIVO
		-- Si está modificado, se antepone un ícono y se resalta con DiagnosticWarn
		-- Si no, se muestra apagado con InclineNormalNC
		table.insert(segments, {
			(modified and " " or "") .. (filename ~= "" and filename or "[No Name]"),
			group = modified and "DiagnosticWarn" or "InclineNormalNC",
		})

		-- REMOTE
		-- Se muestra solo si el archivo está en un host remoto
		-- Color de DiagnosticInfo si la ventana está activa, InclineNormalNC si no
		if remote ~= "" then
			table.insert(segments, {
				" | " .. remote,
				group = props.focused and "DiagnosticInfo" or "InclineNormalNC",
			})
		end

		-- LSP ACTIVO
		-- Si hay un cliente LSP conectado al buffer, muestra un ícono
		if lsp_active then
			table.insert(segments, {
				"  ",
				group = props.focused and "DiagnosticInfo" or "InclineNormalNC",
			})
		end

		-- RAMA DE GIT
		-- Si existe rama (detectada por gitsigns), se muestra con un icono
		if branch ~= "" then
			table.insert(segments, {
				"  " .. branch,
				group = props.focused and "DiagnosticHint" or "InclineNormalNC",
			})
		end

		-- Retornar todos los segmentos para que incline los renderice
		return segments
	end,
})
