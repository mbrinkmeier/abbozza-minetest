--[[

minetest.register_node("abbozza:switch_off", {
    tiles = {"abbozza_off.png"},
    groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
})

minetest.register_node("abbozza:switch_on", {
    tiles = {"abbozza_on.png"},
    groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
})


minetest.register_on_punchnode( function(pos, node, puncher, pointed_thing)
    if node.name == "abbozza:switch_off" then
        -- minetest.chat_send_player(puncher:get_player_name(), "/abz [[dset 17 1]]")
        abz_send("[[dset 17 1]]")
        minetest.swap_node(pos, {name = "abbozza:switch_on"} )
    elseif node.name == "abbozza:switch_on" then
        -- minetest.chat_send_player(puncher:get_player_name(), "/abz [[dset 17 0]]")
        abz_send("[[dset 17 0]]")
        minetest.swap_node(pos, {name = "abbozza:switch_off"} )
    end
end)


minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
    if oldnode.name == "abbozza:switch_off" then
        minetest.chat_send_player(digger:get_player_name(), "pick1")
    elseif oldnode.name == "abbozza:switch_on" then
        minetest.chat_send_player(digger:get_player_name(), "pick2")
    end
end)


minetest.register_on_dignode(function(pos, oldnode, digger)
    if oldnode.name == "abbozza:switch_off" then
        minetest.chat_send_player(digger:get_player_name(), "pick")
    elseif oldnode.name == "abbozza:switch_on" then
        minetest.chat_send_player(digger:get_player_name(), "pick")
    end
end)

minetest.register_on_chat_message(function(name, message)
    minetest.chat_send_player(name, "hier"  )
    command = string.find(message,"^/abz (.*)")      
    if command ~= "" then
        minetest.chat_send_player(name, "abbozza command received: " .. command)
    end
end)

--]]
