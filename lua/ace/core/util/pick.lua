---@class Ace.util.pick
---@overload fun(command:string, opts?:Ace.util.pick.Opts): fun()
local M = setmetatable({}, {
	__call = function(m, ...)
		return m.wrap(...)
	end,
})

---@class Ace.util.pick.Opts: table<string, any>
---@field root? boolean
---@field cwd? string
---@field buf? number
---@field show_untracked? boolean

---@class Picker
---@field name string
---@field open fun(command:string, opts?:Ace.util.pick.Opts)
---@field commands table<string, string>

---@type Picker?
M.picker = nil

---@param picker Picker
function M.register(picker)
	-- so allow to get the full spec
	if vim.v.vim_did_enter == 1 then
		return true
	end

	if M.picker and M.picker.name ~= M.want() then
		M.picker = nil
	end

	if M.picker and M.picker.name ~= picker.name then
		Ace.warn(
			"`pick`: picker already set to `" .. M.picker.name .. "`,\nignoring new picker `" .. picker.name .. "`"
		)
		return false
	end
	M.picker = picker
	return true
end

function M.want()
	vim.g.lazyvim_picker = vim.g.lazyvim_picker or "auto"
	if vim.g.lazyvim_picker == "auto" then
		return Ace.has_extra("editor.fzf") and "fzf" or "telescope"
	end
	return vim.g.lazyvim_picker
end

---@param command? string
---@param opts? Ace.util.pick.Opts
function M.open(command, opts)
	if not M.picker then
		return Ace.error("Pick: picker not set")
	end

	command = command ~= "auto" and command or "files"
	opts = opts or {}

	opts = vim.deepcopy(opts)

	if type(opts.cwd) == "boolean" then
		Ace.warn("Pick: opts.cwd should be a string or nil")
		opts.cwd = nil
	end

	if not opts.cwd and opts.root ~= false then
		opts.cwd = Ace.root({ buf = opts.buf })
	end

	command = M.picker.commands[command] or command
	M.picker.open(command, opts)
end

---@param command? string
---@param opts? Ace.util.pick.Opts
function M.wrap(command, opts)
	opts = opts or {}
	return function()
		Ace.pick.open(command, vim.deepcopy(opts))
	end
end

function M.config_files()
	return M.wrap("files", { cwd = vim.fn.stdpath("config") })
end

return M