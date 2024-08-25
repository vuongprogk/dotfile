return {
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{ "MunifTanjim/nui.nvim", lazy = true },
	--bufferline
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		dependencies = "nvim-tree/nvim-web-devicons",
		keys = {
			{ "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
			{ "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
			{ "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
			{ "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
			{ "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
			{ "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
		},
		opts = {
			options = {
				close_command = function(buf)
					buf = buf or 0
					buf = buf == 0 and vim.api.nvim_get_current_buf() or buf

					if vim.bo.modified then
						local choice =
							vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
						if choice == 0 or choice == 3 then -- 0 for <Esc>/<C-c> and 3 for Cancel
							return
						end
						if choice == 1 then -- Yes
							vim.cmd.write()
						end
					end

					for _, win in ipairs(vim.fn.win_findbuf(buf)) do
						vim.api.nvim_win_call(win, function()
							if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then
								return
							end
							-- Try using alternate buffer
							local alt = vim.fn.bufnr("#")
							if alt ~= buf and vim.fn.buflisted(alt) == 1 then
								vim.api.nvim_win_set_buf(win, alt)
								return
							end

							-- Try using previous buffer
							local has_previous = pcall(vim.cmd, "bprevious")
							if has_previous and buf ~= vim.api.nvim_win_get_buf(win) then
								return
							end

							-- Create new listed buffer
							local new_buf = vim.api.nvim_create_buf(true, false)
							vim.api.nvim_win_set_buf(win, new_buf)
						end)
					end
					if vim.api.nvim_buf_is_valid(buf) then
						pcall(vim.cmd, "bdelete! " .. buf)
					end
				end,
				right_mouse_command = function(buf)
					buf = buf or 0
					buf = buf == 0 and vim.api.nvim_get_current_buf() or buf

					if vim.bo.modified then
						local choice =
							vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
						if choice == 0 or choice == 3 then -- 0 for <Esc>/<C-c> and 3 for Cancel
							return
						end
						if choice == 1 then -- Yes
							vim.cmd.write()
						end
					end

					for _, win in ipairs(vim.fn.win_findbuf(buf)) do
						vim.api.nvim_win_call(win, function()
							if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then
								return
							end
							-- Try using alternate buffer
							local alt = vim.fn.bufnr("#")
							if alt ~= buf and vim.fn.buflisted(alt) == 1 then
								vim.api.nvim_win_set_buf(win, alt)
								return
							end

							-- Try using previous buffer
							local has_previous = pcall(vim.cmd, "bprevious")
							if has_previous and buf ~= vim.api.nvim_win_get_buf(win) then
								return
							end

							-- Create new listed buffer
							local new_buf = vim.api.nvim_create_buf(true, false)
							vim.api.nvim_win_set_buf(win, new_buf)
						end)
					end
					if vim.api.nvim_buf_is_valid(buf) then
						pcall(vim.cmd, "bdelete! " .. buf)
					end
				end,
				diagnostics = "nvim_lsp",
				always_show_bufferline = false,
				diagnostics_indicator = function(_, _, diag)
					local icons = {
						Error = " ",
						Warn = " ",
						Hint = " ",
						Info = " ",
					}
					local ret = (diag.error and icons.Error .. diag.error .. " " or "")
						.. (diag.warning and icons.Warn .. diag.warning or "")
					return vim.trim(ret)
				end,
			},
		},
		config = function(_, opts)
			require("bufferline").setup(opts)
			-- Fix bufferline when restoring a session
			vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
				callback = function()
					vim.schedule(function()
						pcall(nvim_bufferline)
					end)
				end,
			})
		end,
	},
	-- statusline
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = "nvim-tree/nvim-web-devicons",
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
			local function color_picker(name, bg)
				local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name, link = false })
					or vim.api.nvim_get_hl_by_name(name, true)
				local color = nil
				if hl then
					if bg then
						color = hl.bg or hl.background
					else
						color = hl.fg or hl.foreground
					end
				end
				return color and string.format("#%06x", color) or nil
			end
			local function fg(name)
				local color = color_picker(name)
				return color and { fg = color } or nil
			end
			local opts = {
				options = {
					theme = "tokyonight",
					globalstatus = vim.o.laststatus == 3,
					disabled_filetypes = { statusline = { "alpha", "dashboard" } },
					always_divide_middle = true,
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = {
						{ "branch" },
					},

					lualine_c = {
						{ "fileformat", separator = "|" },
						{ "filetype", icon_only = true, padding = { left = 1, right = 0 } },
						{ "filename", path = 0 },
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
								return fg("Constant")
							end,
						},
            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = function() return fg("Debug") end,
            },
            -- stylua: ignore
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = function() return fg("Special") end,
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
								-- local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
								local clients = vim.lsp.get_clients()
								if next(clients) == nil then
									return msg
								end
								for _, client in ipairs(clients) do
									count = count + 1
									-- local filetypes = client.config.filetypes
									-- if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
									-- 	return client.name
									-- end
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

				extensions = { "nvim-tree" },
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
}
