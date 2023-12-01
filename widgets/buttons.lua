--Import modules
local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "3.0")
local Gio = lgi.require("Gio")

local provider = Gtk.CssProvider()
local success, err = provider:load_from_path("./style.css")
if not success then
	print("Error loading CSS:", err)
end

local create_button = function(txt, class, lblclass)
	local lbl = Gtk.Label { label = txt }

	for _, v in pairs(lblclass) do
		lbl:get_style_context():add_class(v)
		lbl:get_style_context():add_class(v)
	end
	lbl:get_style_context():add_provider(provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)

	local btn = Gtk.Button { child = lbl }

	for _, v in pairs(class) do
		btn:get_style_context():add_class(v)
		btn:get_style_context():add_class(v)
	end
	btn:get_style_context():add_provider(provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)

	return btn
end

local colorpicker = create_button('󰂚', { 'button', 'bg-normal', 'round-top' }, { 'label', 'fg-blue' })
local control = create_button('', { 'button', 'bg-normal' }, { 'label', 'fg-yellow' })
local music = create_button('󰋋', { 'button', 'bg-normal', 'round-bottom' }, { 'label', 'fg-orange' })

local box = Gtk.Box.new(Gtk.Orientation.VERTICAL, 0)
box:pack_start(colorpicker, false, true, 0)
box:pack_start(control, false, true, 0)
box:pack_start(music, false, true, 0)

-- box:get_style_context():add_class("button")
box:get_style_context():add_class("bottom")
box:get_style_context():add_provider(provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)

return box
