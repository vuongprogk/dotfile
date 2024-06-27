return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    {
      "<leader>tb",
      function()
        require('gitsigns').toggle_current_line_blame()
      end,
      { desc = "Toggle line blame" }
    }
  },
  config = function()
    require('gitsigns').setup()
  end
}
