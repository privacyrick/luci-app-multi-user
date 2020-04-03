-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Copyright 2010-2015 Jo-Philipp Wich <jow@openwrt.org>
-- Licensed to the public under the Apache License 2.0.

local utl = require "luci.util"
local dsp = require "luci.dispatcher"

m = Map("users", arg[1]:upper() or "", translate("User Configuration Options"))

local fs = require "nixio.fs"
local menu = dsp.load_menu()
local groups = {"users", "admin", "other"}
local mu = require "luci.users"
require "uci"
local uci = uci.cursor()
local s,o

m.on_after_commit = function()
  mu.edit_user(arg[1])			
end

s = m:section(NamedSection, arg[1], "user")
s.addremove = false


function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function s.parse(self, ...)
  NamedSection.parse(self, ...)
end

o = s:option(ListValue, "group", translate("User Group"))
for k, v in ipairs(groups) do
	o:value(v)
end

o = s:option(ListValue, "shell", translate("SSH Access"))
o.rmempty = false
o:value("Enabled", "Enabled")
o:value("Disabled", "Disabled")
o.default = "Enabled"

for i,v in pairs(menu) do
  o = s:option(Flag, i.."_menus", translate("Enable ".. firstToUpper(i).." Menus"))
  o.disabled = "disabled" 
  o.enabled = "admin."..i
  new = s:option(MultiValue, i.."_subs")
  new.delimiter = ","
  for j,k in ipairs(v) do
    new:depends(i.."_menus", "admin."..i)
   local name = k:sub(0,k:find("-")-1)
   local path =  k:sub(k:find("-")+1,-1)
   if name ~= "Status" and name ~= "Services" and name ~= "Administration" and name ~= "Overview" then
     new:value(path,name)
   end
  end
end

m.redirect = luci.dispatcher.build_url("admin/users/users")

return m
