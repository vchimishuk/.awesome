-- Copyright (c) Tuomo Valkonen 2004-2009.
function calcmail(fname)
   local f, err=io.open(fname, 'r')
    -- mbox could be huge, get only chunk from EOF.
    -- Attachment could be much bigger than this chunk.
   local tail_size = 1024 * 1024 * -1 -- 1 Mb
   f:seek("end", tail_size)

   local total, read, old=0, 0, 0
   local had_blank=true
   local in_headers=false
   local had_status=false
   
   for l in f:lines() do
      if had_blank and string.find(l, '^From ') then
         total=total+1
         had_status=false
         in_headers=true
         had_blank=false
      else
         had_blank=false
         if l=="" then
            if in_headers then
               in_headers=false
            end
            had_blank=true
         elseif in_headers and not had_status then
            local st, en, stat=string.find(l, '^Status:(.*)')
            if stat then
               had_status=true
               if string.find(l, 'R') then
                  read=read+1
               end
               if string.find(l, 'O') then
                  old=old+1
               end
            end
         end
      end
   end
   
   f:close()
   
   return total, total-read, total-old
end
