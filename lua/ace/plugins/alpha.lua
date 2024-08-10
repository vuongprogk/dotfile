return {
	"goolord/alpha-nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"nvim-telescope/telescope.nvim",
	},

	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")
		local builtin = require("telescope.builtin")

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
			dashboard.button("󱁐 ee", "  > Toggle file explorer", "<cmd>NvimTreeToggle<CR>"),
			dashboard.button("󱁐 ff", "󰱼  > Find File", builtin.find_files),
			dashboard.button("󱁐 fg", "  > Find Word", builtin.live_grep),
			dashboard.button("󱁐 wr", "󰁯  > Restore Session For Current Directory", "<cmd>SessionRestore<CR>"),
			dashboard.button("q", "  > Quit NVIM", "<cmd>qa<CR>"),
		}
		alpha.setup(dashboard.opts)

		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
