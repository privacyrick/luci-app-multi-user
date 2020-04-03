-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Copyright 2011-2015 Jo-Philipp Wich <jow@openwrt.org>
-- Licensed to the public under the Apache License 2.0.

module("luci.controller.admin.users", package.seeall)

require ("uci")
local usw = require "luci.users"

function index()
	local page
	local nw = require "luci.dispatcher"
	local user = nw.get_user()
	local uci = uci.cursor()
	local fs = require "nixio.fs"

	if user == "root" then
	  page = node("admin", "users")
	  page.target = firstchild()
	  page.title  = _("Users")
	  page.order  = 60
	  page.index  = true
		
		entry({"admin", "users", "add_user"}, cbi("admin_users/add_user"), nil).leaf = true

		entry({"admin", "users", "edit_user"}, cbi("admin_users/edit_user"), nil).leaf = true

		entry({"admin", "users", "user_delete"}, post("user_delete"), nil).leaf = true

		entry({"admin", "users", "user_status"}, call("user_status"), nil).leaf = true

		entry({"admin", "users", "users"}, arcombine(cbi("admin_users/users"), cbi("admin_users/edit_user")), _("Edit Users"), 10).subindex = true

		if page.inreq then
			uci:foreach("users", "user",
				function (section)
					local ifc = section[".name"]
					if ifc ~= "loopback" and ifc ~= "new" then
						entry({"admin", "users", "users", ifc},
						true, ifc:upper())
					end
				end)
		end
		
	end
	if user ~= "root" then
	  name = string.sub(user:upper(),0,1) .. user:sub(2,-1)
	  page = node("admin", "users")
	  page.target = firstchild()
	  page.title  = _(name.."s Options")
	  page.order  = 50
	  page.index  = true

	  	entry({"admin", "users", "passwd"}, cbi("admin_users/passwd"), _("Password"), 10)
	end


end

local function cdate(user)
  local user = user or 'root'
  local udate = nixio.fs.stat("/home/"..user)
  local first
  if udate then
    first = os.date("%c", udate.ctime)
  end
  return first
end

local function adate(user)
  local user = user or 'root'
  local udate = nixio.fs.stat("/home/"..user.."/activity")
  local last
  if udate then 
    last = os.date("%c", udate.mtime)
  end
  return last
end

local function get_shell(user)
  local user = user or 'root'
  local uci = uci.cursor()
  local shell = uci:get("users", user, "shell")
 return shell
end

local function get_group(user)
  local user = user or 'root'
  local uci = uci.cursor()
  local group = uci:get("users", user, "group")
 return group
end

function user_status(users)
  local rv   = { }
  local user
 if users then 
  for user in users:gmatch("[%w%.%-_]+") do
    local first = adate(user)
    local last = cdate(user)
    local shell = get_shell(user)
    local group = get_group(user)
    if user then
      local data = {
		     id		= user,
		     shell      = shell,
		     group      = group,
		     first	= first,
		     last 	= last
	
		   }

      rv[#rv+1] = data
    else
      rv[#rv+1] = {
		    id   	= user,
		    shell 	= "unknown",
		    group 	= "unknown"
		  }
    end
  end
 end
  if #rv > 0 then
    luci.http.prepare_content("application/json")
    luci.http.write_json(rv)
   return
  end
 luci.http.status(404, "No such device")
end

function user_delete(user)
  local usw = require "luci.users"
  local uci = uci.cursor()
  local rem = uci:delete("users",user)
	
  uci:commit("users")
  usw.del_user(user)
  luci.http.redirect(luci.dispatcher.build_url("admin/users/users"))
 return
end
