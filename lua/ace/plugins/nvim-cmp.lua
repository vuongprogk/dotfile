return {
	{
		"hrsh7th/nvim-cmp",
		event = "VeryLazy",
		dependencies = {},
		opts = function(_, opts)
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
			opts.mapping = vim.tbl_extend("force", opts.mapping, {
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
			table.insert(opts.sources, {
				{ name = "lazydev", group_index = 0 },
			})
		end,
	},

	{
		"hrsh7th/cmp-buffer", -- source for text in buffer
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/nvim-cmp",
			opts = function(_, opts)
				table.insert(opts.sources, { name = "buffer", priority = 250 })
			end,
		},
	},
	{
		"hrsh7th/cmp-path", -- source for file system paths
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/nvim-cmp",
			opts = function(_, opts)
				table.insert(opts.sources, { name = "path", priority = 500 })
			end,
		},
	},
	{
		"hrsh7th/cmp-nvim-lsp-signature-help",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/nvim-cmp",
			opts = function(_, opts)
				table.insert(opts.sources, { name = "nvim_lsp_signature_help", priority = 1000 })
			end,
		},
	},
}
