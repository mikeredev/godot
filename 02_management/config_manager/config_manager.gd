class_name ConfigManager extends RefCounted

static var running_config: ConfigFile
static var display: Dictionary = Settings.display
static var keyboard: Dictionary = Settings.keyboard
static var _reload_required: bool


static func apply() -> void:
	running_config = ConfigFile.new()
	check()
	verify()
	apply_all()


static func check() -> void:
	if not FileAccess.file_exists(FilePath.SAVED_SETTINGS):
		for key: String in display.keys():
			running_config.set_value("display", key, display[key]["default"])
		for key: String in keyboard.keys():
			running_config.set_value("keyboard", key, keyboard[key])
		running_config.save(FilePath.SAVED_SETTINGS)


static func verify() -> void:
	running_config.load(FilePath.SAVED_SETTINGS)

	# display settings
	for key: String in display.keys():
		if not running_config.has_section_key("display", key):
			running_config.set_value("display", key, display[key]["default"])
			running_config.save(FilePath.SAVED_SETTINGS)
			_reload_required = true

	# key bindings
	for key: String in keyboard.keys():
		if not running_config.has_section_key("keyboard", key):
			running_config.set_value("keyboard", key, keyboard[key])
			running_config.save(FilePath.SAVED_SETTINGS)
			_reload_required = true


static func apply_all() -> void:
	if _reload_required:
		running_config.load(FilePath.SAVED_SETTINGS)

	# display settings
	for key: String in running_config.get_section_keys("display"):
		match key:
			"window_mode":
				var selection: int = running_config.get_value("display", key)
				set_window_mode(selection)
			"resolution":
				var selection: int = running_config.get_value("display", key)
				set_resolution(selection)
			"vsync":
				var selection: int = running_config.get_value("display", key)
				set_vsync(selection)
			_:
				Debug.log("ignoring unrecognized key: %s" % key, 1)

	# key bindings
	for key: String in running_config.get_section_keys("keyboard"):
		var selection: String = running_config.get_value("keyboard", key)
		set_key_binding(key, selection.to_upper())


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
			Debug.log("ignoring unrecognized window mode selection: %d" % index, 1)
			var default: int = display.window_mode["default"]
			running_config.set_value("display", "window_mode", default)
			running_config.save(FilePath.SAVED_SETTINGS)

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
			Debug.log("ignoring unrecognized resolution selection: %d" % index, 1)
			var default: int = display.resolution["default"]
			running_config.set_value("display", "resolution", default)
			running_config.save(FilePath.SAVED_SETTINGS)

			set_resolution(default)
			return

	var tree_root: GameManager = Register.get_game_manager()
	DisplayServer.window_set_size(resolution)
	tree_root.get_window().content_scale_size = resolution

	var centered: Vector2i = (DisplayServer.screen_get_size() - DisplayServer.window_get_size()) / 2
	tree_root.get_window().position = centered

	Debug.log("set resolution: %d" % index, 3)


static func set_vsync(index: int) -> void:
	match index:
		1: DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		2: DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		3: DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)
		4: DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_MAILBOX)
		_:
			Debug.log("ignoring unrecognized vsync selection: %d" % index, 1)
			var default: int = display.vsync["default"]
			running_config.set_value("display", "vsync", default)
			running_config.save(FilePath.SAVED_SETTINGS)

			set_vsync(default)
			return

	Debug.log("set vsync: %s" % index, 3)


static func set_key_binding(_action: String, event: String) -> void:
	var new_event: InputEventKey = InputEventKey.new()
	var new_key: Key = OS.find_keycode_from_string(event)
	new_event.keycode = new_key
	if not InputMap.has_action(_action):
		Debug.log("action not found: %s" % _action, 2)
		return
	InputMap.action_add_event(_action, new_event)
	Debug.log("bound action %s: %s" % [_action, new_event.as_text()], 3)
