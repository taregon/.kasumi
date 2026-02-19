-- Helper para el prompt "Commit en Español"
-- Expone staged_diff(), que obtiene el diff staged del archivo actual
-- y descarta metadatos previos (diff, index, rutas, etc.) comenzando
-- a procesar desde el primer encabezado de hunk (@@).
-- A partir de ese punto conserva únicamente el contenido real del cambio.
-- Comportamiento equivalente (aplicado a un solo archivo) a:
-- git diff --cached --no-ext-diff --no-prefix --unified=0 --color=never

local M = {}

function M.staged_diff()
	-- 1. Archivo del buffer actual
	local buf_path = vim.api.nvim_buf_get_name(0)
	if buf_path == "" then
		return "  No hay archivo abierto en el buffer actual."
	end

	-- 2. Resolver symlink -> path real
	local abs_path = vim.loop.fs_realpath(buf_path)
	if not abs_path then
		return "  No se pudo resolver el path real del archivo."
	end

	-- 3. Detectar root del repo desde el archivo real
	local file_dir = vim.fn.fnamemodify(abs_path, ":h")
	local root_res = vim.system({
		"git",
		"-C",
		file_dir,
		"rev-parse",
		"--show-toplevel",
	}, { text = true }):wait()

	if root_res.code ~= 0 or not root_res.stdout or root_res.stdout == "" then
		return "  No se detectó un repositorio Git válido."
	end

	local repo_root = vim.trim(root_res.stdout)
	local file_name = vim.fn.fnamemodify(abs_path, ":t") -- nombre del archivo seguro

	-- 4. Calcular path relativo
	local rel_path = abs_path:sub(#repo_root + 2)
	if rel_path == abs_path or rel_path == "" then
		return "  El archivo no pertenece al repositorio Git."
	end

	-- 5. Obtener diff staged (crudo, sin color ni contexto)
	local diff_res = vim.system({
		"git",
		"--no-pager",
		"diff",
		"--cached",
		"--no-ext-diff",
		"--no-prefix",
		"--unified=1", -- más contexto si quieres
		"--color=never",
		"--",
		rel_path,
	}, { text = true, cwd = repo_root }):wait()

	if diff_res.code ~= 0 then
		return "  Falló la ejecución de git diff (código " .. diff_res.code .. ")"
	end

	local diff_out = diff_res.stdout or ""
	if diff_out == "" then
		return "  No hay cambios staged en este archivo"
	end

	-- 6. Filtrar líneas relevantes
	local lines = vim.split(diff_out, "\n", { plain = true })
	local filtered = {}
	local start_processing = false

	for _, line in ipairs(lines) do
		if not start_processing and line:match("^@@ ") then
			start_processing = true
		end

		if start_processing then
			table.insert(filtered, line)
		end
	end

	-- 7. Mostrar nombre del repo antes del diff
	local header = " cambios staged en: " .. file_name .. "\n\n"
	return #filtered > 0 and header .. table.concat(filtered, "\n") or "  No hay cambios staged en este archivo"
end

return M
