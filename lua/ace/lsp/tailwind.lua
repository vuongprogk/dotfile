return {
	{
		"NvChad/nvim-colorizer.lua",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			user_default_options = {
				names = false,
				tailwind = true,
			},
		},
	},
	{
		"roobert/tailwindcss-colorizer-cmp.nvim",
		lazy = true,
		opts = {
			color_square_width = 1,
		},
	},
	{
		"laytan/tailwind-sorter.nvim",
		cmd = { "TailwindSort", "TailwindSortOnSaveToggle" },
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
		build = "cd formatter && npm ci && npm run build",
		config = true,
	},
}
