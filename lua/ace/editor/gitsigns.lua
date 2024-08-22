return {
	"lewis6991/gitsigns.nvim",
	cmd = { "Gitsigns" },
	keys = {
		{
			"<leader>tb",
			"<cmd>Gitsigns toggle_current_line_blame<CR>",
			{ desc = "Toggle line blame", mode = { "n", "v" }, remap = true },
		},
	},
	opts = {},
}
