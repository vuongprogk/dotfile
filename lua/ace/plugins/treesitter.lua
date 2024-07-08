return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		require("nvim-treesitter.configs").setup({
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
			},
			sync_install = false,
			auto_install = true,
			highlight = {
				enable = true,
				disable = { "c_sharp" },
			},
			indent = true,
			ignore_install = {},
		})
	end,
}
