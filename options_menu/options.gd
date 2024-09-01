extends Control

# Declare and connect UI elements
var window_size_string: String
@onready var option_window_size: OptionButton = %option_window_size
@onready var option_window_mode: OptionButton = %option_window_mode
@onready var checkbox_borderless: CheckBox = %checkbox_borderless
@onready var checkbox_vsync: CheckBox = %checkbox_vsync
@onready var button_apply: Button = %button_apply
@onready var button_save: Button = %button_save


func _ready() -> void:
	# Initialize the UI with current settings
	initialize_window_size_options()
	initialize_window_mode_options()
	initialize_checkboxes()


# Initialize window size options
func initialize_window_size_options() -> void:
	if not option_window_size.has_selectable_items():
		option_window_size.add_separator("[select]")
		var window_size_options: Dictionary = config.options["window_size"]
		for available_size: String in window_size_options.keys():
			option_window_size.add_item(available_size)
	window_size_string = str(config.user_settings.get_value("display", "window_size"))
	select_window_size_option(window_size_string)


# Select the current window size in the UI
func select_window_size_option(size_string: String) -> void:
	match size_string:
		"(800, 600)": option_window_size.select(1)
		"(1152, 648)": option_window_size.select(2)
		"(1920, 1080)": option_window_size.select(3)
		"(2560, 1440)": option_window_size.select(4)


# Initialize window mode options
func initialize_window_mode_options() -> void:
	if not option_window_mode.has_selectable_items():
		option_window_mode.add_separator("[select]")
		var window_mode_options: Dictionary = config.options["window_mode"]
		for mode: String in window_mode_options.keys():
			var id: int = window_mode_options[mode]
			option_window_mode.add_item(mode, id)
	var selected_window_mode: int = config.user_settings.get_value("display", "window_mode")
	select_window_mode_option(selected_window_mode)


# Select the current window mode in the UI
func select_window_mode_option(current_mode_id: int) -> void:
	var item_count: int = option_window_mode.get_item_count()
	for i: int in range(item_count):
		if option_window_mode.get_item_id(i) == current_mode_id:
			option_window_mode.select(i)
			break


# Initialize checkbox states
func initialize_checkboxes() -> void:
	checkbox_borderless.button_pressed = config.user_settings.get_value("display", "borderless")
	checkbox_vsync.button_pressed = config.user_settings.get_value("display", "vsync")


# Apply window size setting
func apply_window_size_setting() -> void:
	var window_size: Vector2 = parse_window_size(option_window_size.get_item_text(option_window_size.selected))
	if not config.user_settings.get_value("display", "window_size") == window_size:
		config.user_settings.set_value("display", "window_size", window_size)
		config.set_window_size(window_size)


# Parse window size from string format "WIDTHxHEIGHT"
func parse_window_size(size_string: String) -> Vector2:
	var components: PackedStringArray = size_string.split("x")
	return Vector2(components[0].to_int(), components[1].to_int())


# Apply window mode setting
func apply_window_mode_setting() -> void:
	var selected_mode_id: int = option_window_mode.get_item_id(option_window_mode.selected)
	if not selected_mode_id == config.user_settings.get_value("display", "window_mode"):
		config.user_settings.set_value("display", "window_mode", selected_mode_id)
		config.set_window_mode(selected_mode_id)


# Apply borderless setting
func apply_borderless_setting() -> void:
	if not config.user_settings.get_value("display", "borderless") == checkbox_borderless.button_pressed:
		config.user_settings.set_value("display", "borderless", checkbox_borderless.button_pressed)
		config.set_borderless(checkbox_borderless.button_pressed)


# Apply V-Sync setting
func apply_vsync_setting() -> void:
	if not config.user_settings.get_value("display", "vsync") == checkbox_vsync.button_pressed:
		config.user_settings.set_value("display", "vsync", checkbox_vsync.button_pressed)
		config.set_vsync(checkbox_vsync.button_pressed)


# Apply the selected settings
func _on_button_apply_button_up() -> void:
	apply_window_size_setting()
	apply_window_mode_setting()
	apply_borderless_setting()
	apply_vsync_setting()


# Save the settings to the configuration file
func _on_button_save_button_up() -> void:
	if config.user_settings.save(config.USER_SETTINGS) == 0:
		debug.write("User settings saved")
		return
	debug.write("Failed to save user settings", 2)


# Close the settings menu
func _on_button_close_button_up() -> void:
	self.queue_free()


# Restore the default settings
func _on_button_restore_button_up() -> void:
	debug.write("Restoring default user settings")
	config.apply_default_settings()
	config.save_user_settings()
	config.initialize_user_settings()
	config.apply_user_settings()
	debug.write("Default user settings restored")
	self.queue_free()
