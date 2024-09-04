return {
	"lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPost", "BufWritePost", "BufNewFile" },
	opts = function()
		return {
			indent = {
				char = "│",
				tab_char = "│",
			},
			scope = { show_start = false, show_end = false, enabled = false },
			exclude = {
				filetypes = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
				},
			},
		}
	end,
	main = "ibl",
}
