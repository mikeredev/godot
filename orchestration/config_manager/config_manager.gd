class_name ConfigManager extends RefCounted

static var user_settings_file: String = FilePathDB.settings["user"]
static var user_settings: ConfigFile


static func apply_user_settings() -> void:
	Debug.log("Applying user settings")
	user_settings = ConfigFile.new()
	if not FileAccess.file_exists(user_settings_file):
		Debug.log("user settings not found, creating: %s" % user_settings_file, 3)
		create_settings()

	load_settings(user_settings)
	if verify(GeneralSettings): GeneralSettings.apply()
	if verify(DisplaySettings): DisplaySettings.apply()


static func create_settings() -> void:
	set_default(GeneralSettings)
	set_default(DisplaySettings)
	save_settings(user_settings)


static func verify(settings: Variant) -> bool:
	var options: Dictionary = settings.options
	for option: String in options.keys():
		var section_key: String = settings.section_key
		if not ConfigManager.user_settings.has_section_key(section_key, option):
			set_default(settings)
			ConfigManager.save_settings(ConfigManager.user_settings)
	return true


static func set_default(settings: Variant) -> void:
	var options: Dictionary = settings.options
	for option: String in options.keys():
		var setting: Dictionary = settings.options[option]
		var section_key: String = settings.section_key
		ConfigManager.user_settings.set_value(section_key, option, setting["default"])


static func load_settings(_user_settings: ConfigFile) -> void:
	if not _user_settings.load(user_settings_file) == 0:
			Debug.log("unable to load user settings: %s" % user_settings_file, 2)


static func save_settings(_user_settings: ConfigFile) -> void:
	if not _user_settings.save(user_settings_file) == 0:
		Debug.log("unable to save user settings: %s" % user_settings_file, 2)
	Debug.log("saved user settings", 3)
