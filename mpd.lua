-- statusd for MPD (Music Player Daemon)
-- by Marc Hartstein <marc.hartstein@alum.vassar.edu>
--
-- version 1.0
--
-- Based on a script by delirium@hackish.org

-- requires LuaSocket
-- http://www.tecgraf.puc-rio.br/~diego/professional/luasocket/home.html

local settings={
    -- 500 or less makes seconds increment relatively smoothly while playing
    -- update_interval = 500,

    -- how long to go to sleep when we can't talk to mpd so we don't spam the
    -- system with connection attempts every half-second
    -- retry_interval = 5 * 1000,           -- 1m

    -- mpd server info (localhost:6600 are mpd defaults)
    address = "192.168.1.2",
    port    = 6600,

    -- mpd password (if any)
    password = nil,

    -- display template
    -- ---
    -- can use the following:
    --   track metadata: %artist, %title, %num, %album, %year, %len
    --   current track position: %pos
    --   escape for the percent character: %%
    --   conditional metadata: %artist_or_album (e.g. for Broadway)

    -- a default template
    template = "%artist - %num - %title (%pos / %len)"
}

local mpd_timer
local last_success

-- load namespace
local socket = require("socket")
local mpd_socket

-- set up a try function which closes the socket if there's an error
local try = socket.newtry(function() mpd_socket:close() end)

local open_socket = socket.protect(function()
    -- connect to the server
    mpd_socket = socket.try(socket.connect(settings.address, settings.port))

    mpd_socket:settimeout(100)

    local data                          -- buffer for reads

    data = try(mpd_socket:receive())
    if data == nil or string.sub(data,1,6) ~= "OK MPD" then
        mpd_socket:close()
        return nil, "mpd not running"
    end

    -- send password (if necessary)
    if settings.password ~= nil then
        try(mpd_socket:send("password " .. settings.password .. "\n"))

        repeat
            data = try(mpd_socket:receive())
        until data == nil or string.sub(data,1,2) == "OK" or string.sub(data,1,3) == "ACK"
        if data == nil or string.sub(data,1,2) ~= "OK" then
            mpd_socket:close()
            return nil, "bad mpd password"
        end
    end

    return true
end)


local get_mpd_status = socket.protect(function()
    local data                          -- buffer for reads
    local success = false
    local info = {}

    -- 'status'
    -- %pos, %len, and current state (paused/stopped/playing)
    try(mpd_socket:send("status\n"))
    repeat
        data = try(mpd_socket:receive())
        if data == nil then break end

        local _,_,attrib,val = string.find(data, "(.-): (.*)")
        if attrib == "time" then
            _,_,info.pos,info.len = string.find(val, "(%d+):(%d+)")
            info.pos = string.format("%d:%02d", math.floor(info.pos / 60), math.mod(info.pos, 60))
            info.len = string.format("%d:%02d", math.floor(info.len / 60), math.mod(info.len, 60))
        elseif attrib == "state" then
            info.state = val
        end
    until string.sub(data,1,2) == "OK" or string.sub(data,1,3) == "ACK"
    if data == nil or string.sub(data,1,2) ~= "OK" then
        mpd_socket:close()
        return nil, "error querying mpd status"
    end

    -- 'currentsong'
    -- song information
    try(mpd_socket:send("currentsong\n"))
    repeat
        data = try(mpd_socket:receive())
        if data == nil then break end

        local _,_,attrib,val = string.find(data, "(.-): (.*)")
        if     attrib == "Artist" then info.artist = val
        elseif attrib == "Title"  then info.title  = val
        elseif attrib == "Album"  then info.album  = val
        elseif attrib == "Track"  then info.num    = val
        elseif attrib == "Date"   then info.year   = val
        end
    until string.sub(data,1,2) == "OK" or string.sub(data,1,3) == "ACK"
    if data == nil or string.sub(data,1,2) ~= "OK" then
        mpd_socket:close()
        return nil, "error querying current song"
    end
    -- %artist_or_album
    if info.artist == nil then
        info.artist_or_album = info.album
    else
        info.artist_or_album = info.artist
    end

    success = true

    -- done querying; now build the string
    if info.state == "play" then
        local mpd_st = settings.template
        -- fill in %values
        mpd_st = string.gsub(mpd_st, "%%([%w%_]+)", function (x) return(info[x]  or "") end)
        mpd_st = string.gsub(mpd_st, "%%%%", "%%")
        return success, mpd_st
    elseif info.state == "pause" then
        return success, "Paused"
    else
        return success, "No song playing"
    end
end)


function init_mpd()
   seccess, errstr = open_socket()
   if not success then
       mpdmonitor.text = errstr
   end
end


