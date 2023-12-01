--Import modules
local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "3.0")
local layer_shell = lgi.require("GtkLayerShell")
local GLib = require("lgi").GLib

--Load css file
local provider = Gtk.CssProvider()
local success, err = provider:load_from_path("style.css")
if not success then
	print("Error loading CSS:", err)
end

--------------------------------
--Import Widgets----------------
--------------------------------
local launcher = require('widgets.launcher')
local time = require('widgets.time')
local power = require('widgets.power')
local buttons = require("widgets.buttons")
local taglist = require("widgets.taglist")

--------------------------------
--Bar widget--------------------
--------------------------------
local bar_box = Gtk.Box.new(Gtk.Orientation.VERTICAL, 0)
bar_box:pack_start(launcher, false, true, 0)
bar_box:pack_start(time, false, true, 0)
bar_box:pack_end(power, false, true, 0)
bar_box:pack_end(buttons, false, true, 0)
bar_box:set_center_widget(taglist, false, true, 0)

--------------------------------
--Bar Window--------------------
--------------------------------
local bar = Gtk.Window {
	title = "sidebar",
	on_destroy = Gtk.main_quit
}

bar:add(bar_box)

--Add css class to bar
bar:get_style_context():add_class("bar")
bar:get_style_context():add_provider(provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)

--layer_shell
layer_shell.init_for_window(bar)

--position
layer_shell.set_anchor(bar, layer_shell.Edge.TOP, true)
layer_shell.set_anchor(bar, layer_shell.Edge.RIGHT, true)
layer_shell.set_anchor(bar, layer_shell.Edge.BOTTOM, true)
layer_shell.set_exclusive_zone(bar, 42)

--margin
layer_shell.set_margin(bar, layer_shell.Edge.TOP, 8)
layer_shell.set_margin(bar, layer_shell.Edge.BOTTOM, 8)
layer_shell.set_margin(bar, layer_shell.Edge.LEFT, 5)
layer_shell.set_margin(bar, layer_shell.Edge.RIGHT, 5)

bar:show_all()

Gtk.main()
