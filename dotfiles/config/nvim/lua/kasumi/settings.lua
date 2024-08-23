local opt = vim.opt
local cmd = vim.cmd
local g = vim.g

-- COLOR SCHEME
-- La linea que carga el tema esta  hasta el final del mismo archivo
-- de configuración de catppuccin

-- Habilita el resaltado de sintaxis
cmd("syntax on")

vim.ui.select = require("dropbar.utils.menu").select
-- Establece los idiomas del corrector ortográfico a inglés y español (incluyendo español latinoamericano)

opt.spelllang = { "en_us", "es" }

-- Activa la corrección ortográfica
opt.spell = true

-- Activa los colores de terminal de 24 bits
opt.termguicolors = true

-- AJUSTES
--
opt.cursorline = true -- Resalta la línea actual
opt.foldmethod = "manual" -- Método manual de plegado
opt.lazyredraw = true -- No actualizar la pantalla durante la ejecución de macros y scripts
opt.number = true -- Mostrar el número de línea actual (absoluto)
opt.relativenumber = true -- Mostrar las líneas relativas a la actual
opt.showmode = false -- Ocultar el aviso que indica en qué modo estás
opt.spelllang = { "en", "es" } -- Corregir palabras usando diccionarios en inglés y español
opt.splitbelow = true -- Controla la posición de la nueva ventana (abajo)
opt.splitright = true -- Controla la posición de la nueva ventana (a la derecha)
opt.ttyfast = true -- Acelera el scroll
opt.undofile = true -- Guarda el historial de deshacer. Persistencia entre sesiones.

-- IDENTACION
--
opt.autoindent = true -- Las nuevas líneas heredan la indentación de las líneas anteriores
opt.smartindent = true
-- opt.smarttab = true
opt.expandtab = true -- Utilizar espacios en lugar de TAB
opt.shiftwidth = 4 -- Cantidad de espacios para ident. Si afecta al guardar.
opt.softtabstop = 4 -- Cuando eliminas, cuántos espacios debe quitar
opt.tabstop = 4 -- Define el ancho visual de las tabulaciones. Un <TAB> en BAT usa 4 espacios.

-- TEXTO
--
opt.mouse = "ivh" -- Desactivar soporte del ratón en el modo normal
opt.scrolloff = 20 -- Mantener ciertas líneas visibles antes de llegar al final o comienzo
opt.sidescrolloff = 10 -- Margen de espacio a la izquierda o derecha
opt.wrap = false -- Desactivar el ajuste de línea

-- BÚSQUEDAS
--
opt.hlsearch = true -- Resalta todas las coincidencias de la búsqueda
opt.ignorecase = true -- Ignorar mayúsculas al hacer búsquedas
opt.incsearch = true -- Muestra coincidencias a medida que escribes
opt.magic = true -- Evita que utilices '\' cuando empleas regex
opt.smartcase = true -- No ignorar mayúsculas si la palabra contiene mayúsculas

-- CARACTERES INVISIBLES
--
opt.list = true -- habilita el ver caracteres ocultos
opt.showbreak = "↪"
opt.listchars = {
	tab = "🠖  ",
	eol = "↲",
	trail = "",
	extends = "⟩",
	precedes = "⟨",
	nbsp = "󱀝",
}

-- Ignora los temas que trae por defecto
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

-- PRUEBAS
--
opt.completeopt = "menu,menuone,noselect"
opt.clipboard = { "unnamed", "unnamedplus" }
opt.pumblend = 8 -- transparencia del Pop-up

-- Configuración de CtrlP
g.ctrlp_user_command = { ".git", "cd %s && git ls-files -co --exclude-standard" } -- Ocultar archivos en .gitignore
g.ctrlp_show_hidden = 1 -- Mostrar archivos ocultos (dot files)
