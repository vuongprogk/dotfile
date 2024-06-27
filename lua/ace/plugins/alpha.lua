return {
  "goolord/alpha-nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      [[                        ]],
      [[                        ]],
      [[                        ]],
      [[                        ]],
      [[ █████╗  ██████╗███████╗]],
      [[██╔══██╗██╔════╝██╔════╝]],
      [[███████║██║     █████╗  ]],
      [[██╔══██║██║     ██╔══╝  ]],
      [[██║  ██║╚██████╗███████╗]],
      [[╚═╝  ╚═╝ ╚═════╝╚══════╝]],
      [[                        ]],
      [[                        ]],
      [[                        ]],
    }
    dashboard.section.buttons.val = {
      dashboard.button("e", "  > New File", "<cmd>ene<CR>"),
      dashboard.button("SPC ee", "  > Toggle file explorer",
        function()
          require("nvim-tree.api").tree.toggle()
        end
      ),
      dashboard.button("SPC ff", "󰱼  > Find File",
        function()
          require("telescope.builtin").find_files()
        end),
      dashboard.button("SPC fs", "  > Find Word",
        function()
          require("telescope.builtin").live_grep()
        end),
      dashboard.button("SPC wr", "󰁯  > Restore Session For Current Directory",
        function()
          require('auto-session').RestoreSession()
        end
      ),
      dashboard.button("q", "  > Quit NVIM", "<cmd>qa<CR>"),
    }
    alpha.setup(dashboard.opts)

    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
  end,
}
