# luci-app-multi-user
A simple LuCi App/Module that adds Multi-User Support and Management Features

Original Code: https://github.com/Fire-WRT/luci/tree/master-multi5/applications/luci-app-multi-user

All in all, I think the multi-user-app is a great solution but of course it has its kinks, especially in trying to migrate it into OpenWRT v19 Stable Branch.

So far I've been able to successfully adapt the code for use in v19 with the ability to create, edit, and delete users as seen below:

**Screenshots:**
![Multi-User Capture](https://user-images.githubusercontent.com/51210718/77835703-b1dcfd00-7125-11ea-9bff-34fa61039bd7.PNG)

![Edit-User Capture](https://user-images.githubusercontent.com/51210718/77835783-8870a100-7126-11ea-9af7-d7a6f3b1aeb6.PNG)

But I'm getting several odd errors that I'm hoping someone can point me in the right direction in solving.

**Error 1:**
Firstly I'm able to login normally with either or root of my created user but there's a weird error on the login screen. Browser Console returns: 
_Error: "No related RPC reply"
    flushRequestQueue /luci-static/resources/luci.js?v=git-20.087.56959-ed1fc63:44
luci.js:103:9_
**Screenshot:**
![Multi-User Login Error Capture](https://user-images.githubusercontent.com/51210718/77835789-a2aa7f00-7126-11ea-9d2a-c72f455bd79d.PNG)

**Error 2:**
Secondly, when editing a new user, not all of my available SubMenus nor my available Page Tabs come up as options to enable/disable for the user. The panel will include some Page Tabs but not others as well as some SubMenus but not others. 
**Example:**
![Edit-Menus Capture](https://user-images.githubusercontent.com/51210718/77835928-03868700-7128-11ea-94c1-efc7d5b52f33.PNG)

**Error 3:**
Additionally, not so much an error, but when a user is created using the Edit Users menu, there isn't a way to set a password for that user. In order to allow the new user to login to LuCi, you have to set a password for the new user via CLI using passwd command in this case. Also, if you add another user, then delete that user, for whatever reason, it also wipes the password for the first user so you have to set the password for that user via CLI again.

**Error 4:**
And finally, when actually enabling menus for a user, it will successfully show those menu items when the user is logged in but none of the pages will load except for the password page added by the module. Rather than loading, Luci throws RPC errors similar to the error on the login screen but my browser console returns the following:
_Error: "No related RPC reply"
    flushRequestQueue /luci-static/resources/luci.js?v=git-20.087.56959-ed1fc63:44
luci.js:103:9_

_Error: "No related RPC reply"
    flushRequestQueue /luci-static/resources/luci.js?v=git-20.087.56959-ed1fc63:44
luci.js:103:9_
**Screenshot:**
![TestUser Error Capture](https://user-images.githubusercontent.com/51210718/77835965-61b36a00-7128-11ea-8133-c48110d9c147.PNG)

That's everything I've been able to find in my experimentation but to be frank, these issues have got me stumped. Hopefully someone can help me out and so I can update this new version and others can start using it. Thanks in advance!

**Cheers,
Rick**
