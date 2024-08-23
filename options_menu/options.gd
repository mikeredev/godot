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
		for size in config.options["window_size"].keys():
			option_window_size.add_item(size)
	window_size_string = str(config.user_settings.get_value("display", "window_size"))
	select_window_size_option(window_size_string)

# Select the current window size in the UI
func select_window_size_option(size_string: String) -> void:
	match size_string:
		"(800, 600)": option_window_size.select(1)
		"(1152, 648)": option_window_size.select(2)
		"(1920, 1080)": option_window_size.select(3)
		"(2560, 1440)": option_window_size.select(4)  # Added missing case

# Initialize window mode options
func initialize_window_mode_options() -> void:
	if not option_window_mode.has_selectable_items():
		option_window_mode.add_separator("[select]")
		for mode in config.options["window_mode"].keys():
			var id: int = config.options["window_mode"][mode]
			option_window_mode.add_item(mode, id)
	select_window_mode_option(config.user_settings.get_value("display", "window_mode"))

# Select the current window mode in the UI
func select_window_mode_option(current_mode_id: int) -> void:
	var item_count = option_window_mode.get_item_count()
	for i in range(item_count):
		if option_window_mode.get_item_id(i) == current_mode_id:
			option_window_mode.select(i)
			break

# Initialize checkbox states
func initialize_checkboxes() -> void:
	checkbox_borderless.button_pressed = config.user_settings.get_value("display", "borderless")
	checkbox_vsync.button_pressed = config.user_settings.get_value("display", "vsync")

# Apply the selected settings
func _on_button_apply_button_up() -> void:
	apply_window_size_setting()
	apply_window_mode_setting()
	apply_borderless_setting()
	apply_vsync_setting()

# Apply window size setting
func apply_window_size_setting() -> void:
	var window_size = parse_window_size(option_window_size.get_item_text(option_window_size.selected))
	if not config.user_settings.get_value("display", "window_size") == window_size:
		config.user_settings.set_value("display", "window_size", window_size)
		config.set_window_size(window_size)

# Parse window size from string format "WIDTHxHEIGHT"
func parse_window_size(size_string: String) -> Vector2:
	var components = size_string.split("x")
	return Vector2(components[0].to_int(), components[1].to_int())

# Apply window mode setting
func apply_window_mode_setting() -> void:
	var selected_mode_id = option_window_mode.get_item_id(option_window_mode.selected)
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

# Save the settings to the configuration file
func _on_button_save_button_up() -> void:
	config.user_settings.save(config.USER_SETTINGS)
	logger.write("User settings saved")

# Close the settings menu
func _on_button_close_button_up() -> void:
	self.queue_free()

# Restore the default settings
func _on_button_restore_button_up() -> void:
	config.create_user_default_settings()
	config.initialize_user_settings()
	self.queue_free()
