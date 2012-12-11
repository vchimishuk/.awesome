local settings = {
   status_file = "/tmp/mcabber.status"
}

function mcabber_is_unread()
   local f = io.open(settings.status_file)

   if(f ~= nil) then
      io.close(f)
   end

   return f ~= nil
end