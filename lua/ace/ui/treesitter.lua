return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufWritePost", "BufNewFile" },
	build = ":TSUpdate",
	lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
	init = function(plugin)
		require("lazy.core.loader").add_to_rtp(plugin)
		require("nvim-treesitter.query_predicates")
	end,
	cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
	opts_extend = { "ensure_installed" },
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
		if type(opts.ensure_installed) == "table" then
			opts.ensure_installed = Ace.dedup(opts.ensure_installed)
		end
		require("nvim-treesitter.configs").setup(opts)
	end,
}
