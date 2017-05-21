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
-- Basic operations for the communication of minetest via http with a running 
-- abboza! monitor.
--
print("Initializing communication with abbozza! via http")

--
-- The default values
--
abz_host = "localhost"
abz_port = "54242"
abz_timeout = 5000
abz_path = "http://" .. abz_host .. ":" .. abz_port .. "/abbozza/serial?"

local response_buffer = ""

--
-- initialize the connection
--
abz_init = function(server,port,timeout)
   if server ~= nil then 
	   abz_host = server
	end
   if port ~= nil then 
	   abz_port = port
   end
   abz_timeout = timeout
   abz_path = "http://" .. abz_host .. ":" .. abz_port .. "/abbozza/serial?"
end

--
-- read the content of the response buffer
--
abz_read = function()
	local response = response_buffer
	response_buffer = ""
	return response
end

--
-- callback function, if content is received via an http request
--
local function abz_write_callback(result)
	response_buffer = response_buffer .. result.data
end

--
-- send a message as http request
--
abz_write = function(message)
   local myurl = abz_path .. "&msg=" .. message
   myurl = myurl:gsub(" ","%%20")
   local request = {
      url = myurl,
      timeout=30 
   }
   abz_http.fetch(request,abz_write_callback)	
end
