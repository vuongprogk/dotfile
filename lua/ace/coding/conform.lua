local M = {}

---@param opts conform.setupOpts
function M.setup(_, opts)
	for _, key in ipairs({ "format_on_save", "format_after_save" }) do
		if opts[key] then
			local msg = "Don't set `opts.%s` for `conform.nvim`."
			Ace.warn(msg:format(key))
			opts[key] = nil
		end
	end
	require("conform").setup(opts)
end

return {
	"stevearc/conform.nvim",
	dependencies = { "mason.nvim" },
	lazy = true,
	cmd = "ConformInfo",
	init = function()
		Ace.on_very_lazy(function()
			Ace.format.register({
				name = "conform.nvim",
				priority = 100,
				primary = true,
				format = function(buf)
					require("conform").format({ bufnr = buf })
				end,
				sources = function(buf)
					local ret = require("conform").list_formatters(buf)
					---@param v conform.FormatterInfo
					return vim.tbl_map(function(v)
						return v.name
					end, ret)
				end,
			})
		end)
	end,
	keys = {
		{
			"<leader>cF",
			function()
				require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
			end,
			desc = "Formatting code mannually",
			mode = { "n", "v" },
			remap = true,
		},
	},
	opts = function()
		local plugin = require("lazy.core.config").plugins["conform.nvim"]
		if plugin.config ~= M.setup then
			Ace.warn("Don't set `plugin.config` for `conform.nvim`.", { title = "Vim" })
		end
		local opts = {
			default_format_opts = {
				timeout_ms = 3000,
				async = false, -- not recommended to change
				quiet = false, -- not recommended to change
				lsp_format = "fallback", -- not recommended to change
			},
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				java = {
					"clang_format",
				},
				cpp = {
					"clang_format",
				},
			},
			formatters = {
				injected = { options = { ignore_errors = true } },
				csharpier = {
					command = "dotnet-csharpier",
					args = { "--write-stdout" },
				},
			},
		}
		return opts
	end,
	config = M.setup,
}
