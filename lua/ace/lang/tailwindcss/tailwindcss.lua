return {
	-- tailwind-tools.lua
	{
		"luckasRanarison/tailwind-tools.nvim",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		name = "tailwind-tools",
		build = ":UpdateRemotePlugins",
		opts = {}, -- your configuration
	},
	{ "roobert/tailwindcss-colorizer-cmp.nvim", opts = {} },
	{
		"hrsh7th/nvim-cmp",
		opts = function(_, opts)
			local format_kinds = opts.formatting.format
			opts.formatting.format = function(entry, item)
				format_kinds(entry, item) -- add icons
				return require("tailwindcss-colorizer-cmp").formatter(entry, item)
			end
		end,
	},
}
