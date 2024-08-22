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
			{ desc = "Restore Session", remap = true },
		},
		{
			"<leader>wl",
			function()
				require("persistence").load({ last = true })
			end,
			{ desc = "Restore Session", remap = true },
		},
		{
			"<leader>ls",
			function()
				require("persistence").select()
			end,
			{ desc = "Select Session", remap = true },
		},
		{
			"<leader>wd",
			function()
				require("persistence").stop()
			end,
			{ desc = "Stop saving session", remap = true },
		},
		{
			"<leader>ws",
			function()
				require("persistence").save()
			end,
			{ desc = "Saving session", remap = true },
		},
	},
}
