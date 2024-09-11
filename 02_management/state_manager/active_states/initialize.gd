class_name Initialize extends ActiveState

var countries: Array[CountryResource]
var cities: Array[CityResource]
var player_name: String
var country_name: String
var start_location: City


func _init(_countries: Array[CountryResource],
			_cities: Array[CityResource],
			_player_name: String,
			_country_name: String) -> void:
	self.name = "INIT"
	countries = _countries
	cities = _cities
	player_name = _player_name
	country_name = tr(_country_name)


func enter() -> void:
	Debug.log("Lod core mod resouces")
	var world_file_path: String = FilePathDB.world["root"]
	var world: World = Scene.create(world_file_path)
	world._country_tres_resources = countries
	world._city_tres_resources = cities
	var container: NodeContainer = Registry.get_container("Data")
	container.add_child(world)

	Debug.log("Load custom mod resouces")
	load_custom_content()

	Debug.log("Building overworld")
	var overworld_file_path: String = FilePathDB.world["overworld"]
	var overworld: Overworld = Scene.create(overworld_file_path)
	overworld.visible = false
	container = Registry.get_container("Overworld")
	container.add_child(overworld)
	overworld.setup()

	Debug.log("Setting up HUD", 3)
	var hud_file_path: String = FilePathDB.system["hud"]
	var hud: HudDisplay = Scene.create(hud_file_path)
	container = Registry.get_container("HUD")
	container.add_child(hud)
	Registry.add_hud(hud)

	Debug.log("Creating %s %s" % [player_name, country_name])
	create_player()

	Debug.log("Doing location stuff")
	Debug.log("loading subregion: %s" % start_location.subregion, 3)
	## sub/region needs reference to world map anchor and coord offsets

	Debug.log("Starting time manager")
	TimeManager.start()

	Debug.log("Ready!")
	#State.change(Land.new(start_location))


func load_custom_content() -> void:
	var custom_content: PackedStringArray = [ "country", "city", "item" ]
	var core_mod_folder: String = FilePathDB.content["custom"]
	var content_folder: String
	for content: String in custom_content:
		content_folder =  core_mod_folder + content + "/"
		var dir: DirAccess = DirAccess.open(content_folder)
		if dir:
			var _do: int = dir.list_dir_begin()
			var file_name: String = dir.get_next()
			while file_name != "":
				if not dir.current_is_dir() and file_name.ends_with(".tres"):
					var resource_path: String = content_folder + file_name
					var country_resource: CountryResource = load(resource_path) as CountryResource
					countries.append(country_resource)
				file_name = dir.get_next()
			dir.list_dir_end()
		else:
			Debug.log("no mods found at: " + content_folder, 3)


func create_player() -> void:
	var player: Player = Scene.create(FilePathDB.player)
	var player_container: NodeContainer = Registry.get_container("Player")
	player_container.add_child(player)

	var country: Country = Registry.get_country(country_name)
	start_location = Registry.get_city(country.capital.name)

	player.create(player_name, country, start_location)


func exit() -> void:
	pass
