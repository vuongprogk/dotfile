return {
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{ "MunifTanjim/nui.nvim", lazy = true },
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		init = function()
			vim.g.lualine_laststatus = vim.o.laststatus
			if vim.fn.argc(-1) > 0 then
				-- set an empty statusline till lualine loads
				vim.o.statusline = " "
			else
				-- hide the statusline on the starter page
				vim.o.laststatus = 0
			end
		end,
		opts = function()
			local icons = Ace.config.icons
			vim.o.laststatus = vim.g.lualine_laststatus
			local opts = {
				options = {
					theme = "auto",
					globalstatus = vim.o.laststatus == 3,
					disabled_filetypes = { statusline = { "alpha", "dashboard" } },
					always_divide_middle = true,
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch" },

					lualine_c = {
						Ace.lualine.root_dir(),
						{
							"diagnostics",
							symbols = {
								error = icons.diagnostics.Error,
								warn = icons.diagnostics.Warn,
								info = icons.diagnostics.Info,
								hint = icons.diagnostics.Hint,
							},
							separator = "",
							padding = { left = 1, right = 0 },
						},
						{ "filetype", icon_only = true, padding = { left = 1, right = 0 } },
						{ Ace.lualine.pretty_path() },
					},
					lualine_x = {
            -- stylua: ignore
						{
							function()
								return require("noice").api.status.mode.get()
							end,
							cond = function()
								return package.loaded["noice"] and require("noice").api.status.mode.has()
							end,
							color = function()
								return Ace.ui.fg("Constant")
							end,
						},
            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = function() return Ace.ui.fg("Debug")  end,
            },
            -- stylua: ignore
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = function() return Ace.ui.fg("Special") end,
            },
						{
							"diff",
							symbols = {
								added = icons.git.added,
								modified = icons.git.modified,
								removed = icons.git.removed,
							},
						},
					},
					lualine_y = {
						{
							-- Lsp server name .
							function()
								local msg = " Active"
								local count = 0
								local clients = vim.lsp.get_clients()
								if next(clients) == nil then
									return msg
								end
								for _, client in ipairs(clients) do
									count = count + 1
								end
								return count .. msg
							end,
							icon = " LSP:",
						},
						{ "location", padding = { left = 1, right = 1 } },
					},
					lualine_z = {
						function()
							return " " .. os.date("%R")
						end,
					},
				},

				extensions = { "nvim-tree", "lazy" },
			}
			return opts
		end,
	},
	-- setup noice
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			messages = {
				view = "mini",
			},
			notify = {
				enabled = true,
				view = "notify",
			},
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				progress = {
					enabled = true,
				},
				message = {
					enabled = true,
					view = "mini",
					opts = {},
				},
				signature = {
					enabled = true,
					auto_open = {
						enabled = false,
						trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
						luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
						throttle = 50, -- Debounce lsp signature help request by 50ms
					},
				},
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "%d+L, %d+B" },
							{ find = "; after #%d+" },
							{ find = "; before #%d+" },
						},
					},
					view = "mini",
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				inc_rename = false,
				lsp_doc_border = true,
			},
			views = {
				mini = {
					win_options = {
						winblend = 0,
					},
				},
				hover = {
					size = {
						max_width = 80,
						width = "auto",
						height = "auto",
					},
				},
			},
			cmdline = {
				enabled = true,
				format = {
					cmdline = { title = "ACE" },
				},
			},
			throttle = 50,
		},
	},
	-- setup notify
	{
		"rcarriga/nvim-notify",
		opts = {
			stages = "fade_in_slide_out",
			timeout = 5000,
			fps = 60,
		},
		config = function()
			vim.keymap.set("n", "<leader>un", function()
				require("notify").dismiss({ silent = true, pending = true })
			end, { desc = "Dismiss All Notifications" })
		end,
	},
	-- incline
	{
		"b0o/incline.nvim",
		event = "BufReadPre",
		priority = 1200,
		opts = function()
			local colors = require("solarized-osaka.colors").setup()
			return {
				highlight = {
					groups = {
						InclineNormal = { guibg = colors.magenta500, guifg = colors.base04 },
						InclineNormalNC = { guifg = colors.violet500, guibg = colors.base03 },
					},
				},
				window = { margin = { vertical = 0, horizontal = 1 } },
				hide = {
					cursorline = true,
				},
				render = function(props)
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
					local modified = vim.bo[props.buf].modified
					if filename == "" then
						filename = "[No Name]"
					end
					local icon, color = require("nvim-web-devicons").get_icon_color(filename)
					return {
						{ icon, guifg = color },
						{ " " },
						modified and { "[+] ", gui = "bold" } or "",
						{ filename .. " ", gui = modified and "bold,italic" or "bold" },
					}
				end,
			}
		end,
	},
}
