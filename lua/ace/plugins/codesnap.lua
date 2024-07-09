return {
	"mistricky/codesnap.nvim",
	build = "make",
	cmd = { "CodeSnapSave" },
	keys = {
		{ "<leader>cs", "<cmd>CodeSnapSave<cr>", mode = "x", desc = "Save selected code snapshot in ~/Pictures" },
	},
	opts = {
		save_path = "/mnt/c/Users/vuong/Pictures/Codesnap",
		has_breadcrumbs = true,
		watermark = "Powered by ACE",
		bg_theme = "dusk",
	},
}
