return {
	"mistricky/codesnap.nvim",
	build = "make",
	cmd = { "CodeSnapSave", "CodeSnapSaveHighlight" },
	opts = {
		save_path = "/mnt/c/Users/vuong/Pictures/Codesnap",
		has_breadcrumbs = false,
		watermark = "Powered by ACE",
		bg_theme = "dusk",
	},
}
