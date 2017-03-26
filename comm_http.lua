print("Initializing serial communication via http")

abz_host = "localhost"
abz_port = "54242"
abz_timeout = 5000
abz_path = "http://" .. abz_host .. ":" .. abz_port .. "/abbozza/serial?timeout=" .. abz_timeout

-- abz_http = minetest.request_http_api()
-- print(abz_http)

local response_buffer = ""

-- initialize port
abz_init = function(server,port,timeout)
   if server ~= nil then 
	   abz_host = server
	end
   if port ~= nil then 
	   abz_port = port
	end
	abz_timeout = timeout
	abz_path = "http://" .. abz_host .. ":" .. abz_port .. "/abbozza/serial?"
	if timeout ~= 0 then
	   abz_path = abz_path .. "timeout=" .. abz_timeout .. "&"
	end
end


abz_read = function()
   -- local receive_file  = minetest.get_modpath("abbozza") .. "/receive.ps1"
   -- local receive_cmd = "powershell -ExecutionPolicy bypass -File " .. receive_file .. " -com " .. abz_port_name   
	-- print("receive_cmd : " .. receive_cmd)
	-- local f = assert ( io.popen(receive_cmd,'r'))
	-- local response = assert ( f:read('*a') )
	-- f:close()
	-- print (response)
	-- return response
	local response = response_buffer
	response_buffer = ""
	return response
end

local function abz_write_callback(result)
	response_buffer = response_buffer .. result.data
	-- print(response_buffer)
end


abz_write = function(message)
   local myurl = abz_path .. "msg=" .. message
   myurl = myurl:gsub(" ","%%20")
   local request = {
      url = myurl 
   }
	abz_http.fetch(request,abz_write_callback)	
end




