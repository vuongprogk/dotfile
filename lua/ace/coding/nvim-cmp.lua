return {
	"hrsh7th/nvim-cmp",
	version = false, -- last release is way too oldevent = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"onsails/lspkind.nvim",
	},
	opts = function()
		vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
		local cmp = require("cmp")
		local auto_select = true
		local defaults = require("cmp.config.default")()
		return {
			auto_brackets = {}, -- configure any filetype to auto add brackets
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
				["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-s>"] = cmp.mapping.complete(), -- show completion suggestions because some terminal emulator not word
				["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
				["<C-e>"] = cmp.mapping.abort(), -- close completion window
				["<C-CR>"] = cmp.mapping.abort(), -- close completion window
				["<S-CR>"] = Ace.cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				["<CR>"] = Ace.cmp.confirm({ select = auto_select }),
			}),
			preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
			completion = {
				completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
			},
			experimental = {
				ghost_text = {
					hl_group = "CmpGhostText",
				},
			},
			sorting = defaults.sorting,
			formatting = {
				format = require("lspkind").cmp_format({
					mode = "symbol_text",
					maxwidth = 50,
					show_labelDetails = false,
					-- TODO: Refactor this
					menu = {
						nvim_lsp = "[LSP]",
						path = "[Path]",
						nvim_lua = "[Lua]",
						buffer = "[Buffer]",
						emoji = "[Emoji]",
						luasnip = "[LuaSnip]",
						copilot = "[Copilot]",
					},
					before = function(entry, vim_item)
						if Ace.is_loaded("tailwindcss-colorizer-cmp.nvim") then
							vim_item = require("tailwindcss-colorizer-cmp").formatter(entry, vim_item)
						end
						return vim_item
					end,
				}),
			},
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "path" },
			}, {
				{ name = "buffer" },
			}),
		}
	end,
	main = "ace.core.util.cmp",
}
