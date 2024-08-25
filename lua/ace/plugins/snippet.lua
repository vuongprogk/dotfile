return {
	"nvim-cmp",
	dependencies = {
		{
			"garymjr/nvim-snippets",
			opts = {
				friendly_snippets = true,
			},
			dependencies = { "rafamadriz/friendly-snippets" },
		},
	},
	opts = function(_, opts)
		opts.snippet = {
			expand = function(item)
				return vim.snippet.expand(item.body)
			end,
		}
		table.insert(opts.sources, {
			name = "snippets",
			max_item_count = 5,
			priority = 500,
		})
	end,
}
