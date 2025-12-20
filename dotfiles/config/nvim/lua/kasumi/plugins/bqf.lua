local fn = vim.fn

require("bqf").setup({
	-- auto_resize_height = true,
	preview = {
		border = "single",
		show_title = false,
		win_height = 11, -- altura del preview
		winblend = 5, -- 0 = sin transparencia
		show_scroll_bar = false,
		wrap = true, -- líneas largas se muestran completas,
	},
	func_map = {
		openc = "q", -- abrir y cerrar quickfix

		-- ─[ Desactivar todo los demás atajos ]─────────────────────
		drop = "",
		filter = "",
		filterr = "",
		lastleave = "",
		nextfile = "",
		nexthist = "",
		prevfile = "",
		prevhist = "",
		pscrolldown = "",
		pscrollorig = "",
		pscrollup = "",
		ptoggleauto = "",
		ptoggleitem = "",
		ptogglemode = "",
		sclear = "",
		split = "",
		stogglebuf = "",
		stoggledown = "",
		stoggleup = "",
		stogglevm = "",
		tab = "",
		tabb = "",
		tabc = "",
		tabdrop = "t",
		vsplit = "",
	},
	filter = {
		fzf = {
			extra_opts = {
				-- WARN: El delimitador debe coincidir exactamente con el usado en `fmt`,
				-- para que fzf interprete correctamente las columnas
				"--delimiter",
				"│",

				-- "--bind",
				-- "ctrl-o:toggle-all",
			},
		},
	},
})
-- ╒═══════════════════════════════════════════════════════════╕
-- │                      QUICKFIX LAYOUT                      │
-- ╘═══════════════════════════════════════════════════════════╛
-- No altera el contenido del quickfix, solo su representación visual.
-- 1. Reescribe el texto mostrado en el quickfix usando quickfixtextfunc.
-- 2. Normaliza rutas de archivo (usa ~ para $HOME y recorta nombres largos).
-- 3. Elimina columnas irrelevantes (como :0 en diffs de gitsigns).
-- 4. Extrae y separa el estado de cambios (Added / Removed / Changed)
-- 5. Genera columnas alineadas para nvim-bqf y fzf usando '│'.

function _G.qftf(info)
	local items
	local ret = {}

	-- ─[ Obtener items ]────────────────────────────────────────
	if info.quickfix == 1 then
		items = fn.getqflist({ id = info.id, items = 0 }).items
	else
		items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
	end

	local limit = 31
	local fnameFmt1 = "%-" .. limit .. "s"
	local fnameFmt2 = "…%." .. (limit - 1) .. "s"

	-- ─[ Formatos ]─────────────────────────────────────────────
	local fmt = "%s │%4d │ %-7s │ %s"
	-- ──────────────────────────────────────────────────────────

	for i = info.start_idx, info.end_idx do
		local e = items[i]
		local str

		if e.valid == 1 then
			-- Archivo
			local fname = "[No Name]"
			if e.bufnr > 0 then
				local name = fn.bufname(e.bufnr)
				if name ~= "" then
					fname = name:gsub("^" .. vim.env.HOME, "~")
				end
			end

			if #fname <= limit then
				fname = fnameFmt1:format(fname)
			else
				fname = fnameFmt2:format(fname:sub(1 - limit))
			end

			-- Línea (sin columna)
			local lnum = (e.lnum and e.lnum > 0) and e.lnum or -1

			-- Estado y texto limpio
			local status = ""
			local text = e.text or ""

			-- Extraer estado tipo: "Added   (-13,0 +12):"
			local s, rest = text:match("^(%u%l+)%s+%b():%s*(.*)$")
			if s then
				status = s -- Added / Removed / Changed
				text = rest or "" -- solo el contenido real
			end

			str = fmt:format(fname, lnum, status, text)
		else
			str = e.text
		end

		table.insert(ret, str)
	end

	return ret
end

vim.o.qftf = "{info -> v:lua._G.qftf(info)}"
