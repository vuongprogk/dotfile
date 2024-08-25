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
		event = { "BufReadPre", "BufNewFile" },
		cond = vim.fs.find({ "tailwind.config.js" }, { upward = true })[1] and true or false,
		opts = {
			color_square_width = 1,
		},
	},
	{
		"laytan/tailwind-sorter.nvim",
		event = { "BufReadPre", "BufNewFile" },
		cond = vim.fs.find({ "tailwind.config.js" }, { upward = true })[1] and true or false,
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
		build = "cd formatter && npm ci && npm run build",
		config = true,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"onsails/lspkind.nvim", -- vs-code like pictograms
		},
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
						symbol_map = Ace.config.icons.kinds,
						menu = {
							buffer = "[Buffer]",
							nvim_lsp = "[LSP]",
							luasnip = "[LuaSnip]",
							nvim_lua = "[Lua]",
							latex_symbols = "[Latex]",
							copilot = "[Copilot]",
							snippets = "[Snippets]",
						},
						before = function(nested_entry, nested_vim_item)
							local tailwind = vim.fs.find({ "tailwind.config.js" }, { upward = true })[1]
							if tailwind then
								require("tailwindcss-colorizer-cmp").formatter(nested_entry, nested_vim_item)
							end
							return nested_vim_item
						end,
					})
					return cmp_format(entry, vim_item)
				end,
			}
		end,
	},
}
