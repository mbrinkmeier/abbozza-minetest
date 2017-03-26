print("Initializing serial communication for windows")

abz_os = "win"
abz_cmd = "type"
abz_port_name = "COM1"

local send_script
local receive_script

local response_buffer = ""

-- initialize port
abz_init = function(port_name)
   if port_name ~= nil then 
	   abz_port_name = port_name
	end
end


abz_read = function()
   local receive_file  = minetest.get_modpath("abbozza") .. "/receive.ps1"
   local receive_cmd = "powershell -ExecutionPolicy bypass -File " .. receive_file .. " -com " .. abz_port_name   
	print("receive_cmd : " .. receive_cmd)
	local f = assert ( io.popen(receive_cmd,'r'))
	local response = assert ( f:read('*a') )
	f:close()
	print (response)
	return response
end


abz_write = function(message)
   local send_file = minetest.get_modpath("abbozza") .. "/send.ps1"
   local send_cmd = "powershell -ExecutionPolicy bypass -File " .. send_file .. " -com " .. abz_port_name .. " -msg \"" .. message .. "\""   
   print("send_cmd : " .. send_cmd)
	os.execute(send_cmd)
end



