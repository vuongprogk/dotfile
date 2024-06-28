local os = {}

function os.getName()
	local osname
	if jit then
		return jit.os
	end
	local fh, err = assert(io.popen("uname -o 2>/dev/null", "r"))
	if fh then
		osname = fh:read()
	end

	return osname or "Windows"
end
return os
