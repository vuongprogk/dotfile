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
			Ace.warn("Couldn't delete file '" .. file_name .. "'")
		end
		::continue::
	end
	if all_success == 0 then
		Ace.info("Successfully deleted all temporary shada files")
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
			Ace.warn("Couldn't delete file '" .. file_name .. "'")
		end
	end
	if success == 0 then
		Ace.info("Deleting Successfully")
	end
end
vim.api.nvim_create_user_command("ClearShada", clearShada, { desc = "Clears all the .tmp shada files" })
vim.api.nvim_create_user_command("DeleteStateFile", function(opts)
	clearState(opts.args)
end, { nargs = 1, desc = "Clear state file" })
