return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer", -- source for text in buffer
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-path", -- source for file system paths
		{
			"L3MON4D3/LuaSnip",
			version = "*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
			build = function()
				if require("ace.custom.os").getName() == "Windows" then
					vim.notify("Can't install jsregexp on window")
					return nil
				end
				return "make install_jsregexp"
			end,
			dependencies = { "saadparwaiz1/cmp_luasnip", "rafamadriz/friendly-snippets" },
		},
		"onsails/lspkind.nvim", -- vs-code like pictograms
		{ "hrsh7th/cmp-nvim-lua", ft = "lua" },
		{ "hrsh7th/cmp-nvim-lsp-signature-help" },
	},
	config = function()
		local lspkind = require("lspkind")
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		require("luasnip.loaders.from_vscode").lazy_load()

		-- NOTE:  deprioritize_snippet in some lsp
		local function deprioritize_snippet(entry1, entry2)
			if entry1:get_kind() == cmp.lsp.CompletionItemKind.Snippet then
				return false
			end
			if entry2:get_kind() == cmp.lsp.CompletionItemKind.Snippet then
				return true
			end
		end

		cmp.setup({
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
				["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
				["<C-e>"] = cmp.mapping.abort(), -- close completion window
				["<CR>"] = cmp.mapping.confirm({ select = false }),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<Tab>"] = cmp.mapping(function(fallback) -- super tab
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			sources = cmp.config.sources({
				{ name = "lazydev", group_index = 0 },
				{
					name = "nvim_lsp",
					priority = 1000,
				},
				{ name = "luasnip", priority = 750 },
				{ name = "buffer", keyword_length = 3, priority = 500 },
				{ name = "path", priority = 250 },
				{ name = "nvim_lsp_signature_help" },
			}),
			formatting = {
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
			},
			sorting = {
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
			},
			experimental = {
				ghost_text = true,
			},
			performance = {
				max_view_entries = 50,
			},
		})
	end,
}
