print("Initializing abbozza mod ...")

dofile(minetest.get_modpath("abbozza") .. "/queue.lua")

-- local winvar = os.getenv("OS")
-- if winvar ~= nil then
-- 	dofile(minetest.get_modpath("abbozza") .. "/comm_win.lua")
-- else
-- 	dofile(minetest.get_modpath("abbozza") .. "/comm_ix.lua")
-- end

abz_http = minetest.request_http_api()
print(abz_http)

dofile(minetest.get_modpath("abbozza") .. "/comm_http.lua")

dofile(minetest.get_modpath("abbozza") .. "/communication.lua")
dofile(minetest.get_modpath("abbozza") .. "/digital.lua")
