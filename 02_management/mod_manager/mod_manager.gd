class_name ModManager extends RefCounted

static var active_mods: PackedStringArray = []
static var country_container: NodeContainer


static func get_manifest(mod_directory: String) -> Dictionary:
	var path_to_manifest: String = "%s/manifest.json" % mod_directory

	if not FileAccess.file_exists(path_to_manifest):
		Debug.log("could not find manifest.json in: %s" % mod_directory, 1)
		return {}

	var manifest_string: String = FileAccess.get_file_as_string(path_to_manifest)
	var manifest: Dictionary = JSON.parse_string(manifest_string)
	manifest["directory"] = mod_directory

	## TODO fail gracefully if corrupted manifest.json

	var icon_path: String = "%s/icon.png" % mod_directory
	if FileAccess.file_exists(icon_path):
		manifest["icon"] = icon_path
	else:
		manifest["icon"] = FilePath.DEFAULT_MOD_ICON

	return manifest


static func enable_mod(manifest: Dictionary, save_as_config: bool = false) -> void:
	if active_mods.has(str(manifest["directory"])):
		Debug.log("mod already loaded: %s" % manifest["name"], 1)
		return

	for category: String in manifest["category"]:
		match category:
			"country":
				var _resource_path: String = "%s/%s" % [manifest["directory"], category]
				for resource_path: String in DirAccess.get_files_at(_resource_path):
					if resource_path.ends_with(".tres"):
						var resource_file: String = "%s/%s/%s" % [manifest["directory"], category, resource_path]
						if not enable_country(resource_file):
							Debug.log("failed to enable mod: %s" % manifest["name"], 1)
							return
			"city":
				pass
			"trade_item":
				pass
			"inventory_item":
				pass
			"ship":
				pass
			"utility":
				pass
			_:
				Debug.log("unrecognized category in %s manifest: %s" % [manifest["name"], category], 1)
				return

	active_mods.append(str(manifest["directory"]))

	if save_as_config:
		ConfigManager.running_config.set_value("mods", "active", active_mods)
		ConfigManager.running_config.save(FilePath.SAVED_SETTINGS)

	Debug.log("enabled mod: %s %s" % [manifest["name"], active_mods], 3)


static func enable_country(resource_file: String) -> bool:
	var resource: CountryResource = load(resource_file)

	# handles pre-existing nodes of same name
	if Register.get_country(str(resource["name"])):
		Debug.log("country already exists: %s" % resource["name"], 1)
		return false

	var country: Country = Country.new(str(resource["name"]))
	if not country_container:
		country_container = Register.get_container(NodeContainers.COUNTRIES)
	country_container.add_child(country)
	return true
