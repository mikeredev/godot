class_name Registry extends RefCounted

static var root: NodeRoot
static var player: Player
static var world: World
static var containers: Dictionary = {}
static var countries: Dictionary = {}
static var regions: Dictionary = {}
static var subregions: Dictionary = {}
static var cities: Dictionary = {}

static var hud: HudDisplay

static var current_location: Port
static var city_scene: Control

static func add_root(node: NodeRoot) -> void:
	if not root:
		root = node
		Debug.log("root node registered: %s" % node, 3)


static func add_player(node: Player) -> void:
	if not player:
		player = node
		Debug.log("player registered: %s" % node, 3)


static func add_world(node: World) -> void:
	if not world:
		world = node
		Debug.log("world node registered: %s" % node, 3)


static func add_container(node: NodeContainer) -> void:
	if not containers.has(node):
		containers[node.name] = node
		Debug.log("node container registered: %s" % node, 3)


static func add_country(node: Country) -> void:
	if not countries.has(node):
		countries[node.name] = node
		Debug.log("country registered: %s" % node, 3)


static func add_region(node: Region) -> void:
	if not regions.has(node):
		regions[node.name] = node
		Debug.log("region %d registered: %s" % [node.id, node], 3)


static func add_subregion(node: Subregion) -> void:
	if not subregions.has(node):
		subregions[node.name] = node
		Debug.log("subregion registered: %s" % node, 3)


static func add_city(node: City) -> void:
	if not cities.has(node):
		cities[node.name] = node
		Debug.log("city registered: %s" % node, 3)


static func add_hud(node: HudDisplay) -> void:
	if not hud:
		hud = node
		Debug.log("hud registered: %s" % node, 3)


static func update_current_location(node: Port) -> void:
	current_location = node
	Debug.log("current location updated: %s" % node, 3)


static func add_city_scene(node: Control) -> void:
	if not city_scene:
		city_scene = node
		Debug.log("city scene registered: %s" % node, 3)


static func get_root() -> NodeRoot:
	if not root:
		Debug.log("root node not found in registry", 1)
		return
	return root


static func get_player() -> Player:
	if not player:
		Debug.log("player not found in registry", 1)
		return
	return player


static func get_world() -> World:
	if not world:
		Debug.log("world not found in registry", 1)
		return
	return world


static func get_container(name: String) -> NodeContainer:
	if not containers.has(name):
		Debug.log("node container not registered: %s" % name, 1)
		return null
	return containers[name]


static func get_country(name: String) -> Country:
	if not countries.has(name):
		Debug.log("country not registered: %s" % name, 1)
		return null
	return countries[name]


static func get_region(name: String) -> Region:
	if not regions.has(name):
		Debug.log("region not registered: %s" % name, 1)
		return null
	return regions[name]


static func get_subregion(name: String) -> Subregion:
	if not subregions.has(name):
		Debug.log("subregion not registered: %s" % name, 1)
		return null
	return subregions[name]


static func get_city(name: String) -> City:
	if not cities.has(name):
		Debug.log("city not registered: %s" % name, 1)
		return null
	return cities[name]


static func get_hud() -> HudDisplay:
	if not hud:
		Debug.log("HUD is not registered", 1)
		return null
	return hud

static func get_current_location() -> Port:
	if not current_location:
		Debug.log("no current location set", 1)
		return null
	return current_location


static func get_city_scene() -> Control:
	if not city_scene:
		Debug.log("no city scene registered", 1)
		return null
	return city_scene
