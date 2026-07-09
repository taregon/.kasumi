-- Helper para el prompt "Commit en Español"
-- Expone staged_diff(), que obtiene el diff staged del archivo actual
-- descartando metadatos y encabezados de hunk (@@).
-- Conserva únicamente las líneas de cambio reales (+/-).
-- Comportamiento equivalente (aplicado a un solo archivo) a:
-- git diff --cached --no-ext-diff --no-prefix --unified=1 --color=never

local M = {}

function M.staged_diff()
	-- Archivo asociado al buffer actual.
	local buf_path = vim.api.nvim_buf_get_name(0)
	if buf_path == "" then
		return "  No hay archivo abierto en el buffer actual."
	end

	-- Resolver symlinks evita diffs vacíos en repositorios enlazados desde dotfiles.
	local abs_path = vim.uv.fs_realpath(buf_path)
	if not abs_path then
		return "  No se pudo resolver el path real del archivo."
	end

	-- Root del repositorio calculado desde el archivo real.
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

	-- Path relativo requerido por git diff dentro del repo.
	local rel_path = abs_path:sub(#repo_root + 2)

	-- Diff staged del archivo actual, sin color ni herramientas externas.
	local diff_res = vim.system({
		"git",
		"--no-pager",
		"diff",
		"--cached",
		"--no-ext-diff",
		"--no-prefix",
		"--unified=1", -- agrega más contexto antes/después del hunk
		"--color=never",
		"--",
		rel_path,
	}, { text = true, cwd = repo_root }):wait()

	if diff_res.code ~= 0 then
		return "  Falló la ejecución de git diff (código " .. diff_res.code .. ")"
	end

	local diff_out = diff_res.stdout or ""
	if diff_out == "" then
		return "  No hay cambios staged en este archivo."
	end

	-- El prompt solo necesita el cuerpo del diff, no metadatos ni encabezados.
	local lines = vim.split(diff_out, "\n", { plain = true })
	local filtered = {}

	for _, line in ipairs(lines) do
		local is_header = line:match("^@@ ")
			or line:match("^diff ")
			or line:match("^index ")
			or line:match("^--- ")
			or line:match("^%+%+%+ ")

		if not is_header then
			table.insert(filtered, line)
		end
	end

	-- Anclar líneas de comentario y contexto para que el modelo no las
	-- interprete como código. [COMENTARIO] reemplaza el contenido de la línea
	-- para evitar ruido decorativo. [CONTEXTO] se antepone al contenido original.
	for idx, line in ipairs(filtered) do
		local marker = line:sub(1, 1)
		local rest = line:sub(2)

		if marker == "+" or marker == "-" then
			if rest:match("^%s*#") or rest:match("^%s*//")
				or rest:match("^%s*%-%-") or rest:match("^%s*;")
			then
				filtered[idx] = marker .. " [COMENTARIO]"
			end
		elseif marker == " " then
			filtered[idx] = "[CONTEXTO]" .. line
		end
	end

	-- Cabecera compacta para ubicar el origen del diff en el prompt.
	local parent_dir = file_dir:match("([^/]+)$") or ""
	local header = "de: " .. parent_dir .. "/" .. file_name .. "\n\n"
	return header .. table.concat(filtered, "\n")
end

return M
