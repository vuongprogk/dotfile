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
						format = function(entry, vim_item)
							local cmp_format = require("lspkind").cmp_format({
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
								before = function(nested_entry, nested_vim_item)
									require("tailwindcss-colorizer-cmp").formatter(nested_entry, nested_vim_item)
									return vim_item
								end,
							})
							return cmp_format(entry, vim_item)
						end,
					}
				end,
			},
		},
	},
}
