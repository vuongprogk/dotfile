return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local gitsigns = require("gitsigns")
    gitsigns.setup()
    vim.keymap.set("n", "<leader>tb", gitsigns.toggle_current_line_blame)
  end,
}
