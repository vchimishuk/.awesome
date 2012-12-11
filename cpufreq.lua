-- statusd_cpufreq.lua
--
-- Public domain
--
-- Use the key "cpufreq_[KMG]" to get the current CPU frequency in
-- K/M/GHz, according to /sys/devices/system/cpu/cpuX/cpufreq/.  (This
-- has the advantage of being a much "rounder" number than the one in
-- /proc/cpuinfo, as provided by statusd_cpuspeed.lua.)
-- 
-- The "cpu" option to the statusd settings for cpufreq modifies which
-- cpu we look at.

local settings = {
   cpu=0
}

function get_cpufreq()
   local f=io.open('/sys/devices/system/cpu/cpu'.. settings.cpu ..'/cpufreq/scaling_cur_freq')
   local cpufreq_K = f:read('*a')
   f:close()
   
   local cpufreq_M = cpufreq_K / 1000
   -- local cpufreq_G = cpufreq_M / 1000
   
   -- return tostring(cpufreq_K), tostring(cpufreq_M), tostring(cpufreq_G)
   return tostring(cpufreq_M)
end
