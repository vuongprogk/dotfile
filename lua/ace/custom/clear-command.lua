local function clearShada()
	local shada_path = vim.fn.expand(vim.fn.stdpath("data") .. "/shada")
	local files = vim.fn.glob(shada_path .. "/*", false, true)
	local all_success = 0
	for _, file in ipairs(files) do
		local file_name = vim.fn.fnamemodify(file, ":t")
		if file_name == "main.shada" then
			-- skip your main.shada file
			goto continue
		end
		local success = vim.fn.delete(file)
		all_success = all_success + success
		if success ~= 0 then
			vim.notify("Couldn't delete file '" .. file_name .. "'", vim.log.levels.WARN)
		end
		::continue::
	end
	if all_success == 0 then
		vim.print("Successfully deleted all temporary shada files", vim.log.levels.INFO)
	end
end
local function clearState(args)
	local state_path = vim.fn.expand(vim.fn.stdpath("state") .. "/")
	local files = vim.fn.glob(state_path .. args, false, true)
	local success = 0
	for _, file in ipairs(files) do
		local file_name = vim.fn.fnamemodify(file, ":t")
		success = vim.fn.delete(file)
		if success ~= 0 then
			vim.notify("Couldn't delete file '" .. file_name .. "'", vim.log.levels.WARN)
		end
	end
	if success == 0 then
		vim.notify("Deleting Successfully", vim.log.levels.INFO)
	end
end
vim.api.nvim_create_user_command("ClearShada", clearShada, { desc = "Clears all the .tmp shada files" })
vim.api.nvim_create_user_command("DeleteStateFile", function(opts)
	clearState(opts.args)
end, { nargs = 1, desc = "Clear state file" })

-- NOTE: auto load on external change
vim.api.nvim_create_augroup("AutoDetectFileChange", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	pattern = { "*" },
	group = "AutoDetectFileChange",
	callback = function(param)
		local name = vim.api.nvim_buf_get_name(param.buf)
		local is_modifiable = vim.api.nvim_get_option_value("modifiable", { buf = param.buf })
		if name ~= "" and is_modifiable then
			vim.cmd(":checktime")
		end
	end,
})
vim.api.nvim_create_autocmd("FileChangedShellPost", {
	pattern = "*",
	group = "AutoDetectFileChange",
	callback = function()
		vim.notify("File changed on disk. Buffer reloaded.", vim.log.INFO)
	end,
})
