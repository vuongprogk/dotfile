return {
	{
		"echasnovski/mini.indentscope",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		version = "*",
		opts = {
			symbol = "│",
			options = { try_as_border = true },
		},
		config = function(_, opts)
			require("mini.indentscope").setup(opts)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"NvimTree",
					"Trouble",
					"trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
					"FTerm",
				},
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
		end,
	},
}
