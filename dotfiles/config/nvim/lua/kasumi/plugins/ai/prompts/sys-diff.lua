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
	-- base conserva el prefijo numérico (ej. 05-ytdlp). El scope en commit.md
	-- omite ese prefijo; aquí solo se extrae el nombre sin extensión.
	local base = vim.fn.fnamemodify(abs_path, ":t:r") -- 05-ytdlp (sin extensión)

	-- Path relativo requerido por git diff dentro del repo.
	-- +2 salta el separador "/" entre repo_root y el resto del path.
	local rel_path = abs_path:sub(#repo_root + 2)

	-- Gemma-4 no distingue markdown de código; se detecta extensión para
	-- inyectar "tipo: docs" sin ancla por línea (el hint encuadra el diff,
	-- marcar cada línea era redundante y saturaba el prompt).
	local doc_exts = { md = true, markdown = true, txt = true, rst = true, adoc = true, org = true }
	local ext = vim.fn.fnamemodify(abs_path, ":e"):lower()
	local is_doc = doc_exts[ext] or false

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

	-- Eliminar metadatos git (diff --git, index, @@, ---/+++), conservar solo
	-- líneas de cambio (+/-) y contexto ( ).
	-- WARN: en Lua "-" es carácter mágico; "^--- " coincide con "- " y
	-- descarta eliminaciones. Debe ser "^%-%-%- " (guiones escapados con %).
	-- No "corregir" a "--- " sin "%".
	local lines = vim.split(diff_out, "\n", { plain = true })
	local filtered = {}

	for _, line in ipairs(lines) do
		local is_header = line:match("^@@ ")
			or line:match("^diff ")
			or line:match("^index ")
			or line:match("^%-%-%- ")
			or line:match("^%+%+%+ ")

		if not is_header then
			table.insert(filtered, line)
		end
	end

	-- Gemma-4-it confunde sintaxis de comentarios con código funcional.
	-- [COMENTARIO] reemplaza líneas de comentario, [REF] marca contexto.
	-- Sin estas anclas el modelo alucina funcionalidades inexistentes.
	for idx, line in ipairs(filtered) do
		local marker = line:sub(1, 1)
		local rest = line:sub(2)

		if marker == "+" or marker == "-" then
			-- En archivos doc no se marca [COMENTARIO]: el hint "tipo: docs"
			-- ya encuadra el diff; evita confundir # de markdown con comentario.
			-- Patrón cubre # // -- ; (C, Lua, shell, Python, JS...). No cubre
			-- bloques /* */ ni """; Gemma-4 no los requiere para inferir.
			if
				not is_doc
				and (rest:match("^%s*#") or rest:match("^%s*//") or rest:match("^%s*%-%-") or rest:match("^%s*;"))
			then
				filtered[idx] = marker .. " [COMENTARIO]"
			end
		elseif marker == " " then
			filtered[idx] = "[REF]" .. line
		end
	end

	-- Colapsar líneas [COMENTARIO] consecutivas del mismo marcador (+/-).
	-- Sin colapso, N líneas idénticas saturan el prompt y el modelo genera
	-- cuerpo repetido (misma línea N veces). Con colapso a 1, el modelo
	-- diferencia cambios sin forzar repetición.
	local collapsed = {}
	local prev = nil
	for _, line in ipairs(filtered) do
		if line:match("%[COMENTARIO%]") then
			if line ~= prev then
				table.insert(collapsed, line)
				prev = line
			end
		else
			table.insert(collapsed, line)
			prev = nil
		end
	end
	filtered = collapsed

	-- Heurística: si >50% de líneas +/- contienen [COMENTARIO], el cambio es
	-- puramente cosmético. Se inyecta "tipo: style" en el header para que el
	-- modelo no tenga que inferir la clasificación. Sin este hint, el modelo
	-- asigna feat aunque el diff solo tenga cambios en comentarios.
	local changed_lines = 0
	local comment_lines = 0
	for _, line in ipairs(filtered) do
		if line:sub(1, 1) == "+" or line:sub(1, 1) == "-" then
			changed_lines = changed_lines + 1
			if line:match("%[COMENTARIO%]") then
				comment_lines = comment_lines + 1
			end
		end
	end

	local hint = ""
	if is_doc then
		hint = "\ntipo: docs (archivo de documentación)"
	elseif changed_lines > 0 and (comment_lines / changed_lines) > 0.5 then
		hint = "\ntipo: style (solo comentarios)"
	end

	-- Cabecera estructurada: "directorio:" y "archivo:" dan contexto de
	-- origen; commit.md usa ambos para inferir el scope. "lenguaje:" es la
	-- extensión del archivo; el modelo infiere el lenguaje desde ella.
	local parent_dir = file_dir:match("([^/]+)$") or ""
	-- ext ya se calculó en línea 47; se reutiliza para el campo "lenguaje:".
	local header = "directorio: " .. parent_dir .. "\narchivo: " .. base .. "\nlenguaje: " .. ext .. hint .. "\n\n"
	return header .. table.concat(filtered, "\n")
end

return M
