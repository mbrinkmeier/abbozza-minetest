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
-- The init script of the abbozza! plugin for minetest
--
print("Initializing abbozza mod ...")

-- get HTTPRequestApi
abz_http = minetest.request_http_api and minetest.request_http_api()

if ( abz_http == nil ) then
   print("Could not get HTTP Api. Check the following conditions")
   print("1) Was minetest build with cURL support?")
   print("2) The abbozza! mod has to be added to the trusted mods.")
   print("   Add 'secure.trusted_mods = abbozza' and 'secure.http_mods = abbozza' to your local minetest.conf")
   return
end

dofile(minetest.get_modpath("abbozza") .. "/config.lua")
dofile(minetest.get_modpath("abbozza") .. "/queue.lua")
dofile(minetest.get_modpath("abbozza") .. "/comm_http.lua")
dofile(minetest.get_modpath("abbozza") .. "/communication.lua")
dofile(minetest.get_modpath("abbozza") .. "/digital.lua")
