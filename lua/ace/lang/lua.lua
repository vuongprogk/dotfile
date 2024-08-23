return {
	{
		"folke/lazydev.nvim",
		cond = vim.fs.find({ "init.lua" }, { upward = true })[1] and true or false,
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
	{
		"hrsh7th/nvim-cmp",
		opts = function(_, opts)
			table.insert(opts.sources, { name = "lazydev", group_index = 0 })
		end,
	},
}
