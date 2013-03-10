-- statusd_linuxbatt.lua
--
-- Public domain
--
-- Uses the /proc/acpi interface to get battery percentage.
--
-- Use the key "linuxbatt" to get the battery percentage; use
-- "linuxbatt_state" to get a symbol indicating charging "+",
-- discharging "-", or charged " ".
--
-- Now uses lua functions instead of bash, awk, dc.  MUCH faster!
--
-- The "bat" option to the statusd settings for linuxbatt modifies which
-- battery we look at.

-- Battery 0: Discharging, 94%, 01:42:25 remaining
-- Battery 0: Unknown, 94%
-- Battery 0: Charging, 94%, charging at zero rate - will never fully charge.
-- Battery 0: Full, 100%

local settings={
   status_file = "/sys/class/power_supply/BAT1/uevent"
}

-- Returns: charged percent, chargin status.
-- Charging status:
-- - -- discharging
-- + -- charging
-- = -- full
-- ~ -- Unknown
function get_linuxbatt()
   local charging_statuses = {
	  Discharging = "-",
	  Charging = "+",
	  Full = "=",
	  Unknown = "~",
   }

   local status = nil
   local charge_full = nil
   local charge_now = nil
   local charge_percent = nil


   for line in io.lines(settings.status_file) do
	  local i, j, param = string.find(line, "POWER_SUPPLY_(.+)=")
	  if i ~= nil then 
		 if param == "STATUS" then
			i, j, param = string.find(line, "=(%a+)", j)
			if i ~= nil then
			   status = charging_statuses[param]
			end
		 elseif param == "ENERGY_FULL" then
			i, j, param = string.find(line, "=(%d+)", j)
			if i ~= nil then
			   charge_full = param
			end
		 elseif param == "ENERGY_NOW" then
			i, j, param = string.find(line, "=(%d+)", j)
			if i ~= nil then
			   charge_now = param
			end
		 end
	  end
   end

   if charge_full ~= nil and charge_now ~= nil then
	  charge_percent = math.floor(charge_now * 100 / charge_full)
   end

   return status, charge_percent
end
