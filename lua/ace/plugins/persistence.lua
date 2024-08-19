return {
	"folke/persistence.nvim",
	event = "BufReadPre",
	opts = {},
	keys = {
		{
			"<leader>wr",
			function()
				require("persistence").load()
			end,
			desc = "Restore Session",
		},
		{
			"<leader>wl",
			function()
				require("persistence").load({ last = true })
			end,
			desc = "Restore Session",
		},
		{
			"<leader>ls",
			function()
				require("persistence").select()
			end,
			desc = "Select Session",
		},
		{
			"<leader>wd",
			function()
				require("persistence").stop()
			end,
			desc = "Stop saving session",
		},
		{
			"<leader>ws",
			function()
				require("persistence").save()
			end,
			desc = "Saving session",
		},
	},
}
