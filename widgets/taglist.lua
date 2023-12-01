--Import modules
local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "3.0")
local Gio = lgi.require("Gio")
local GLib = lgi.GLib

local provider = Gtk.CssProvider()
local success, error = provider:load_from_path("./style.css")
if not success then
	print("Error loading CSS:", error)
end

local ntag = 6

local tag_lbls = {}
local tags = {}

for i = 1, ntag, 1 do
	tag_lbls[i] = Gtk.Label { label = i }
	tag_lbls[i]:get_style_context():add_class("label2")
	tag_lbls[i]:get_style_context():add_class("fg-middark")
	tag_lbls[i]:get_style_context():add_provider(provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)

	tags[i] = Gtk.Button { child = tag_lbls[i] }
	tags[i]:get_style_context():add_class("inactive")
	-- tags[i]:get_style_context():add_class("fg-dark")
	tags[i]:get_style_context():add_provider(provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)
end

local taglist = Gtk.Box.new(Gtk.Orientation.VERTICAL, 4)
for i = 1, ntag, 1 do
	taglist:pack_start(tags[i], false, true, 0)
end

for i = 1, ntag, 1 do
	if i == 3 then
		tag_lbls[i]:get_style_context():remove_class("fg-middark")
		tag_lbls[i]:get_style_context():add_class("fg-dark")
		tags[i]:get_style_context():add_class("active")
	end
end

--------------------------------------------------
--Updating tags-----------------------------------
--------------------------------------------------
local socket_path = "/tmp/hypr/" .. os.getenv("HYPRLAND_INSTANCE_SIGNATURE") .. "/.socket2.sock"
local client = Gio.SocketClient.new()

local socket, err = client:connect(Gio.UnixSocketAddress.new(socket_path), nil)

if socket == nil then
	print("Error connecting to Unix socket:", tostring(err))
else
	print("Successfully connected to Unix socket!")

	local datainputstream = Gio.DataInputStream.new(socket:get_input_stream())

	local function onDataReceived()
		local buffer_size = 1024
		local data, size, read_error = datainputstream:read_line(nil)

		-- if size ~= 0 then
		if string.match(data, "workspace>>(%d+)") ~= nil and
				string.match(data, "destroyworkspace>>(%d+)") == nil and
				string.match(data, "createworkspace>>(%d+)") == nil
		then
			local workspace_id = string.match("--" .. data, "--workspace>>(%d+)")
			-- print("Read", size, "bytes:", workspace_id)
			for i = 1, ntag, 1 do
				tags[i]:get_style_context():remove_class('active')
				tag_lbls[i]:get_style_context():remove_class('fg-dark')
				tag_lbls[i]:get_style_context():add_class('fg-middark')
				if i == tonumber(workspace_id) then
					tags[i]:get_style_context():add_class('active')
					tag_lbls[i]:get_style_context():add_class('fg-dark')
				end
			end
			print(workspace_id)
			-- Update the label text
		end
		-- elseif size == 0 then
		-- 	print("End of stream (socket closed by the other end).")
		-- 	GLib.MainLoop.quit(main_loop)
		-- else
		-- 	print("Error reading data:", tostring(read_error))
		-- end

		return true
	end

	-- Set up the main loop
	-- local main_loop = GLib.MainLoop.new(nil, false)
	GLib.idle_add(GLib.PRIORITY_LOW, onDataReceived)

	-- Run the GTK main loop
end


return taglist
