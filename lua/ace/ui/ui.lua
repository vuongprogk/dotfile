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
		opts = {
			options = {
				theme = function()
					local colors = {
						blue = "#268bd2",
						black = "#080808",
						white = "#c6c6c6",
						red = "#ff5189",
						violet = "#d183e8",
						grey = "#303030",
						base03 = "#002b36",
						green = "#859900",
						magenta = "#d33682",
					}
					return {
						normal = {
							a = { fg = colors.black, bg = colors.blue, gui = "bold" },
							b = { fg = colors.white, bg = colors.grey },
							c = { fg = colors.white },
						},

						insert = { a = { fg = colors.black, bg = colors.green, gui = "bold" } },
						visual = { a = { fg = colors.black, bg = colors.violet, gui = "bold" } },
						replace = { a = { fg = colors.black, bg = colors.red, gui = "bold" } },

						inactive = {
							a = { fg = colors.white, bg = colors.black, gui = "bold" },
							b = { fg = colors.white, bg = colors.black },
							c = { fg = colors.white },
						},
					}
				end,
				disabled_filetypes = { statusline = { "alpha" } },
				extensions = { "nvim-tree" },
			},
		},
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
