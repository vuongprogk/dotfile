return {
	{
		"echasnovski/mini.diff",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		version = "*",
		keys = {
			{
				"<leader>go",
				function()
					require("mini.diff").toggle_overlay(0)
				end,
				mode = { "n", "v" },
				desc = "Toggle mini.diff overlay",
				remap = true,
			},
		},
		opts = {
			view = {
				style = "sign",
				signs = {
					add = "▎",
					change = "▎",
					delete = "",
				},
			},
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		opts = function(_, opts)
			local x = opts.sections.lualine_x
			for _, comp in ipairs(x) do
				if comp[1] == "diff" then
					comp.source = function()
						local summary = vim.b.minidiff_summary
						return summary
							and {
								added = summary.add,
								modified = summary.change,
								removed = summary.delete,
							}
					end
					break
				end
			end
		end,
	},
}
