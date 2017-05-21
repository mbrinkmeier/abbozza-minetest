--
-- abbozza! minetest plugin
--
-- Copyright 2017 Michael Brinkmeier ( michael.brinkmeier@uni-osnabrueck.de )
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--   http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
--
--
-- Basic operations for the communication of minetest withvia http with a running 
-- abboza! monitor.
--

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