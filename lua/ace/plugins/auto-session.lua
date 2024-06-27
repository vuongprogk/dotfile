return {
  "rmagatti/auto-session",
  keys = {
    { "<leader>wr",
      function()
        require('auto-session').RestoreSession()
      end,
      { desc = "Restore session for cwd" }
    },
    { "<leader>ws",
      function()
        require('auto-session').SaveSession()
      end,
      { desc = "Save session for auto session root dir" }
    },
    { "<leader>wd", function()
      require('auto-session').DeleteSession()
    end,
      { desc = "Delete session" }
    },
    { "<Leader>ls", function()
      require("auto-session.session-lens").search_session()
    end,
      { desc = "Search session" }
    },
  },
  opts = {
    auto_restore_enabled = false,
    auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
    session_lens = {
      buftypes_to_ignore = {},
      load_on_setup = true,
      theme_conf = { border = true },
      previewer = false,
    },

  }
  -- config = function()
  --   local auto_session = require("auto-session")
  --
  --   auto_session.setup({
  --   })
  -- end,
}
