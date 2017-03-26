-- initialize connection to the arduino

local abz_timer = 0
local abz_buffer = ""


-- the queue of messages
messages = Queue:new()

-- initalize the default port
abz_init("localhost","54242",5000)


-- the function for handling the messages
abz_globalstep = function()
   local message = messages:dequeue()
   if message ~= nil then
   	-- print("sending : " .. message)
   	abz_write(message)
   end
   
	-- read input   
   -- print ("reading form device ...")
   -- local response = abbozza_in:read("*a")
   local response = abz_read()
   abz_buffer = abz_buffer .. response
   -- print ("... done")
   -- print("buffer: " .. abz_buffer)
    
    -- parse abz_buffer for messages
    repeat
    	local s, e = abz_buffer:find("%[%[([^%[%]]*)%]%]")
    	if s ~= nil then
    	   abz_buffer = abz_buffer:sub(s)
    		message = abz_buffer:sub(s,e)
		   print("message: " .. message)
	   	local x,y,z,msg = message:match("_(-?%d+)_(-?%d+)_(-?%d+)%s+([^%]]*)")
   		local pos = { x = x, y = y, z = z }
   		local meta = minetest.get_meta(pos)
   		meta:set_string("msg",msg)
    		-- print("pos: " .. x .. "," .. y .. "," .. z)
    		-- print("msg: " .. msg)
	    	abz_buffer = abz_buffer:sub(e+1)
         -- print("buffer: " .. abz_buffer)	      
    	end 
    until s == nil

end

abz_send = function(pos,message)
    local id = "_" .. pos.x .. "_" .. pos.y .. "_" .. pos.z
    messages:enqueue( "[[" .. id .. " ".. message .. "]]" )
end


abz_receive = function()
    local response = nil
    if abbozza_in ~= nil then
        response = abbozza_in:read("*a")
    end
    return response
end


-- command for setting the abbozza device
minetest.register_chatcommand("abz_init", {
	params = "<text>",
	description = "Set the abbozza device",
	func = function(name, device)
				abz_init(device)
            return true, "abbozza device set to " .. device
	end
})


-- command for sending a text to the abbozza device
minetest.register_chatcommand("abz", {
	params = "<text>",
	description = "Send a text to the abbozza device",
	func = function(name, message)
			   messages:enqueue(message)
            return true, message .. " sent to abbozza device"
	end
})


-- command for sending a text to the abbozza device and wait for response
minetest.register_chatcommand("abz_query", {
	params = "<text>",
	description = "Send a text to the abbozza device and wait for response",
	func = function(name, message)
            local response
            messages:enqueue(message)
            response = abz_receive()
            if response ~= nil then
                return true, response
            else
                return false
            end
	end
})


-- register the message handler
minetest.register_globalstep(
	function(dtime)
		abz_timer = abz_timer + dtime
		if abz_timer >= 0.5 then
			abz_globalstep()
			abz_timer = 0
		end
	end
)