return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		event = "VeryLazy",
		opts = {
			open_mapping = [[<c-/>]],
			direction = "float",
			shell = Ace.is_win() and "powershell /nologo" or "bash",
			float_opts = {
				border = "curved",
				winblend = 0,
				title_pos = "center",
			},
		},
	},
}
