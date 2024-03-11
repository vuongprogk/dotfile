return {
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			require("solarized-osaka").setup({
				transparent = not vim.g.neovide
			})
			vim.cmd([[colorscheme solarized-osaka]])
		end,
	},
}
