class_name LoadMods extends ActiveState


func _init(node_name: String = "MODS") -> void:
	name = node_name


func enter() -> void:
	Debug.log("Loading core mod")
	load_core_mod()

	Debug.log("Loading user mods")
	load_user_mods()

	StateManager.change(StartMenu.new()) # ready


func load_core_mod() -> void:
	var core_mod_manifest: Dictionary = ModManager.get_manifest(FileDB.CORE_MOD_DIR)
	ModManager.enable_mod(core_mod_manifest)


func load_user_mods() -> void:
	if not ConfigManager.running_config.has_section_key("mods", "active"):
		Debug.log("no active mods found", 3)
		return

	var active_mods: PackedStringArray = ConfigManager.running_config.get_value("mods", "active")
	if active_mods.is_empty():
		Debug.log("no active mods to load", 3)
		return

	for mod_directory: String in active_mods:
		if not mod_directory == FileDB.CORE_MOD_DIR: # hardcoded just in case anyone messes with the config file
			var mod_manifest: Dictionary = ModManager.get_manifest(mod_directory)
			if not mod_manifest:
				Debug.log("unable to load mod: %s" % mod_directory, 2)
				return
			ModManager.enable_mod(mod_manifest)
