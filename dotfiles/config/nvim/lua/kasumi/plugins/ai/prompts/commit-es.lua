-- Helper para el prompt "Commit en Español"
-- Proporciona la función staged_diff que devuelve el git diff --cached
---@diagnostic disable: unused-local

return {
	staged_diff = function(args)
		-- 1. Archivo del buffer actual
		local bufname = vim.api.nvim_buf_get_name(0)
		if bufname == "" then
			return "  No hay archivo abierto en el buffer actual."
		end

		-- 2. Resolver symlink → path real
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

		-- 4. Calcular path relativo para Git (desde la raíz real)
		local rel = real:sub(#root + 2) -- quita root + el slash
		if rel == real or rel == "" then
			return "  El archivo no pertenece al repositorio Git."
		end

		-- 5. Obtener diff staged → ejecutando desde la raíz real del repo
		local diff_res = vim.system({
			"git",
			"diff",
			"--cached",
			"--no-ext-diff",
			"--",
			rel,
		}, { text = true, cwd = root }):wait()

		if diff_res.code ~= 0 then
			return "  Falló la ejecución de git diff (código " .. diff_res.code .. ")"
		end

		local diff = diff_res.stdout or ""
		return diff ~= "" and diff or "  No hay cambios staged en este archivo"
	end,
}
