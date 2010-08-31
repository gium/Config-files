-- statusd_alsa.lua
-- 
-- Author
-- Guillaume Sadegh
-- guillaume.sadegh@lrde.epita.fr

if not statusd_alsa then
  statusd_alsa={
    interval=30*1000,
  }
end

local timer = nil   -- the timer

--
-- update the uptime monitor
--
local function get_alsa_info()
    local f=io.popen('aumix -q | head -n 1', 'r')
    timer:set(statusd_alsa.interval, get_alsa_info)
    if not f then
        statusd.inform("alsa", "oops: is aumix installed ?")
        return
    end
    local s=f:read('*line')
    f:close()

    s = string.gsub(s, "vol (%d+), %d+", "%1")    -- unnecessary

    statusd.inform("alsa", s.."/100")
end

--
-- start the timer
-- 
local function init_alsa_monitor()
    timer = statusd.create_timer()
    statusd.inform("uptime_template", "xxxxxxxxxxxxxxx")
    get_alsa_info()
end

function alsa_up()
    io.popen('aumix -v +5', 'r')
    get_alsa_info()
end

function alsa_down()
    io.popen('aumix -v -5', 'r')
    get_alsa_info()
end

init_alsa_monitor()
