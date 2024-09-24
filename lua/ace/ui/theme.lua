return {
	"craftzdog/solarized-osaka.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		transparent = vim.g.neovide and false or false,
		styles = {
			comments = { italic = true },
			keywords = { italic = true, bold = true },
			functions = { italic = true, bold = true },
		},
		on_colors = function(colors)
			colors.hint = colors.orange
			colors.error = "#ff0000"
		end,
	},
	config = function(_, opts)
		require("solarized-osaka").load(opts)
	end,
}
