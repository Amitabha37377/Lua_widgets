--Import modules
local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "3.0")
local Gio = lgi.require("Gio")

local provider = Gtk.CssProvider()
local success, err = provider:load_from_path("./style.css")
if not success then
	print("Error loading CSS:", err)
end

local btnlabel = Gtk.Button { label = "" }
btnlabel:get_style_context():add_class("label")
btnlabel:get_style_context():add_class("fg-dark")
btnlabel:get_style_context():add_provider(provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)

local button = Gtk.Button {
	child = btnlabel,
}
button:get_style_context():add_class("button")
button:get_style_context():add_class("top")
button:get_style_context():add_class("bg-blue")
button:get_style_context():add_class("round")
button:get_style_context():add_provider(provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)


return button
