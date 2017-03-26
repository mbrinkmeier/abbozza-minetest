digital_punched = function(pos, node, puncher, pointed_thing)
  	local meta = minetest.get_meta(pos)
  	meta:set_string("formspec",
		"size[5,4]" ..
		"field[1,1;3,1;pin;Digital pin;" .. meta:get_string("pin") .. "]" ..
		"button_exit[1,2;3,1;save;Save]"
	)
end


digital_receive_fields = function(pos, formname, fields, sender)
   local meta = minetest.get_meta(pos)
   meta:set_string("pin",fields.pin)
  	meta:set_string("formspec",
		"size[5,4]" ..
		"field[1,1;3,1;pin;Digital pin;" .. meta:get_string("pin") .. "]" ..
		"button_exit[1,2;3,1;save;Save]"
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
               if pin ~= "" then
                  abz_send(pos,"dset " .. pin .. " 1")
   		         minetest.swap_node(pos, {name = "abbozza:digital_on", param2 = node.param2} )
               end
            end
	 }},
 	 on_receive_fields = function(pos, formname, fields, player)
 	 	digital_receive_fields(pos, formname, fields, player)
    end,
    after_place_node = function(pos, node, puncher, pointed_thing)
    	digital_punched(pos, node, puncher, pointed_thing)
	 end
	 --[[ ,
 	 drawtype = "nodebox",
	 node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5,	0.5, -0.25, 0.5},
			{-0.1, -0.25, -0.1,  0.1, 0.5, 0.1},
		},
	} ]]       
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
               if pin ~= "" then
                  abz_send(pos,"dset " .. pin .. " 0",pos)
		            minetest.swap_node(pos, {name = "abbozza:digital_off", param2 = node.param2})
		         end
            end
	}},
   after_place_node = function(pos, node, puncher, pointed_thing)
   	digital_punched(pos, node, puncher, pointed_thing)
	end,         
 	on_receive_fields = function(pos, formname, fields, player)
 	 	digital_receive_fields(pos, formname, fields, player)
   end
    --[[ ,
 	 drawtype = "nodebox",
	 node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5,	0.5, -0.25, 0.5},
			{-0.1, -0.25, -0.1,  0.1, 0.5, 0.1},
		},
	} ]]
})


minetest.register_node("abbozza:digital_in_off", {
	description = "abbozza! digital input",
	tiles = {"digital_in_off.png"},
	groups = {choppy=1},
   mesecons = {receptor = {
		state = mesecon.state.off
	}},
	on_receive_fields = function(pos, formname, fields, player)
 	 	digital_receive_fields(pos, formname, fields, player)
    end,
    after_place_node = function(pos, node, puncher, pointed_thing)
    	digital_punched(pos, node, puncher, pointed_thing)
	 end
})


minetest.register_node("abbozza:digital_in_on", {
	description = "",
	tiles = {"digital_in_on.png"},
	groups = {choppy=1},
    light_source = 5,
 	 on_receive_fields = function(pos, formname, fields, player)
 	 	digital_receive_fields(pos, formname, fields, player)
    end,
    after_place_node = function(pos, node, puncher, pointed_thing)
    	digital_punched(pos, node, puncher, pointed_thing)
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
 	 	digital_receive_fields(pos, formname, fields, player)
    end,
    after_place_node = function(pos, node, puncher, pointed_thing)
    	digital_punched(pos, node, puncher, pointed_thing)
	 end
})


minetest.register_abm({
	nodenames = {"abbozza:digital_in_off" , "abbozza:digital_in_on", "abbozza:digital_in_inactive"},
	interval = 2.0, -- Run every 1 second
	chance = 1, -- Select every 1 in 50 nodes
	action = function(pos, node, active_object_count, active_object_count_wider)
	   local meta = minetest.get_meta(pos)
	   local pin = meta:get_string("pin")
	   abz_send(pos,"dget " .. pin)
	   
	   -- check the message
		local response = meta:get_string("msg")
		-- print("received: " .. response)
		meta:set_string("msg",nil)
		
	   if response ~= nil and response ~= "" then
	      local state = string.match(response,".*DVAL.*(%d+)")
	      -- print("state: " .. state)
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
