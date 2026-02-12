-- Helper para el prompt "Commit en Español"
-- Expone staged_diff(), que obtiene el diff staged del archivo actual
-- y lo reduce al delta puro (+ / -), sin cabeceras, rutas, contexto ni color.
-- Comportamiento equivalente (aplicado a un solo archivo) a:
-- git diff --cached --no-ext-diff --no-prefix --unified=0 --color=never | sed -n '/^@@ /,$p' | sed '1d'

local M = {}

function M.staged_diff()
	-- 1. Archivo del buffer actual
	local bufname = vim.api.nvim_buf_get_name(0)
	if bufname == "" then
		return "  No hay archivo abierto en el buffer actual."
	end

	-- 2. Resolver symlink -> path real
	local real = vim.loop.fs_realpath(bufname)
	if not real then
		return "  No se pudo resolver el path real del archivo."
	end

	-- 3. Detectar root del repo desde el archivo real
	local root_res = vim.system({
		"git",
		"-C",
		vim.fn.fnamemodify(real, ":h"),
		"rev-parse",
		"--show-toplevel",
	}, { text = true }):wait()

	if root_res.code ~= 0 or not root_res.stdout or root_res.stdout == "" then
		return "  No se detectó un repositorio Git válido."
	end

	local root = root_res.stdout:gsub("%s+$", "")

	-- 4. Calcular path relativo
	local rel = real:sub(#root + 2)
	if rel == real or rel == "" then
		return "  El archivo no pertenece al repositorio Git."
	end

	-- 5. Obtener diff staged (crudo, sin color ni contexto)
	local diff_res = vim.system({
		"git",
		"diff",
		"--cached",
		"--no-ext-diff",
		"--no-prefix",
		"--unified=1", -- Si quieres mas lineas de contexto
		"--color=never",
		"--",
		rel,
	}, { text = true, cwd = root }):wait()

	if diff_res.code ~= 0 then
		return "  Falló la ejecución de git diff (código " .. diff_res.code .. ")"
	end

	local out = diff_res.stdout or ""
	if out == "" then
		return "  No hay cambios staged en este archivo"
	end

	-- 6. Emular: sed -n '/^@@ /,$p' | sed '1d'
	local lines = vim.split(out, "\n", { plain = true })
	local result = {}

	for _, line in ipairs(lines) do
		if vim.startswith(line, "+") and not vim.startswith(line, "+++") then
			table.insert(result, line)
		elseif vim.startswith(line, "-") and not vim.startswith(line, "---") then
			table.insert(result, line)
		elseif vim.startswith(line, " ") then
			table.insert(result, line)
			-- Si deseas que aparezcan los hunk header
		elseif vim.startswith(line, "@@ ") then
			table.insert(result, line)
		end
	end

	return #result > 0 and table.concat(result, "\n") or "  No hay cambios staged en este archivo"
end

return M
