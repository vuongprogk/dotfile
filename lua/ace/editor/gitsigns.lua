return {
	"lewis6991/gitsigns.nvim",
	cmd = { "Gitsigns" },
	keys = {
		{
			"<leader>tb",
			"<cmd>Gitsigns toggle_current_line_blame<CR>",
			desc = "Toggle line blame",
			mode = { "n", "v" },
			remap = true,
		},
	},
	opts = {
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "▎" },
			untracked = { text = "▎" },
		},
		signs_staged = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "▎" },
		},
	},
}
