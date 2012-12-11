-- Author: Viacheslav Chimishuk <voice@root.ua>
-- Date: 13.12.2008
-- Description: Monitor which displays CPU tempreture.


local settings = {
	cmd = "sensors | grep Core | awk '{print $3}'",
}

function get_cputemp()
   local f = io.popen(settings.cmd)
   local l = f:read()
   f:close()
   
   return l
end
