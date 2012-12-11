-- Author Viacheslav Chimishuk <voice@root.ua>
-- Date: 28.11.2009
-- Description: Awesome monitor, outputs keyboard layout.
-- Require: getxkblayout

local settings = {
   cmd = "skb -1" --"getxkblayout",
}

function get_kblayout()
   local f = io.popen(settings.cmd)
   local l = f:read()
   f:close()

   return l
end
