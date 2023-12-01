--Import modules
local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "3.0")
local GLib = lgi.GLib

local provider = Gtk.CssProvider()
local success, err = provider:load_from_path("./style.css")
if not success then
	print("Error loading CSS:", err)
end


local create_labels = function(clr_class, txt)
	local lbl = Gtk.Label { label = txt }
	lbl:get_style_context():add_class("label2")
	lbl:get_style_context():add_class(clr_class)
	lbl:get_style_context():add_provider(provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)
	return lbl
end

local time_hr = create_labels("fg-mid", os.date("%H"))
local time_min = create_labels("fg-mid", os.date("%M"))

local time = Gtk.Box.new(Gtk.Orientation.VERTICAL, 0)
time:pack_start(time_hr, false, true, 0)
time:pack_start(time_min, false, true, 0)

time:get_style_context():add_class("button")
time:get_style_context():add_class("top")
time:get_style_context():add_class("bg-normal")
time:get_style_context():add_class("round")
time:get_style_context():add_provider(provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)

GLib.timeout_add(200, 60000, function()
	time_hr:set_label(os.date("%H"))
	time_min:set_label(os.date("%M"))
	return true
end, 1000)


return time
