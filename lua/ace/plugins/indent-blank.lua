return {
  "lukas-reineke/indent-blankline.nvim",
  branch = "current-indent",
  event = "BufReadPre",
  config = function()
    local highlight = {
      "RainbowRed",
      "RainbowYellow",
      "RainbowBlue",
      "RainbowOrange",
      "RainbowGreen",
      "RainbowViolet",
      "RainbowCyan",
    }

    local hooks = require("ibl.hooks")
    -- create the highlight groups in the highlight setup hook, so they are reset
    -- every time the colorscheme changes
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#845EC2" })
      vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#D65DB1" })
      vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#FF6F91" })
      vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#FF9671" })
      vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#FFC75F" })
      vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#F9F871" })
      vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#B39CD0" })
    end)
    require("ibl").setup({
      indent = {
        highlight = highlight,
        char = "│",
        smart_indent_cap = true,
      },
      whitespace = {
        highlight = highlight,
        remove_blankline_trail = false,
      },
      scope = {
        enabled = false,
      },
      exclude = {
        filetypes = { "help", "startify", "dashboard", "packer", "neogitstatus", "NvimTree", "Trouble" },
      },
    })
  end,
}
