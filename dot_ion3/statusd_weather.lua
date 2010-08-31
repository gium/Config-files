-- statusd_weather.lua
-- 
-- Author
-- Guillaume Sadegh
-- guillaume.sadegh@lrde.epita.fr

if not statusd_weather then
  statusd_weather={
    interval=300*1000,
  }
end

local timer = nil   -- the timer

--
-- update the uptime monitor
--
local function get_weather_info()
   -- paris : FRXX0076
   -- madrid : SPXX0050

   local CODE = 'SPXX0050';
   local f=io.popen("wget 'http://xoap.weather.com/weather/local/'" .. CODE .. "'?cc=*&link=xoap&prod=xoap&par=1168658022&unit=m&key=8a9cf7b11f89c65a&unit=m' -O - -o /dev/null | awk 'BEGIN {seen=0;} (/<cc>/) {seen=1;} (seen) {print; if (/<t>/) {exit;} } '  | sed 'N;N;N;N;N;s+.*<obst>\(.*\)</obst>.*<tmp>\(.*\)</tmp>.*<t>\(.*\)</t>.*+\1: \2°C (\3)+;s+[,/].*:+:+'", 'r')
    local s=f:read('*line')
    f:close()
    statusd.inform("weather", s)
end

--
-- start the timer
-- 
local function init_weather_monitor()
    timer = statusd.create_timer()
    statusd.inform("uptime_template", "xxxxxxxxxxxxxxx")
    get_weather_info()
end

init_weather_monitor()
