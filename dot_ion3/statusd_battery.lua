-- statusd_battery.lua
-- 
-- Author
-- Guillaume Sadegh

if not statusd_battery then
  statusd_battery={
    interval=3*1000,
  }
end

local timer = nil   -- the timer

--
-- update the battery monitor
--
local function get_battery_info()
    local f = io.popen('acpi', 'r')
    timer:set(statusd_battery.interval, get_battery_info)
    if not f then
        statusd.inform("battery", "need `acpi'")
        return
    end
    local s = f:read('*line')
    f:close()

    if not s then
        statusd.inform("battery", "*AC*")
        statusd.inform("battery_hint", "critical")
        return
    end

    ac = string.find(s, "remaining")
    percent = string.match(s, "%d+%%")

    if not ac then
       if percent then
          statusd.inform("battery", "*AC* (" .. percent .. ")")
       else
          statusd.inform("battery", "*AC*")
       end
       statusd.inform("battery_hint", "normal")
       return
    end

    time = string.match(s, "%d+:%d+:%d+")
    percent = string.match(percent, "%d+")

    hint = "normal"
    if (tonumber(percent) < 10) then
       hint = "important"
    end
    if (tonumber(percent) < 5) then
       hint = "critical"
    end

    statusd.inform("battery", time .. " (" .. percent .. "%)")
    statusd.inform("battery_hint", hint)
end

--
-- start the timer
-- 
local function init_battery_monitor()
    timer = statusd.create_timer()
    statusd.inform("battery_template", "xxxxxxxxxxxxxxx")
    get_battery_info()
end

init_battery_monitor()
