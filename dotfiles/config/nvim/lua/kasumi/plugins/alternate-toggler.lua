-- ┌────────────────────────────────────────────┐
-- │░█▀█░█░░░▀█▀░░░░░▀█▀░█▀█░█▀▀░█▀▀░█░░░█▀▀░█▀▄│
-- │░█▀█░█░░░░█░░▄▄▄░░█░░█░█░█░█░█░█░█░░░█▀▀░█▀▄│
-- │░▀░▀░▀▀▀░░▀░░░░░░░▀░░▀▀▀░▀▀▀░▀▀▀░▀▀▀░▀▀▀░▀░▀│
-- └────────────────────────────────────────────┘
-- Alterna valores definidos como pares opuestos
-- (true/false, on/off, enable/disable) bajo reglas configurables.

require("alternate-toggler").setup({
	alternates = {
		{ "enable", "disable" },
		{ "true", "false" },
		{ "nolink", "absolute" },
	},
})
