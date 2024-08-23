return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
	init = function(plugin)
		require("lazy.core.loader").add_to_rtp(plugin)
		require("nvim-treesitter.query_predicates")
	end,
	opts = {
		ensure_installed = {
			"c",
			"vim",
			"cpp",
			"python",
			"css",
			"html",
			"lua",
			"markdown_inline",
			"latex",
			"regex",
			"markdown",
			"json",
			"bash",
			"javascript",
		},
		sync_install = true,
		auto_install = true,
		highlight = {
			enable = true,
			-- disable = { "c_sharp" },
		},
		indent = { enable = true },
		ignore_install = {},
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)
	end,
}
