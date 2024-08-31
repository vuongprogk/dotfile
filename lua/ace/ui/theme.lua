return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		style = "night", -- The theme comes in three styles, `storm`, a darker variant `night` and `day`
	},
	config = function(_, opts)
		require("tokyonight").load(opts)
	end,
}
