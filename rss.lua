-- Returns unread messages count in newsbeuter.
--
-- Author: Viacheslav Chimishuk <voice@root.ua>
-- Date: 25.05.2010

local settings = {
	cmd = "/usr/bin/newsbeuter -x print-unread | grep -o '[0-9]*'"
}

function rss_get_unread_count()
   local f = io.popen(settings.cmd)
   local l = f:read()
   f:close()
   
   return l
end
