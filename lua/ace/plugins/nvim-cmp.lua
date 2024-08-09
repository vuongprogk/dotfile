return {
	{
		"hrsh7th/nvim-cmp",
		event = "VeryLazy",
		dependencies = {
			"onsails/lspkind.nvim", -- vs-code like pictograms
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
		},
		opts = function(_, opts)
			local lspkind = require("lspkind")
			local cmp = require("cmp")

			-- NOTE:  deprioritize_snippet in some lsp
			local function deprioritize_snippet(entry1, entry2)
				if entry1:get_kind() == cmp.lsp.CompletionItemKind.Snippet then
					return false
				end
				if entry2:get_kind() == cmp.lsp.CompletionItemKind.Snippet then
					return true
				end
			end
			opts.mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
				["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-s>"] = cmp.mapping.complete(), -- show completion suggestions because some terminal emulator not word
				["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
				["<C-e>"] = cmp.mapping.abort(), -- close completion window
				["<CR>"] = cmp.mapping.confirm({ select = true }),
			})
			opts.window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			}
			opts.sources = cmp.config.sources({
				{ name = "lazydev", group_index = 0 },
				{ name = "nvim_lsp_signature_help" },
			})
			opts.formatting = {
				fields = {
					cmp.ItemField.Abbr,
					cmp.ItemField.Kind,
					cmp.ItemField.Menu,
				},
				format = lspkind.cmp_format({
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
			opts.sorting = {
				priority_weight = 2,
				comparators = {
					deprioritize_snippet,
					cmp.config.compare.offset,
					cmp.config.compare.exact,
					cmp.config.compare.scopes,
					cmp.config.compare.score,
					cmp.config.compare.recently_used,
					cmp.config.compare.locality,
					cmp.config.compare.kind,
					cmp.config.compare.sort_text,
					cmp.config.compare.length,
					cmp.config.compare.order,
				},
			}
			opts.completion = {
				completeopt = "menu,menuone,noinsert",
			}
		end,
	},
	{
		"hrsh7th/cmp-buffer", -- source for text in buffer
		dependencies = { "hrsh7th/nvim-cmp" },
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local cmp = require("cmp")
			local config = cmp.get_config()

			table.insert(config.sources, { name = "buffer", priority = 500 })
			cmp.setup(config)
		end,
	},
	{
		"hrsh7th/cmp-path", -- source for file system paths
		dependencies = { "hrsh7th/nvim-cmp" },
		event = "InsertEnter",
		config = function()
			local cmp = require("cmp")
			local config = cmp.get_config()

			table.insert(config.sources, { name = "path", priority = 250 })
			cmp.setup(config)
		end,
	},
}
