return {
	{
		"NvChad/nvim-colorizer.lua",
		opts = {
			user_default_options = {
				names = false,
				tailwind = true,
			},
		},
	},
	{
		"roobert/tailwindcss-colorizer-cmp.nvim",
		opts = {
			color_square_width = 1,
		},
	},
	{
		"laytan/tailwind-sorter.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
		build = "cd formatter && npm ci && npm run build",
		config = true,
	},
}
