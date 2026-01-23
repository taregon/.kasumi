--  █████╗ ██╗   ██╗████████╗ ██████╗  ██████╗███╗   ███╗██████╗
-- ██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗██╔════╝████╗ ████║██╔══██╗
-- ███████║██║   ██║   ██║   ██║   ██║██║     ██╔████╔██║██║  ██║
-- ██╔══██║██║   ██║   ██║   ██║   ██║██║     ██║╚██╔╝██║██║  ██║
-- ██║  ██║╚██████╔╝   ██║   ╚██████╔╝╚██████╗██║ ╚═╝ ██║██████╔╝
-- ╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝  ╚═════╝╚═╝     ╚═╝╚═════╝

-- Simplifica la llamada al método de creación de auto comandos
local aucmd = vim.api.nvim_create_autocmd

-- Función para crear y configurar grupos de auto comandos
-- @param name string nombre del grupo de autocomandos
-- @param fn function función que define los autocomandos dentro del grupo
local function augroup(name, fn)
	local group = vim.api.nvim_create_augroup(name, { clear = true })
	fn(group)
end
-- ────────────────────────────────────────────────────────────
-- Configuración de archivos INI
augroup("Ini_Files", function(group)
	-- Activa el coloreado para archivos INI y de configuración
	aucmd("BufReadPost", {
		group = group,
		pattern = { "*.conf", "*.ini" },
		command = "set syntax=dosini",
	})
end)
-- ────────────────────────────────────────────────────────────
-- Ejecuta linters automáticamente
augroup("NvimLint", function(group)
	-- Eventos optimizados para el linter
	aucmd({ "BufEnter", "BufWritePost", "TextChanged" }, {
		group = group,
		callback = function()
			require("lint").try_lint()
		end,
	})
end)
-- ────────────────────────────────────────────────────────────
-- Recuerda la última posición del cursor
local function restore_cursor_position()
	local last_line = vim.fn.line("'\"")
	if last_line > 1 and last_line <= vim.fn.line("$") then
		vim.cmd('normal! g`"')
	end
end

-- Configuración de restauración de cursor
augroup("RestoreCursor", function(group)
	aucmd("BufReadPost", {
		group = group,
		pattern = "*",
		callback = restore_cursor_position,
	})
end)
-- ────────────────────────────────────────────────────────────
-- Configuración de archivos CSV y DAT
augroup("CsvFileTypes", function(group)
	-- Manejo de archivos CSV
	aucmd({ "BufNewFile", "BufRead" }, {
		group = group,
		pattern = "*.csv",
		command = "set filetype=rfc_csv",
	})

	-- Manejo de archivos DAT
	aucmd({ "BufNewFile", "BufRead" }, {
		group = group,
		pattern = "*.dat",
		command = "set filetype=csv_pipe",
	})
end)
-- ────────────────────────────────────────────────────────────
-- Auto-indentación y limpieza de archivos AWK al guardar:
-- Re-aplica GetAwkIndent() a todo el buffer
augroup("AwkIndent", function(group)
	aucmd("BufWritePre", {
		group = group,
		pattern = "*.awk",
		callback = function()
			vim.cmd("normal! gg=G")
		end,
	})
end)
-- ────────────────────────────────────────────────────────────
-- Ejecutar automáticamente los formatters configurados al guardar.
local conform = require("conform")

augroup("FormatOnSave", function(group)
	aucmd("BufWritePre", {
		group = group,
		pattern = "*",
		callback = function(args)
			conform.format({ bufnr = args.buf })
		end,
	})
end)
-- ────────────────────────────────────────────────────────────
-- Desactiva mini.indentscope en buffers donde no tiene sentido
augroup("DisableIndentScopeForCertainTypes", function(group)
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		pattern = { "help", "TelescopePrompt", "TelescopeResults", "conf" },
		callback = function()
			vim.b.miniindentscope_disable = true
		end,
	})
end)
-- ────────────────────────────────────────────────────────────
-- ORDENA FUNCIONES EN BASH
-- PEND: buscar un plug que haga esto para descartar este código

-- Extrae el nombre de la función Bash
local function get_func_name(func_text)
	-- Estilo: function foo { ... }
	local name = func_text:match("^%s*function%s+([%w_]+)")
	if name then
		return name
	end
	-- Estilo: foo() { ... }
	name = func_text:match("^%s*([%w_]+)%s*%(%s*%)")
	return name
end

-- Ordena funciones Bash dentro de un rango, manteniendo comentarios encima
local function sort_bash_functions_range(start_line, end_line)
	local bufnr = vim.api.nvim_get_current_buf()
	start_line = start_line or 0
	end_line = end_line or vim.api.nvim_buf_line_count(bufnr)

	local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line, false)

	local funcs = {}
	local current_func = {}
	local inside_func = false

	for i, line in ipairs(lines) do
		if line:match("^%s*function%s+%w+") or line:match("^%s*[%w_]+%s*%(%s*%)%s*{") then
			if inside_func then
				table.insert(funcs, table.concat(current_func, "\n"))
				current_func = {}
			end
			inside_func = true
		end

		if inside_func then
			table.insert(current_func, line)
		end
	end

	if #current_func > 0 then
		table.insert(funcs, table.concat(current_func, "\n"))
	end

	if #funcs == 0 then
		vim.notify("No se detectaron funciones Bash en el rango seleccionado", vim.log.levels.WARN)
		return
	end

	-- Ordenar alfabéticamente según el nombre de la función
	table.sort(funcs, function(a, b)
		return (get_func_name(a) or ""):lower() > (get_func_name(b) or ""):lower()
	end)

	-- Reescribir solo el rango indicado
	vim.api.nvim_buf_set_lines(bufnr, start_line, end_line, false, {})
	for _, f in ipairs(funcs) do
		local func_lines = vim.split(f, "\n")
		vim.api.nvim_buf_set_lines(bufnr, start_line, start_line, false, func_lines)
		vim.api.nvim_buf_set_lines(bufnr, start_line + #func_lines, start_line + #func_lines, false, { "" })
	end

	vim.notify("Funciones Bash ordenadas correctamente", vim.log.levels.INFO)
end

-- Comando flexible que soporta rango visual
local function sort_bash_functions_cmd(opts)
	local start_line, end_line
	if opts.range and opts.range ~= 0 then
		start_line = opts.line1 - 1
		end_line = opts.line2
	else
		start_line = 0
		end_line = vim.api.nvim_buf_line_count(0)
	end
	sort_bash_functions_range(start_line, end_line)
end

-- Registrar autocomando para Bash
augroup("BashSortF", function(group)
	aucmd("FileType", {
		group = group,
		pattern = { "sh", "bash" },
		callback = function()
			vim.api.nvim_create_user_command("SortBashFunctions", sort_bash_functions_cmd, { range = true })
		end,
	})
end)
-- ────────────────────────────────────────────────────────────
-- Alterna números relativos según el modo:
-- números relativos activados en Normal,
-- desactivados en Insert y en cualquier modo Visual.
augroup("ToggleRelativeNumber", function(group)
	-- Al abrir un buffer, activar números relativos por defecto
	aucmd({ "BufEnter", "BufWinEnter" }, {
		group = group,
		callback = function()
			vim.opt.number = true
			vim.opt.relativenumber = true
		end,
	})

	-- Insertar modo → desactivar números relativos
	aucmd("InsertEnter", {
		group = group,
		callback = function()
			vim.opt.relativenumber = false
		end,
	})

	-- Salir de Insert → activar números relativos
	aucmd("InsertLeave", {
		group = group,
		callback = function()
			vim.opt.relativenumber = true
		end,
	})

	-- Entrar en modos Visual → desactivar números relativos
	aucmd("ModeChanged", {
		group = group,
		pattern = "*:[vV]*", -- cualquier transición hacia v, V o Ctrl-v
		callback = function()
			vim.opt.relativenumber = false
		end,
	})

	-- Salir de modos Visual → activar números relativos si no se encuentra en Insert
	aucmd("ModeChanged", {
		group = group,
		pattern = "[vV]*:*", -- cualquier transición desde modos Visual
		callback = function()
			if vim.fn.mode():match("i") then
				return
			end
			vim.opt.relativenumber = true
		end,
	})
end)

-- ────────────────────────────────────────────────────────────
-- Activa el resaltado y (si lo configuras, la indentación)
-- con Tree-sitter.
-- https://mhpark.me/posts/update-treesitter-main/
augroup("TreesitterStart", function(group)
	aucmd("FileType", {
		group = group,
		callback = function(args)
			local buf = args.buf
			local ft = vim.bo[buf].filetype

			-- Traduce filetype a language válido
			local lang = vim.treesitter.language.get_lang(ft)
			if not lang then
				return
			end

			-- Arranca treesitter en este buffer
			-- Si no hay parser instalado o hay error, pcall evita crash
			pcall(vim.treesitter.start, buf, lang)

			-- Indentación basada en Tree-sitter (experimental)
			vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

			-- Folding basado en Tree-sitter
			vim.wo.foldmethod = "expr"
			vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		end,
	})
end)
