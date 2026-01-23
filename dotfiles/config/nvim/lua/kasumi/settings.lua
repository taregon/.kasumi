local opt = vim.opt
local cmd = vim.cmd

-- ╒═══════════════════════════════════════════════════════════╕
-- │                       COLOR SCHEME                        │
-- ╘═══════════════════════════════════════════════════════════╛
-- La linea que carga el tema esta  hasta el final del mismo archivo
-- de configuración de catppuccin
cmd("syntax on") -- Habilita el resaltado de sintaxis
opt.termguicolors = true -- Activa los colores de terminal de 24 bits

-- ╒═══════════════════════════════════════════════════════════╕
-- │                          AJUSTES                          │
-- ╘═══════════════════════════════════════════════════════════╛
-- NOTA: opt.relativenumber paso a ser un autocomando
opt.cursorline = true -- Resalta la línea actual
opt.lazyredraw = true -- No actualizar la pantalla durante la ejecución de macros y scripts
opt.number = true -- Mostrar el número de línea actual (absoluto)
opt.pumblend = 6 -- Transparencia del Pop-up
opt.showmode = false -- Ocultar el aviso que indica en qué modo estás
opt.spell = true -- Activa la corrección ortográfica
opt.spelllang = { "en", "es" } -- Corregir palabras usando diccionarios en inglés y español
opt.splitbelow = true -- Controla la posición de la nueva ventana (abajo)
opt.splitright = true -- Controla la posición de la nueva ventana (a la derecha)
opt.ttyfast = true -- Acelera el scroll
opt.undofile = true -- Guarda el historial de deshacer. Persistencia entre sesiones.

-- ╒═══════════════════════════════════════════════════════════╕
-- │                        IDENTACION                         │
-- ╘═══════════════════════════════════════════════════════════╛
-- opt.smarttab = true
opt.autoindent = true -- Las nuevas líneas heredan la indentación de las líneas anteriores
opt.expandtab = true -- Utilizar espacios en lugar de TAB
opt.shiftwidth = 4 -- Cantidad de espacios para ident. Si afecta al guardar.
opt.smartindent = true
opt.softtabstop = 4 -- Cuando eliminas, cuántos espacios debe quitar
opt.tabstop = 4 -- Define el ancho visual de las tabulaciones. Un <TAB> en BAT usa 4 espacios.

-- ╒═══════════════════════════════════════════════════════════╕
-- │                           TEXTO                           │
-- ╘═══════════════════════════════════════════════════════════╛
opt.conceallevel = 2 -- Oculta marcas de formato en markdown
opt.mouse = "ivh" -- Desactivar soporte del ratón en el modo normal
opt.pumheight = 10 -- Establece la altura máxima del menú de completado.
opt.scrolloff = 20 -- Mantener ciertas líneas visibles antes de llegar al final o comienzo
opt.sidescrolloff = 10 -- Margen de espacio a la izquierda o derecha
opt.virtualedit = "block" -- Permitir el movimiento del cursor cuando no hay texto en V-BLOCK
opt.winminwidth = 10 -- Ancho mínimo de una ventana
opt.wrap = false -- Desactivar el ajuste de línea

-- ╒═══════════════════════════════════════════════════════════╕
-- │                         BÚSQUEDAS                         │
-- ╘═══════════════════════════════════════════════════════════╛
opt.hlsearch = true -- Resalta todas las coincidencias de la búsqueda
opt.ignorecase = true -- Ignorar mayúsculas al hacer búsquedas
opt.incsearch = true -- Muestra coincidencias a medida que escribes
opt.magic = true -- Evita que utilices '\' cuando empleas regex
opt.smartcase = true -- No ignorar mayúsculas si la palabra contiene mayúsculas

-- ╒═══════════════════════════════════════════════════════════╕
-- │                   CARACTERES INVISIBLES                   │
-- ╘═══════════════════════════════════════════════════════════╛
opt.list = true -- habilita el ver caracteres ocultos
opt.showbreak = "↪"
opt.listchars = {
	eol = "↲",
	extends = "⟩",
	nbsp = "✖",
	precedes = "⟨",
	tab = "  ",
	trail = "▓",
}

-- ╒═══════════════════════════════════════════════════════════╕
-- │                   CARACTERES DE RELLENO                   │
-- ╘═══════════════════════════════════════════════════════════╛
opt.fillchars = {
	-- msgsep = "‾",
	diff = "",
	eob = " ", -- Suprime el carácter "~" EndOfBuffer
	fold = "🮨", -- Queda bonito por que sirve de relleno en la barra del diff
	foldclose = " ",
	foldopen = "🭬",
	foldsep = " ",
	vert = "│", --Carácter vertical (vsplit)
}

-- ╒═══════════════════════════════════════════════════════════╕
-- │           Ignora los temas que trae por defecto           │
-- ╘═══════════════════════════════════════════════════════════╛
opt.wildignore = {
	"blue.vim",
	"darkblue.vim",
	"delek.vim",
	"desert.vim",
	"elflord.vim",
	"evening.vim",
	"industry.vim",
	"habamax.vim",
	"koehler.vim",
	"lunaperche.vim",
	"morning.vim",
	"murphy.vim",
	"pablo.vim",
	"peachpuff.vim",
	"quiet.vim",
	"ron.vim",
	"shine.vim",
	"slate.vim",
	"sorbet.vim",
	"retrobox.vim",
	"torte.vim",
	"wildcharm.vim",
	"zaibatsu.vim",
	"zellner.vim",
}

-- ╒═══════════════════════════════════════════════════════════╕
-- │             AJUSTES PARA EL PLEGADO DE TEXTO              │
-- ╘═══════════════════════════════════════════════════════════╛
-- Se aprecia cuando presionas F5 para el git diff
opt.foldenable = true -- Habilita el plegado de forma predeterminada
opt.foldmethod = "expr" -- Método de plegado
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99 -- todos los folds abiertos al inicio
opt.foldcolumn = "0" -- Antes "auto:9", pero cuando se anidan se ve feo el `statuscolumn`

-- ────────────────────────────────────────────────────────────
-- █▀▀▀▀ ▄▀▀▀▄ █     █▀▀▀▄
-- █▀▀   █   █ █     █   █
-- ▀      ▀▀▀  ▀▀▀▀▀ ▀▀▀▀
-- FUNCIÓN PERSONALIZADA PARA EL TEXTO DEL FOLD

function CustomFoldText()
	-- Obtener la primera línea del fold (nombre de función, condicional, etc.)
	local line = vim.fn.getline(vim.v.foldstart)
	line = line:gsub("^%s+", "") -- elimina espacios o tabs iniciales

	-- Calcular tamaño del fold
	local fold_size = 1 + vim.v.foldend - vim.v.foldstart
	local fold_size_str = "" .. fold_size .. " 🮥🮥🮥 "

	-- Decoración con foldlevel
	local fold_level_str = string.rep("🮤🮤🮤   ", vim.v.foldlevel)

	-- Combinar decoración y primera línea del fold
	return fold_level_str .. fold_size_str .. line
end

opt.foldtext = "v:lua.CustomFoldText()"

-- ╒═══════════════════════════════════════════════════════════╕
-- │                          PRUEBAS                          │
-- ╘═══════════════════════════════════════════════════════════╛
-- opt.completeopt = "menu,menuone,noselect"
opt.completeopt = {
	"menuone",
	"noselect",
	"noinsert",
	"preview",
}
opt.clipboard = { "unnamed", "unnamedplus" }
