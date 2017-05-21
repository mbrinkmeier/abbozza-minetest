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
-- The digital I/O-blocks for the abbozza! minetest mod
--

digital_punched = function(pos, node, puncher, pointed_thing, typ)  
   local meta = minetest.get_meta(pos)
   local pin = meta:get_string("pin")
   if ( pin == "") then
      pin = "0"
      meta:set_string("pin",pin)
   end
   local host = meta:get_string("horst")
   if ( host == "") then
      host = abz_host
      meta:set_string("host",host)
   end
   local port = meta:get_string("port")
   if ( port == "") then
      port = abz_port
      meta:set_string("port",port)
   end
   meta:set_string("formspec",
      "size[5,6]" ..
      "label[1,0;Digital " .. typ .. " Block]" ..
      "field[1,2;4,1;pin;Digital pin;" .. pin .. "]" ..
      "field[1,3;4,1;host;Host;" .. host .. "]" ..
      "field[1,4;4,1;port;Port;" .. port .. "]" ..
      "button_exit[1,5;3,1;save;Save!]"
   )
end


digital_receive_fields = function(pos, formname, fields, sender, typ)
   local meta = minetest.get_meta(pos)
   meta:set_string("pin",fields.pin)
   meta:set_string("host",fields.host)
   meta:set_string("port",fields.port)
   meta:set_string("formspec",
      "size[5,6]" ..
      "label[1,0;Digital " .. typ .. " Block]" ..
      "field[1,2;4,1;pin;Digital pin;" .. meta:get_string("pin") .. "]" ..
      "field[1,3;4,1;host;Host;" .. meta:get_string("host") .. "]" ..
      "field[1,4;4,1;port;Port;" .. meta:get_string("port") .. "]" ..
      "button_exit[1,5;3,1;save;Save]"
   )
end



minetest.register_node("abbozza:digital_off", {
   description = "abbozza! digital output",
   tiles = {"digital_out_off.png"},
   groups = {choppy=1},
   mesecons = {effector = {
      action_on = function (pos, node)
         local meta = minetest.get_meta(pos)
         local pin = meta:get_string("pin")
         local host = meta:get_string("host")
         local port = meta:get_string("port")
         if pin ~= "" then
            abz_send_http(pos,host,port,"dset " .. pin .. " 1",0)
            minetest.swap_node(pos, {name = "abbozza:digital_on", param2 = node.param2} )
         end
      end
   }},
   on_receive_fields = function(pos, formname, fields, player)
      digital_receive_fields(pos, formname, fields, player, "Output")
   end,
   after_place_node = function(pos, node, puncher, pointed_thing)
      digital_punched(pos, node, puncher, pointed_thing, "Output")
   end
})



minetest.register_node("abbozza:digital_on", {
    description = "",
    tiles = {"digital_out_on.png"},
    groups = {choppy=1},
    light_source = 5,
    mesecons = {effector = {
            action_off = function (pos, node)
               local meta = minetest.get_meta(pos)
               local pin = meta:get_string("pin")
               local host = meta:get_string("host")
               local port = meta:get_string("port")
               if pin ~= "" then
                  abz_send_http(pos,host,port,"dset " .. pin .. " 0",0)
		  minetest.swap_node(pos, {name = "abbozza:digital_off", param2 = node.param2})
		         end
            end
	}},
   after_place_node = function(pos, node, puncher, pointed_thing)
   	digital_punched(pos, node, puncher, pointed_thing, "Output")
	end,         
 	on_receive_fields = function(pos, formname, fields, player)
 	 	digital_receive_fields(pos, formname, fields, player, "Output")
   end
})


minetest.register_node("abbozza:digital_in_off", {
	description = "abbozza! digital input",
	tiles = {"digital_in_off.png"},
	groups = {choppy=1},
   mesecons = {receptor = {
		state = mesecon.state.off
	}},
	on_receive_fields = function(pos, formname, fields, player)
 	 	digital_receive_fields(pos, formname, fields, player,"Input")
    end,
    after_place_node = function(pos, node, puncher, pointed_thing)
    	digital_punched(pos, node, puncher, pointed_thing,"Input")
	 end
})


minetest.register_node("abbozza:digital_in_on", {
	description = "",
	tiles = {"digital_in_on.png"},
	groups = {choppy=1},
    light_source = 5,
 	 on_receive_fields = function(pos, formname, fields, player)
 	 	digital_receive_fields(pos, formname, fields, player,"Input")
    end,
    after_place_node = function(pos, node, puncher, pointed_thing)
    	digital_punched(pos, node, puncher, pointed_thing,"Input")
	 end,
   mesecons = {receptor = {
		state = mesecon.state.on
	}}          
})


minetest.register_node("abbozza:digital_in_inactive", {
	description = "",
	tiles = {"digital_in_inactive.png"},
	groups = {choppy=1},
   mesecons = {receptor = {
		state = mesecon.state.off
	}},
 	 on_receive_fields = function(pos, formname, fields, player)
 	 	digital_receive_fields(pos, formname, fields, player,"Input")
    end,
    after_place_node = function(pos, node, puncher, pointed_thing)
    	digital_punched(pos, node, puncher, pointed_thing,"Input")
	 end
})


minetest.register_abm({
	nodenames = {"abbozza:digital_in_off" , "abbozza:digital_in_on", "abbozza:digital_in_inactive"},
	interval = 2.0, -- Run every 1 second
	chance = 1, -- run each time
	action = function(pos, node, active_object_count, active_object_count_wider)
	   local meta = minetest.get_meta(pos)
	   local pin = meta:get_string("pin")
           local host = meta:get_string("host")
           local port = meta:get_string("port")
	   abz_send_http(pos,host,port,"dget " .. pin, abz_timeout)
	   
	   -- check the message
		local response = meta:get_string("msg")
		meta:set_string("msg",nil)
		
	   if response ~= nil and response ~= "" then
	      local state = string.match(response,".*DVAL.*(%d+)")
		   if state == "1" then
		      minetest.swap_node(pos, {name = "abbozza:digital_in_on", param2 = node.param2})
				mesecon.receptor_on(pos, nil)
			elseif state == "0" then
		      minetest.swap_node(pos, {name = "abbozza:digital_in_off", param2 = node.param2})
				mesecon.receptor_off(pos, nil)
			else
		      minetest.swap_node(pos, {name = "abbozza:digital_in_inactive", param2 = node.param2})
				mesecon.receptor_off(pos, nil)
		   end
	   end
	end
})
