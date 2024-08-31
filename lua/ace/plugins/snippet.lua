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
				return Ace.cmp.expand(item.body)
			end,
		}
		if Ace.has("nvim-snippets") then
			table.insert(opts.sources, { name = "snippets" })
		end
	end,
	keys = {
		{
			"<Tab>",
			function()
				if vim.snippet.active({ direction = 1 }) then
					vim.schedule(function()
						vim.snippet.jump(1)
					end)
					return
				end
				return "<Tab>"
			end,
			expr = true,
			silent = true,
			mode = "i",
		},
		{
			"<Tab>",
			function()
				vim.schedule(function()
					vim.snippet.jump(1)
				end)
			end,
			expr = true,
			silent = true,
			mode = "s",
		},
		{
			"<S-Tab>",
			function()
				if vim.snippet.active({ direction = -1 }) then
					vim.schedule(function()
						vim.snippet.jump(-1)
					end)
					return
				end
				return "<S-Tab>"
			end,
			expr = true,
			silent = true,
			mode = { "i", "s" },
		},
	},
}