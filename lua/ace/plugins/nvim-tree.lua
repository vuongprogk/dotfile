return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    {
      "<leader>ee",
      "<cmd>NvimTreeToggle<CR>",
      desc = "Toggle file explorer",
    },
    {
      "<leader>ef",
      "<cmd>NvimTreeFindFileToggle<CR>",
      desc = "Toggle file explorer on current file",
    },
    {
      "<leader>ec",
      "<cmd>NvimTreeCollapse<CR>",
      desc = "Collapse file explorer",
    },
    {
      "<leader>er",
      "<cmd>NvimTreeRefresh<CR>",
      desc = "Refresh file explorer",
    },
  },
  opts = {
    sync_root_with_cwd = true,
    view = {
      width = 40,
    },
    -- change folder arrow icons
    renderer = {
      indent_markers = {
        enable = true,
      },
      icons = {
        web_devicons = {
          file = {
            enable = true,
            color = true,
          },
          folder = {
            enable = false,
            color = true,
          },
        },
        git_placement = "after",
        show = {
          git = true,
        },
      },
    },
    actions = {
      open_file = {
        window_picker = {
          enable = false,
        },
      },
    },
    filters = {
      custom = { ".DS_Store" },
    },
    git = {
      ignore = false,
    },
  },
}
