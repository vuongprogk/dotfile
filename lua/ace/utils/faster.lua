return {
	"pteroctopus/faster.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		behaviours = {
			bigfile = {
				on = true,
				features_disabled = {
					"lsp",
					"treesitter",
					"indent_blankline",
					"syntax",
				},
				filesize = vim.g.bigfile,
				pattern = "*",
				extra_patterns = {
					{ filesize = 0.1, pattern = "*.json" },
				},
			},
		},
		features = {
			filetype = {
				on = true,
				defer = false,
			},
			indent_blankline = {
				on = true,
				defer = false,
			},
			lsp = {
				on = true,
				defer = false,
			},
			lualine = {
				on = true,
				defer = false,
			},
			syntax = {
				on = true,
				defer = false,
			},
			treesitter = {
				on = true,
				defer = false,
			},
			vimopts = {
				on = true,
				defer = false,
			},
		},
	},
}
