-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init(os.getenv("HOME") .. "/.config/awesome/my-theme/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt +sb"
editor = os.getenv("EDITOR") or "emacs -nw"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,               -- 1
    awful.layout.suit.tile.left,          -- 2
    awful.layout.suit.tile.bottom,        -- 3
    awful.layout.suit.tile.top,           -- 4
    awful.layout.suit.fair,               -- 5
    awful.layout.suit.fair.horizontal,    -- 6
    awful.layout.suit.max,                -- 7
    awful.layout.suit.max.fullscreen,     -- 8
    awful.layout.suit.magnifier,          -- 9
    awful.layout.suit.floating,           -- 10
    awful.layout.suit.spiral,             -- 11
    awful.layout.suit.spiral.dwindle      -- 12
}

-- Define default layout for every tag.
default_layouts =
{
    awful.layout.suit.max,
    awful.layout.suit.max,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.magnifier,
    awful.layout.suit.tile,
    awful.layout.suit.fair.horizontal
}

-- Define if we want to use titlebar on all applications.
use_titlebar = false
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ "web", "emacs", "term", "misc", "im", "music" }, s)

    -- Set default layout for tags.
    for tagnumber = 1, 6 do
       awful.layout.set(default_layouts[tagnumber], tags[s][tagnumber])
       --awful.layout.set(layouts[tagnumber], tags[s][tagnumber])
    end
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mywibox_bottom = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

-- Create bottom wibox's widgets.
clockmonitor = widget({ type = "textbox" })
mailmonitor = widget({ type = "textbox" })
batterymonitor = widget({ type = "textbox" })
cputempmonitor = widget({ type = "textbox" })
rssmonitor = widget({ type = "textbox" })

for s = 1, screen.count() do
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }

    -- Create bottom wibox.
    mywibox_bottom[s] = awful.wibox({ position = "bottom", screen = s })
    mywibox_bottom[s].widgets = {
       clockmonitor,
       cputempmonitor,
       batterymonitor,
       rssmonitor,
       mailmonitor,
       layout = awful.widget.layout.horizontal.rightleft
    }    
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, ",",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, ".",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "/", awful.tag.history.restore),

    awful.key({ modkey,           }, "n",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "p",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "F1", function () mymainmenu:show(true)        end),

    -- Layout manipulation
    awful.key({ modkey,           }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey,           }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "F2", function () awful.util.spawn(terminal) end),
    awful.key({ modkey,           }, "F3", function () awful.util.spawn("gmrun") end),
    awful.key({ modkey,           }, "F4", function () awful.util.spawn("/home/viacheslav/bin/emacs") end),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    -- awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    -- awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Control" }, "space", function () awful.layout.inc(layouts, -1) end),

    -- MPD hotkeys
    awful.key({ modkey,           }, "KP_Subtract", function () awful.util.spawn("mpc -h server -p 6600 toggle") end),
    awful.key({ modkey,           }, "KP_Divide",   function () awful.util.spawn("mpc -h server -p 6600 volume -2") end),
    awful.key({ modkey,           }, "KP_Multiply", function () awful.util.spawn("mpc -h server -p 6600 volume +2") end),

    -- Other custom hotkeys
    awful.key({modkey,            }, "F11", function () awful.util.spawn("/home/viacheslav/bin/monitor off") end)
)

clientkeys = awful.util.table.join(
    -- awful.key({ modkey,           }, "KP_Enter", function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "Return", function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "c",        function (c) c:kill()                         end),
    -- awful.key({ modkey, "Control" }, "KP_Enter", awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", awful.client.floating.toggle                     ),
    -- awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    -- awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    -- awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    -- awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 1 of screen 1.
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][1] } },
    { rule = { class = "Emacs" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "Pidgin" },
      properties = { tag = tags[1][5] } },

    { rule = { class = "gajim.py" },
      properties = { tag = tags[1][5] } },
    { rule = { class = "Gajim.py" },
      properties = { tag = tags[1][5] } },
    { rule = { class = "Gajim" },
      properties = { tag = tags[1][5] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
    c.size_hints_honor = false
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Widgets hooks
-- Clock monitor hook.
update_clock_proc = function ()
		       clockmonitor.text = os.date(" [%d.%m.%Y %H:%M]")
		    end
update_clock_proc()
mytimer = timer { timeout = 50 }
mytimer:add_signal("timeout", update_clock_proc)
mytimer:start()

-- Mail monitor hook.
require("mbox")
update_mail_proc = function ()
		      local main_total, main_unread, main_new = calcmail(os.getenv("HOME") .. "/.mail/main")
		      local golang_total, golang_unread, golang_new = calcmail(os.getenv("HOME") .. "/.mail/golang-nuts")

		      mailmonitor.text = " [Mail: " .. main_unread .. ":" .. golang_unread .. "]"
		   end
update_mail_proc()
mytimer = timer { timeout = 5 }
mytimer:add_signal("timeout", update_mail_proc)
mytimer:start()

-- RSS monitor hook.
--require("rss")
--update_rss_proc = function ()
--		     rssmonitor.text = " [RSS: " .. rss_get_unread_count() .. "]"
--		  end
--update_rss_proc()
--mytimer = timer { timeout = 5 }
--mytimer:add_signal("timeout", update_rss_proc)
--mytimer:start()

-- Battery usage monitor hook.
require("linuxbatt")
update_battery_proc = function ()
			 local state, perc = get_linuxbatt()

			 batterymonitor.text = " [Battery: " .. state .. perc .. "%]"
		      end
update_battery_proc()
mytimer = timer { timeout = 30 }
mytimer:add_signal("timeout", update_battery_proc)
mytimer:start()

-- CPU temprature monitor hook.
require("cputemp")
require("cpufreq")
update_cputemp_proc = function ()
			 cputempmonitor.text = " [CPU: " .. get_cpufreq() .. "MHz " .. get_cputemp() .. "]"
		      end
update_cputemp_proc()
mytimer = timer { timeout = 10 }
mytimer:add_signal("timeout", update_cputemp_proc)
mytimer:start()
-- }}}

-- {{{ Include custom files.
require("autostart")
-- }}}