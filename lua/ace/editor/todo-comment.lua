return {
	"folke/todo-comments.nvim",
	cmd = { "TodoTelescope" },
	event = { "BufReadPost", "BufWritePost", "BufNewFile" },
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{
			"]t",
			function()
				require("todo-comments").jump_next()
			end,
			desc = "Next Todo Comment",
		},
		{
			"[t",
			function()
				require("todo-comments").jump_prev()
			end,
			desc = "Previous Todo Comment",
		},
	},
	opts = {},
}
