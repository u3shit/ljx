
if _VERSION == "Lua 5.1" then
	local rg = assert(rawget)
	local proxy_key = rg(_G, "__GC_PROXY") or "__gc_proxy"
	local rs = assert(rawset)
	local gmt = assert(debug.getmetatable)
	local smt = assert(setmetatable)
	local np = assert(newproxy)

	return function(t, mt)
		if rg(mt, "__gc") and not rg(t,"__gc_proxy") then
			local p = np(true)
			rs(t, proxy_key, p)
			gmt(p).__gc = function()
				rs(t, proxy_key, nil)
				local nmt = gmt(t)
				if not nmt then return end
				local fin = rg(nmt, "__gc")
				if fin then return fin(t) end
			end
		end
		return smt(t,mt)
	end
end

return setmetatable
