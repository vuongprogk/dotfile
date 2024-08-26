return {
	"mistricky/codesnap.nvim",
	enabled = (not Ace.is_win()) and true or false,
	build = "make",
	cmd = { "CodeSnapSave", "CodeSnapSaveHighlight" },
	opts = {
		save_path = "/mnt/c/Users/vuong/Pictures/Codesnap",
		has_breadcrumbs = false,
		watermark = "Powered by ACE",
		bg_theme = "dusk",
	},
}
