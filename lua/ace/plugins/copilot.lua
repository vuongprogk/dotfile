return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		build = ":Copilot auth",
		opts = {
			suggestion = { enabled = false },
			panel = { enabled = false },
			filetypes = {
				markdown = true,
				help = true,
			},
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		optional = true,
		event = "VeryLazy",
		opts = function(_, opts)
			local colors = {
				[""] = Ace.ui.fg("Special"),
				["Normal"] = Ace.ui.fg("Special"),
				["Warning"] = Ace.ui.fg("DiagnosticError"),
				["InProgress"] = Ace.ui.fg("DiagnosticWarn"),
			}
			table.insert(opts.sections.lualine_y, 1, {
				function()
					local icon = Ace.config.icons.kinds.Copilot
					local status = require("copilot.api").status.data
					return icon .. (status.message or "")
				end,
				cond = function()
					if not package.loaded["copilot"] then
						return
					end
					local ok, clients = pcall(Ace.lsp.get_clients, { name = "copilot", bufnr = 0 })
					if not ok then
						return false
					end
					return ok and #clients > 0
				end,
				color = function()
					if not package.loaded["copilot"] then
						return
					end
					local status = require("copilot.api").status.data
					return colors[status.status] or colors[""]
				end,
			})
		end,
	},
	{
		"nvim-cmp",
		dependencies = {
			{
				"zbirenbaum/copilot-cmp",
				dependencies = "copilot.lua",
				opts = {},
				config = function(_, opts)
					local copilot_cmp = require("copilot_cmp")
					copilot_cmp.setup(opts)
					-- attach cmp source whenever copilot attaches
					-- fixes lazy-loading issues with the copilot cmp source
					Ace.lsp.on_attach(function(client)
						copilot_cmp._on_insert_enter({})
					end, "copilot")
				end,
			},
		},
		opts = function(_, opts)
			table.insert(opts.sources, {
				name = "copilot",
				priority = 750,
			})
		end,
	},
}
