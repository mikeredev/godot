extends Node

const USER_SETTINGS: String = "res://settings.ini"
var user_settings: ConfigFile = ConfigFile.new()
var options: Dictionary = {
	"window_size": {
		"800x600": Vector2(800, 600),
		"1152x648": Vector2(1152, 648),
		"1920x1080": Vector2(1920, 1080),
		"2560x1440": Vector2(2560, 1440),
	},
	"window_mode": {
		"windowed": 0,
		"fullscreen": 4,
	},
	"borderless": true,
	"vsync": true,
	"monitor": 0,
}


func _ready() -> void:
	debug.write("Loading user settings...")
	initialize_user_settings()
	apply_user_settings()
	debug.write("User settings loaded")


# Initialize user settings from the configuration file, or apply defaults if missing.
func initialize_user_settings() -> void:
	if not FileAccess.file_exists(USER_SETTINGS):
		apply_default_settings()
		save_user_settings()
	else:
		load_user_settings()


# Apply the default settings to the user settings file.
func apply_default_settings() -> void:
	user_settings.set_value("display", "monitor", options["monitor"])
	user_settings.set_value("display", "window_size", options["window_size"]["1152x648"])
	user_settings.set_value("display", "window_mode", options["window_mode"]["windowed"])
	user_settings.set_value("display", "borderless", options["borderless"])
	user_settings.set_value("display", "vsync", options["vsync"])
	debug.write("Default user settings applied", 3)


# Load user settings from the file.
func load_user_settings() -> void:
	if user_settings.load(USER_SETTINGS) == 0:
		check_and_set_default("window_size", options["window_size"]["1152x648"])
		check_and_set_default("window_mode", options["window_mode"]["windowed"])
		check_and_set_default("borderless", options["borderless"])
		check_and_set_default("vsync", options["vsync"])
		check_and_set_default("monitor", options["monitor"])
		return
	debug.write("Failed to load user settings", 2)


# Check if a setting is missing; if so, set it to the default.
func check_and_set_default(setting: String, default_value: Variant) -> void:
	if user_settings.get_value("display", setting) == null:
		user_settings.set_value("display", setting, default_value)
		save_user_settings()
		debug.write("Default %s setting set to %s" % [setting, str(default_value)], 1)


# Apply the user settings to the game.
func apply_user_settings() -> void:
	var monitor: int = user_settings.get_value("display", "monitor")
	var window_size: Vector2 = user_settings.get_value("display", "window_size")
	var window_mode: int = user_settings.get_value("display", "window_mode")
	var borderless: bool = user_settings.get_value("display", "borderless")
	var vsync: bool = user_settings.get_value("display", "vsync")

	get_monitor(monitor)
	set_window_size(window_size)
	set_window_mode(window_mode)
	set_borderless(borderless)
	set_vsync(vsync)


# Save the user settings to the file.
func save_user_settings() -> void:
	if user_settings.save(USER_SETTINGS) == 0:
		debug.write("User settings saved", 3)
		return
	debug.write("Failed to save user settings", 2)


# Set the monitor to be used.
func get_monitor(display: int) -> void:
	debug.write("Using display %d" % display, 3)


# Set the window size and center it on the screen.
func set_window_size(window_size: Vector2) -> void:
	get_window().size = window_size
	get_window().content_scale_size = window_size
	var used_monitor: int = options["monitor"]
	var screen_size: Vector2 = DisplayServer.screen_get_size(used_monitor)
	var centered: Vector2 = (screen_size - window_size) / 2
	get_window().position = centered
	debug.write("Window size set to %s" % window_size, 3)


# Set the window mode (e.g., windowed or fullscreen).
func set_window_mode(mode: int) -> void:
	DisplayServer.window_set_mode(mode)
	debug.write("Window mode set to %d" % mode, 3)


# Enable or disable the borderless window mode.
func set_borderless(flag: bool) -> void:
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, flag)
	debug.write("Borderless set to %s" % flag, 3)


# Enable or disable V-Sync.
func set_vsync(flag: bool) -> void:
	var vsync_mode: DisplayServer.VSyncMode = DisplayServer.VSYNC_DISABLED
	if flag:
		vsync_mode = DisplayServer.VSYNC_ENABLED
	DisplayServer.window_set_vsync_mode(vsync_mode)
	debug.write("V-Sync enabled set to %s" % flag, 3)
