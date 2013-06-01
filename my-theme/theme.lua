local theme_path = os.getenv("HOME") .. "/.config/awesome/my-theme/"
local default_theme_path = "/usr/share/awesome/themes/default/"

theme = {}

theme.font          = "Ubuntu Mono 14"

theme.bg_normal     = "#2d2d2d"
theme.bg_focus      = "#3a3a3a"
theme.bg_urgent     = "#530000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#bbbbbb"
theme.fg_urgent     = "#cccccc"
theme.fg_minimize   = "#cccccc"

theme.border_width  = 1
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

-- There are another variables sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- Example:
--taglist_bg_focus = #ff0000

-- Display the taglist squares
theme.taglist_squares_sel   = theme_path .. "taglist_squares.png"
theme.taglist_squares_unsel = theme_path .. "taglist_squares.png"

-- Variables set for theming menu
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = default_theme_path .. "submenu.png"
theme.menu_height       = 25
theme.menu_width        = 200

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--bg_widget    = #cc0000

-- Define the image to load
theme.titlebar_close_button_normal              = default_theme_path .. "titlebar/close_normal.png"
theme.titlebar_close_button_focus               = default_theme_path .. "titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive     = default_theme_path .. "titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive      = default_theme_path .. "titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = default_theme_path .. "titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active        = default_theme_path .. "titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive    = default_theme_path .. "titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive     = default_theme_path .. "titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = default_theme_path .. "titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active       = default_theme_path .. "titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive  = default_theme_path .. "titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive   = default_theme_path .. "titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = default_theme_path .. "titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active     = default_theme_path .. "titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = default_theme_path .. "titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = default_theme_path .. "titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = default_theme_path .. "titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = default_theme_path .. "titlebar/maximized_focus_active.png"

theme.wallpaper = theme_path .. "tux_keyboard.jpg"

-- You can use your own layout icons like this:
theme.layout_fairh      = default_theme_path .. "layouts/fairhw.png"
theme.layout_fairv      = default_theme_path .. "layouts/fairvw.png"
theme.layout_floating   = default_theme_path .. "layouts/floatingw.png"
theme.layout_magnifier  = default_theme_path .. "layouts/magnifierw.png"
theme.layout_max        = default_theme_path .. "layouts/maxw.png"
theme.layout_fullscreen = default_theme_path .. "layouts/fullscreenw.png"
theme.layout_tilebottom = default_theme_path .. "layouts/tilebottomw.png"
theme.layout_tileleft   = default_theme_path .. "layouts/tileleftw.png"
theme.layout_tile       = default_theme_path .. "layouts/tilew.png"
theme.layout_tiletop    = default_theme_path .. "layouts/tiletopw.png"
theme.layout_spiral     = default_theme_path .. "layouts/spiralw.png"
theme.layout_dwindle    = default_theme_path .. "layouts/dwindlew.png"

theme.awesome_icon = "/usr/share/awesome/icons/awesome32.png"

-- theme.icon_theme = nil

return theme
