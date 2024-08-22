return {
  "mistricky/codesnap.nvim",
  enabled = function()
    if require("ace.custom.os").getName() == 'Windows' then
      return false
    end
    return true
  end,
  build = "make",
  cmd = { "CodeSnapSave", "CodeSnapSaveHighlight" },
  opts = {
    save_path = "/mnt/c/Users/vuong/Pictures/Codesnap",
    has_breadcrumbs = false,
    watermark = "Powered by ACE",
    bg_theme = "dusk",
  },
}
