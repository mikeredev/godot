class_name Startup extends ActiveState

var scene: Node
static var countries: Array[CountryResource] = []
static var cities: Array[CityResource] = []


func _init() -> void:
	self.name = "START"


func enter() -> void:
	var container: NodeContainer = Registry.get_container("Menu")
	var scene_path: String = FilePathDB.menu["new_profile"]
	scene = Scene.create(scene_path)
	container.add_child(scene)


func process(_delta: float) -> void:
	pass


func exit() -> void:
	scene.queue_free()


static func get_country_resources() -> Array[CountryResource]:
	var core_mod_folder: String = FilePathDB.content["core"]
	var countries_folder: String = core_mod_folder + "country/"
	var dir: DirAccess = DirAccess.open(countries_folder)
	if dir:
		var _do: int = dir.list_dir_begin()
		var file_name: String = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".tres"):
				var resource_path: String = countries_folder + file_name
				var country_resource: CountryResource = load(resource_path) as CountryResource
				countries.append(country_resource)
			file_name = dir.get_next()
		dir.list_dir_end()
		return countries
	else:
		Debug.log("failed to open core mod directory: " + countries_folder, 2)
		return []


static func get_city_resources() -> Array[CityResource]:
	var core_mod_folder: String = FilePathDB.content["core"]
	var cities_folder: String = core_mod_folder + "city/"
	var dir: DirAccess = DirAccess.open(cities_folder)
	if dir:
		var _do: int = dir.list_dir_begin()
		var file_name: String = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".tres"):
				var resource_path: String = cities_folder + file_name
				var city_resource: CityResource = load(resource_path) as CityResource
				cities.append(city_resource)
			file_name = dir.get_next()
		dir.list_dir_end()
		return cities
	else:
		Debug.log("failed to open core mod directory: " + cities_folder, 2)
		return []
