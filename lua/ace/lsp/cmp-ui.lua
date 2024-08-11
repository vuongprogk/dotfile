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
	{
		"onsails/lspkind.nvim", -- vs-code like pictograms
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{
				"hrsh7th/nvim-cmp",
				opts = function(_, opts)
					opts.formatting = {
						fields = {
							"abbr",
							"kind",
							"menu",
						},
						format = require("lspkind").cmp_format({
							mode = "symbol_text",
							maxwidth = 50,
							ellipsis_char = "...",
							menu = {
								buffer = "[Buffer]",
								nvim_lsp = "[LSP]",
								luasnip = "[LuaSnip]",
								nvim_lua = "[Lua]",
								latex_symbols = "[Latex]",
							},
							before = require("tailwindcss-colorizer-cmp").formatter,
						}),
					}
				end,
			},
		},
	},
}
