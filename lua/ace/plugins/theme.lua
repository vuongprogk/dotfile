return {

	"folke/tokyonight.nvim",
	priority = 1000,
	opts = {
		style = "night", -- The theme comes in three styles, `storm`, a darker variant `night` and `day`
		light_style = "night", -- The theme is used when the background is set to light
		transparent = not vim.g.enabled_neovide and true or false, -- Enable this to disable setting the background color
		terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
		styles = {
			comments = { italic = true },
			keywords = { italic = true },
			functions = { italic = true, bold = true },
			variables = { bold = true },
			sidebars = "dark", -- style for sidebars, see below
			floats = not vim.g.enabled_neovide and "transparent" or "dark", -- style for floating windows
		},
		day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
		dim_inactive = false, -- dims inactive windows
		lualine_bold = true, -- When `true`, section headers in the lualine theme will be bold
		plugins = { markdown = true },
	},
	config = function(_, opts)
		require("tokyonight").setup(opts)
		vim.cmd([[colorscheme tokyonight-night]])
	end,
}
