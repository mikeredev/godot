class_name DisplaySettings extends RefCounted

static var section_key: String = "display"

static var options: Dictionary = {
	"window_mode": {
		"default": 3,
		"choices": {
			"Windowed": 1,
			"Fullscreen": 2,
			"Borderless Window": 3,
		},
	},
	"resolution": {
		"default": 2,
		"choices": {
			"800x600": 1,
			"1152x648": 2,
			"1920x1080": 3,
			"2560x1440": 4,
		},
	},
	"vsync": {
		"default": 1,
		"choices": {
			"disabled": 0,
			"enabled": 1,
			"adaptive": 2,
			"mailbox": 3,
		}
	},
	"zoom": {
		"default": 1,
	},
	"ui_scale": {
		"default": 1,
	},
}

var mytype: Array = []

static func apply() -> void:
	var window_mode: int = ConfigManager.user_settings.get_value(section_key, "window_mode")
	var resolution: int = ConfigManager.user_settings.get_value(section_key, "resolution")
	var vsync: int = ConfigManager.user_settings.get_value(section_key, "vsync")

	set_window_mode(window_mode)
	set_resolution(resolution)
	set_vsync(vsync)


static func set_window_mode(index: int) -> void:
	match index:
		1:
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		3:
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		_:
			Debug.log("invalid window mode: %d" % index, 1)
			var default: int = options.window_mode["default"]
			set_window_mode(default)
			return
	Debug.log("set window mode: %d" % index, 3)


static func set_resolution(index: int) -> void:
	var resolution: Vector2i
	match index:
		1: resolution = Vector2i(800, 600)
		2: resolution = Vector2i(1152, 648)
		3: resolution = Vector2i(1920, 1080)
		4: resolution = Vector2i(2560, 1440)
		_:
			Debug.log("invalid resolution: %d" % index, 1)
			var default: int = options.resolution["default"]
			set_resolution(default)
			return

	var root: NodeRoot = Registry.get_root()

	DisplayServer.window_set_size(resolution)
	root.get_window().content_scale_size = resolution

	var centered: Vector2i = (DisplayServer.screen_get_size() - DisplayServer.window_get_size()) / 2
	root.get_window().position = centered

	Debug.log("set resolution: %s" % str(resolution), 3)


static func set_vsync(index: int) -> void:
	match index:
		0: DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		1: DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		2: DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)
		3: DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_MAILBOX)
		_:
			Debug.log("invalid vsync mode: %d" % index, 1)
			var default: int = options.vsync["default"]
			set_vsync(default)
			return

	Debug.log("set vsync: %s" % index, 3)


static func set_zoom() -> void:
	var _zoom: int
	pass


static func set_ui_scale() -> void:
	var _ui_scale: int
	pass
