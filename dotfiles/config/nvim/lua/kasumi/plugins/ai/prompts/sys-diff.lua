-- Helper para el prompt "Commit en Español"
-- Expone staged_diff(), que obtiene el diff staged del archivo actual
-- descartando metadatos y encabezados de hunk (@@).
-- Conserva únicamente las líneas de cambio reales (+/-).
-- Comportamiento equivalente (aplicado a un solo archivo) a:
-- git diff --cached --no-ext-diff --no-prefix --unified=0 --color=never

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
	-- Nombre ya normalizado para scope: sin prefijo numérico, puntos,
	-- extensión ni ruta; solo minúsculas, letras, números y guiones.
	-- El modelo lo copia tal cual, sin transformar.
	local raw_base = vim.fn.fnamemodify(abs_path, ":t:r") -- ej. 05-ytdlp, .zlogin
	local base = raw_base:gsub("^%d+%-", ""):gsub("^%.+", ""):lower():gsub("[^%w%-]", "") -- ej. ytdlp, zlogin

	-- Path relativo requerido por git diff dentro del repo.
	-- +2 salta el separador "/" entre repo_root y el resto del path.
	local rel_path = abs_path:sub(#repo_root + 2)

	-- Gemma-4 no distingue markdown de código; se detecta extensión para
	-- inyectar [TYPE] docs (el hint encuadra el diff, marcar cada línea
	-- era redundante y saturaba el prompt).
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
		"--unified=0", -- sin líneas de contexto
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
	-- líneas de cambio y contexto; los marcadores [+]/[-] se aplican después.
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
			-- Ruido de archivo nuevo que el modelo cita como contenido.
			or line:match("^new file ")
			or line:match("^deleted file ")
			or line:match("^old mode")
			or line:match("^new mode")
			or line:match("^similarity ")
			or line:match("^rename ")

		if not is_header then
			table.insert(filtered, line)
		end
	end

	-- Gemma-4-it confunde sintaxis de comentarios con código funcional.
	-- [CMT] marca líneas de comentario conservando un tramo de su texto;
	-- [+]/[-] marcan líneas añadidas/eliminadas.
	-- Sin estas anclas el modelo alucina funcionalidades inexistentes.
	-- Sin [REF]: unified=0 no emite líneas de contexto.
	-- Marcado en una sola fase: banners descartados al vuelo, resto a tabla nueva.
	local marked = {}
	for _, line in ipairs(filtered) do
		local marker = line:sub(1, 1)
		local rest = line:sub(2)

		if marker == "+" or marker == "-" then
			-- Banners decorativos con box-drawing solo aportan ruido;
			-- se descartan para que el modelo describa código funcional.
			if not rest:match("[─═│╒╕╘╛┌┐└┘╔╗╚╝]") then
				-- El símbolo +/- no se marca: el modelo local lo confunde con
				-- markdown (listas). Se reemplaza por los marcadores [+]/[-].
				local sym = marker == "+" and "[+]" or "[-]"
				-- En archivos doc no se marca [CMT]: el hint [TYPE] docs
				-- ya encuadra el diff; evita confundir # de markdown con comentario.
				-- Patrón cubre # // -- ; (C, Lua, shell, Python, JS...). No cubre
				-- bloques /* */ ni """; Gemma-4 no los requiere para inferir.
				if
					not is_doc
					and (rest:match("^%s*#") or rest:match("^%s*//") or rest:match("^%s*%-%-") or rest:match("^%s*;"))
				then
					-- Suprimir todo el texto obligaba al modelo a inventar el
					-- contenido del comentario; el tramo conserva su significado.
					-- 40 caracteres bastan para el asunto sin saturar un modelo 2B.
					local ctx = rest:sub(1, 40)
					-- Trim evita que la indentación consuma parte del límite.
					ctx = vim.trim(ctx)
					-- El corte puede dejar frases incompletas; [...] evita que el
					-- modelo trate el tramo como texto completo y lo cite entero.
					if #rest > 40 then
						ctx = ctx .. " [...]"
					end
					table.insert(marked, sym .. " [CMT] " .. ctx)
				else
					table.insert(marked, sym .. " " .. rest)
				end
			end
		else
			-- Resto (ej. "\ No newline") pasa intacto.
			table.insert(marked, line)
		end
	end

	-- Colapsar [CMT] idénticas adyacentes; en la misma pasada se cuentan
	-- cambios y funcionales para el hint [TYPE]. Sin colapso, N líneas
	-- idénticas saturan el prompt y el modelo repite cuerpo.
	local collapsed = {}
	local prev = nil
	local changed_lines = 0
	local functional_lines = 0
	for _, line in ipairs(marked) do
		local prefix = line:sub(1, 3)
		if prefix == "[+]" or prefix == "[-]" then
			changed_lines = changed_lines + 1
			if not line:match("%[CMT%]") then
				functional_lines = functional_lines + 1
			end
		end
		if line:match("%[CMT%]") then
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

	-- Heurística: solo si no hay líneas funcionales el cambio es cosmético.
	-- Antes bastaba >50% [CMT]; eso marcaba style en archivos nuevos con
	-- banner + código real (ej. .zlogin con fastfetch). Ahora se exige
	-- cero líneas [+]/[-] sin [CMT] para inyectar style.
	local hint = ""
	if is_doc then
		hint = "\n[TYPE] docs"
	elseif changed_lines > 0 and functional_lines == 0 then
		hint = "\n[TYPE] style"
	end

	-- Cabecera mínima: [SDR] da el contexto, [SFL] el objeto ya
	-- normalizado para scope, [EXT] el lenguaje si hay extensión
	-- y [TYPE] la clasificación.
	-- [SDR] solo último segmento; contexto mínimo para modelo 2B.
	local parent_dir = file_dir:match("([^/]+)$") or ""
	local header = "[SDR] " .. parent_dir .. "\n[SFL] " .. base
	-- Sin extensión no se emite [EXT]: evita línea vacía que el modelo cita.
	if ext ~= "" then
		header = header .. "\n[EXT] " .. ext
	end
	header = header .. hint .. "\n\n"
	return header .. table.concat(filtered, "\n")
end

return M
