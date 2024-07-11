return {
	"craftzdog/solarized-osaka.nvim",
	priority = 1000,
	config = function()
		require("solarized-osaka").setup({
			styles = {
				comments = { italic = true },
				keywords = { italic = true },
				functions = { italic = true, bold = true },
				variables = {},
				sidebars = "transparent", -- style for sidebars, see below
				floats = "transparent", -- style for floating windows
			},
			sidebars = { "qf", "vista_kind", "terminal", "packer", "NvimTree" },
			day_brightness = 1,
			hide_inactive_statusline = true,
			lualine_bold = true,
		})
		vim.cmd([[colorscheme solarized-osaka]])
	end,
}
