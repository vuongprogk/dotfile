return {

	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-nvim-lsp-signature-help",
	},
	opts = function(_, opts)
		vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
		local cmp = require("cmp")
		local defaults = require("cmp.config.default")()
		local auto_select = true
		return {
			mapping = vim.tbl_extend("force", opts.mapping, {
				["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
				["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-s>"] = cmp.mapping.complete(), -- show completion suggestions because some terminal emulator not word
				["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
				["<C-e>"] = cmp.mapping.abort(), -- close completion window

				["<C-CR>"] = cmp.mapping.abort(), -- close completion window
				["<CR>"] = cmp.mapping.confirm({ select = true }),
			}),
			preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,

			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			completion = {
				completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
			},
			sources = cmp.config.sources({
				{ name = "nvim_lsp_signature_help", priority = 1000 },
				{ name = "lazydev", group_index = 0 },
				{
					name = "nvim_lsp",
					priority = 1000,
					entry_filter = function(entry)
						local list_server = vim.lsp.get_clients()
						for _, server in ipairs(list_server) do
							if server.name == "tsserver" then
								return require("cmp").lsp.CompletionItemKind.Snippet ~= entry:get_kind()
							end
						end
						return true
					end,
				},
				{ name = "path", priority = 500 },
			}, {
				{ name = "buffer", priority = 250 },
			}),
			experimental = {
				ghost_text = {
					hl_group = "CmpGhostText",
				},
			},
			sorting = defaults.sorting,
		}
	end,
}
