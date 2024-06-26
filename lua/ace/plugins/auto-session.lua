return {
  "rmagatti/auto-session",
  keys = {
    {
      "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" }
    },
    {
      "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" }
    },
    {
      "<leader>wd", "<cmd>SessionDelete<CR>", { desc = "Delete session" }
    },
    {
      "<Leader>ls",function ()
        require("auto-session.session-lens").search_session()
      end , { desc = "Search session" }

    }
  },
  config = function()
    local auto_session = require("auto-session")

    auto_session.setup({
      auto_restore_enabled = false,
      auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
    })
  end,
}
