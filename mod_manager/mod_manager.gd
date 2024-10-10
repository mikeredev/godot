class_name ModManager extends RefCounted

static var world: World:
	get():
		if not world:
			world = Registry.world
		return world
static var active_mods: PackedStringArray = []


static func get_manifest(mod_directory: String) -> Dictionary:
	var path_to_manifest: String = "%s/manifest.json" % mod_directory

	if not FileAccess.file_exists(path_to_manifest):
		Debug.log("could not find manifest.json in: %s" % mod_directory, 1)
		return {}

	var manifest_string: String = FileAccess.get_file_as_string(path_to_manifest)
	var manifest: Dictionary = JSON.parse_string(manifest_string)
	manifest["directory"] = mod_directory # this field is automatically added to the manifest

	## TODO fail gracefully if corrupted manifest.json

	var icon_path: String = "%s/icon.png" % mod_directory
	if FileAccess.file_exists(icon_path):
		manifest["icon"] = icon_path
	else:
		manifest["icon"] = FileDB.DEFAULT_MOD_ICON #  # this field is automatically added to the manifest
	return manifest


static func create_mod_info_dict(manifest: Dictionary) -> Dictionary:
	var mod_info: Dictionary = {
		"name": manifest["name"],
		"version": manifest["version"],
		"author": manifest["author"],
		"directory": manifest["directory"]
	}
	return mod_info


static func enable_mod(manifest: Dictionary) -> void:
	for category: String in manifest["category"]:
		var mod_directory: String = "%s" % manifest["directory"]
		var mod_subfolder: String = "%s/%s" % [mod_directory, category]

		match category:
			"world":
				var string: String = FileAccess.get_file_as_string(mod_subfolder + "/world.json")
				var config: Dictionary = JSON.parse_string(string)
				var mod_info: Dictionary = create_mod_info_dict(manifest)

				if not enable_world(config, mod_info):
					Debug.log("failed to enable mod: %s" % mod_info["directory"], 1)
					return

				var mod_list: Dictionary = world.metadata.mod_list
				if not mod_list.has(mod_info.directory):
					mod_list[mod_info.directory] = mod_info

			"country":
				var string: String = FileAccess.get_file_as_string(mod_subfolder + "/countries.json")
				var config: Dictionary = JSON.parse_string(string)
				var mod_info: Dictionary = create_mod_info_dict(manifest)

				if not world.metadata.has("countries"):
					world.metadata["countries"] = {}

				if not enable_country(config, mod_info):
					Debug.log("failed to enable mod: %s" % mod_info["directory"], 1)
					return

				var mod_list: Dictionary = world.metadata.mod_list
				if not mod_list.has(mod_info.directory):
					mod_list[mod_info.directory] = mod_info

			"city":
				var string: String = FileAccess.get_file_as_string(mod_subfolder + "/cities.json")
				var config: Dictionary = JSON.parse_string(string)
				var mod_info: Dictionary = create_mod_info_dict(manifest)

				if not world.metadata.has("cities"):
					world.metadata["cities"] = {}

				if not enable_city(config, mod_info):
					Debug.log("failed to enable mod: %s" % mod_directory, 1)
					return

				var mod_list: Dictionary = world.metadata.mod_list
				if not mod_list.has(mod_info.directory):
					mod_list[mod_info.directory] = mod_info

			"trade_item":
				var string: String = FileAccess.get_file_as_string(mod_subfolder + "/trade_items.json")
				var config: Dictionary = JSON.parse_string(string)
				var mod_info: Dictionary = create_mod_info_dict(manifest)

				if not world.metadata.has("trade_items"):
					world.metadata["trade_items"] = {}

				if not enable_trade_item(config, mod_info):
					Debug.log("failed to enable mod: %s" % mod_directory, 1)
					return

				var mod_list: Dictionary = world.metadata.mod_list
				if not mod_list.has(mod_info.directory):
					mod_list[mod_info.directory] = mod_info

			"inventory_item":
				pass
			"ship":
				pass
			_:
				Debug.log("unrecognized category in %s manifest: %s" % [manifest["name"], category], 1)
				return

	active_mods.append(str(manifest["directory"]))

	Debug.log("enabled mod: %s %s" % [manifest["name"], active_mods], 3)


static func enable_world(config: Dictionary, mod_info: Dictionary) -> bool:
	Debug.log("enabling world: %s" % mod_info.name, 3)

	if not world.metadata.has("mod_list"):
		world.metadata["mod_list"] = {}
	world.metadata["mod_list"][mod_info.directory] = mod_info # create a dictionary in the world metadata, using the mod directory path as a unique identifier

	# these will all be set by the core mod, and can be, but are not required to be, overwritten by custom mods of the "world" category
	var expected_texture_path: String = "%s/world/map.png" % mod_info.directory
	if FileAccess.file_exists(expected_texture_path):
		world.metadata["map"] = expected_texture_path
		Debug.log("set map [%s]" % mod_info.name, 3)

	if config.has("astar"):
		world.metadata["astar"] = config.astar
		Debug.log("set astar [%s]" % mod_info.name, 3)

	if config.has("weights"):
		world.metadata["weights"] = config.weights
		Debug.log("set weights [%s]" % mod_info.name, 3)

	if config.has("regions"):
		world.metadata["regions"] = config.regions
		Debug.log("set regions [%s]" % mod_info.name, 3)

	if config.has("subregions"):
		world.metadata["subregions"] = config.subregions
		Debug.log("set subregions [%s]" % mod_info.name, 3)

	if config.has("timestamp"):
		world.metadata["timestamp"] = config.timestamp
		Debug.log("set start date: %s" % config["timestamp"], 3)

	return true


static func enable_country(config: Dictionary, mod_info: Dictionary) -> bool:
	for country_name: String in config.keys():
		world.metadata["countries"][country_name] = config[country_name]

		if not mod_info.directory == FileDB.CORE_MOD_DIR:
			world.metadata["countries"][country_name]["mod"] = mod_info.directory

	return true


static func enable_city(config: Dictionary, mod_info: Dictionary) -> bool:
	for city_name: String in config.keys():
		world.metadata["cities"][city_name] = config[city_name]

		if not mod_info.directory == FileDB.CORE_MOD_DIR:
			world.metadata["cities"][city_name]["mod"] = mod_info.directory

	return true


static func enable_trade_item(config: Dictionary, mod_info: Dictionary) -> bool:
	for trade_item_name: String in config.keys():
		world.metadata["trade_items"][trade_item_name] = config[trade_item_name]

		if not mod_info.directory == FileDB.CORE_MOD_DIR:
			world.metadata["trade_items"][trade_item_name]["mod"] = mod_info.directory

	return true
