
local abbozza_out = nil
local abz_os = "unix"
local abz_port_name = "/dev/ttyACM0"

print("Initializing serial communication for unix")

-- initalize port
abz_init = function(port_name)
   if port_name == nil then port_name = abz_port_name end
   if abbozza_out ~= nil then abbozza_out:close() end
	abbozza_out = io.open(abz_port_name,"w")
	os.execute("stty -F " .. abz_port_name .. " time 0 min 0")
   abz_port_name = port_name
	if abbozza_out ~= nil then print ( "... output initialized") end
end


abz_read = function()
   local response = ""
   if abbozza_out ~= nil then
      -- print("reading from " .. abz_port_name)
	   local f = assert(io.popen("cat " .. abz_port_name, 'r'))
	   f:flush()
  	   response = assert(f:read('*a'))
  	   -- print(response)
      f:close()
   end
   if response == nil then response = "" end
   return response
end


abz_write = function(message)
   if abbozza_out ~= nil then
   	abbozza_out:write(message)
   	abbozza_out:flush()
   end
end