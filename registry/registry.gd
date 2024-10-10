class_name Registry extends RefCounted

static var main: Node:
	set(node):
		main = node
		Debug.log("registered main: %s" % main, 3)

static var world: World:
	set(node):
		world = node
		Debug.log("registered world: %s" % world, 3)

static var containers: Dictionary = {}
static var regions: Dictionary = {}
static var subregions: Dictionary = {}
static var cities: Dictionary = {}
static var countries: Dictionary = {}


static func add_container(node: Node) -> void:
	if containers.has(node.name):
		Debug.log("container already registered: %s" % node.name, 2)
	else:
		containers[node.name] = node
		Debug.log("registered container: %s" % node, 3)


static func add_region(node: Region) -> void:
	if not regions.has(node.name):
		regions[node.name] = node
		return
	Debug.log("region already registered: %s" % node.name, 2)


static func add_subregion(node: Subregion) -> void:
	if not subregions.has(node.name):
		subregions[node.name] = node
		return
	Debug.log("subregion already registered: %s" % node.name, 2)


static func add_city(node: City) -> void:
	if not cities.has(node.name):
		cities[node.name] = node
		return
	Debug.log("city already registered: %s" % node.name, 2)


static func add_country(node: Country) -> void:
	if not countries.has(node.name):
		countries[node.name] = node
		return
	Debug.log("country already registered: %s" % node.name, 2)


static func get_container(node_name: String) -> Node:
	if containers.has(node_name):
		return containers[node_name]
	else:
		Debug.log("container not registered: %s" % node_name, 3)
		return null


static func get_region(node_name: String) -> Region:
	if regions.has(node_name):
		return regions[node_name]
	else:
		Debug.log("region not registered: %s" % node_name, 3)
		return null


static func get_subregion(node_name: String) -> Subregion:
	if subregions.has(node_name):
		return subregions[node_name]
	else:
		Debug.log("subregion not registered: %s" % node_name, 3)
		return null


static func get_city(node_name: String) -> City:
	if cities.has(node_name):
		return cities[node_name]
	else:
		Debug.log("city not registered: %s" % node_name, 3)
		return null


static func get_country(node_name: String) -> Country:
	if countries.has(node_name):
		return countries[node_name]
	else:
		Debug.log("country not registered: %s" % node_name, 3)
		return null


static func remove_region(node: Region) -> void:
	if regions.has(node.name):
		regions.erase(node.name)


static func remove_subregion(node: Subregion) -> void:
	if subregions.has(node.name):
		subregions.erase(node.name)


static func remove_city(node: City) -> void:
	if cities.has(node.name):
		cities.erase(node.name)


static func remove_country(node: Country) -> void:
	if countries.has(node.name):
		countries.erase(node.name)
