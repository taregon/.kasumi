-- ┌────────────────────────────┐
-- │░▀█▀░█▀█░█▀▀░█░░░▀█▀░█▀█░█▀▀│
-- │░░█░░█░█░█░░░█░░░░█░░█░█░█▀▀│
-- │░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀│
-- └────────────────────────────┘
-- Barra flotante minimalista que muestra el nombre del buffer y su contexto en cada ventana.
-- NOTE:  InclineNormalNC atenúa la información en ventanas no activas;
-- únicamente la vista con foco mantiene el estilo destacado.

-- Ejemplo de bloque para configurar colores personalizados
vim.api.nvim_set_hl(0, "DI_NoItalic", {
	link = nil,
	fg = vim.api.nvim_get_hl(0, { name = "DiagnosticInfo" }).fg,
	italic = false,
})

require("incline").setup({
	window = { margin = { horizontal = 2 } },
	highlight = {
		groups = {
			InclineNormal = "StatusLine", -- Mismo fondo que la barra de estado
			InclineNormalNC = "Comment", -- Texto cuando esta inactivo
		},
	},

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
		local branch = vim.b[buf].gitsigns_head or ""

		-- Lista de segmentos que se mostrarán en la barra
		local segments = {}

		-- NOMBRE DEL ARCHIVO
		-- Si está modificado, se antepone un ícono y se resalta
		table.insert(segments, {
			(modified and " " or "") .. (filename ~= "" and filename or "[No Name]"),
			group = modified and "DiagnosticWarn" or "InclineNormalNC",
		})

		-- LSP ACTIVO
		-- Si hay un cliente LSP conectado al buffer, muestra un ícono
		if lsp_active then
			table.insert(segments, {
				"  ",
				group = props.focused and "DI_NoItalic" or "InclineNormalNC",
			})
		end

		-- FORMATTER ACTIVO (Conform)
		local formatters = require("conform").list_formatters_to_run(buf)
		if #formatters > 0 then
			table.insert(segments, {
				" 󰉣 ",
				group = props.focused and "DI_NoItalic" or "InclineNormalNC",
			})
		end

		-- REMOTE
		-- Se muestra solo si el archivo está en un host remoto
		if remote ~= "" then
			table.insert(segments, {
				" 󰌘 " .. remote,
				group = props.focused and "Label" or "InclineNormalNC",
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
