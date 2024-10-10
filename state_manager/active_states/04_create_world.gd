class_name CreateWorld extends ActiveState

var world: World:
	get():
		if not world:
			world = Registry.world
		return world

var astar_dict: Dictionary = world.metadata.astar
var weights_dict: Dictionary = world.metadata.weights
var region_dict: Dictionary = world.metadata.regions
var cities_dict: Dictionary = world.metadata.cities
var countries_dict: Dictionary = world.metadata.countries
var trade_items_dict: Dictionary = world.metadata.trade_items


func _init() -> void:
	name = "CREATE"


func enter() -> void:
	Debug.log("Creating world from metadata")

	set_trade_items(trade_items_dict)

	set_map_texture(str(world.metadata.map))

	set_astar(astar_dict)

	#set_weights(weights_dict)

	set_regions(region_dict)

	#var subregion_dict: Dictionary = world.metadata.subregions
	#set_subregions(subregion_dict)

	set_cities(cities_dict)

	set_countries(countries_dict)

	set_city_ruler(cities_dict)

	TimeManager.start(str(world.metadata.timestamp))

	StateManager.change(RecreateEnvironment.new(world.savedata))


func set_trade_items(trade_items: Dictionary) -> void:
	for trade_item_name: String in trade_items.keys():
		var trade_item: TradeItem = TradeItem.new(trade_item_name, trade_items[trade_item_name]["base_price"])
		world.trade_items[trade_item_name] = trade_item
	Debug.log("processed %d trade items" % trade_items.size(), 3)


func set_map_texture(map: String) -> void:
	if map.begins_with("res://"):
		world.map.texture = load(map) as Texture2D
	else:
		var image: Image = Image.new()
		image.load(map)
		world.map.texture = ImageTexture.create_from_image(image) as Texture2D
	Debug.log("created map texture from: %s" % map, 3)


func set_astar(grid: Dictionary) -> void:
	world.astar = AStarGrid2D.new()
	world.astar.region = Rect2i(0, 0, world.map.texture.get_width(), world.map.texture.get_height())
	world.astar.default_compute_heuristic = grid["compute"]
	world.astar.default_estimate_heuristic = grid["estimate"]
	world.astar.diagonal_mode = grid["diagonal"]
	world.astar.jumping_enabled = grid["jumping"]
	world.astar.update()
	Debug.log("set A* using compute %d, estimate %d, diagonal %d, jumping %s" % [world.astar.default_compute_heuristic, world.astar.default_estimate_heuristic, world.astar.diagonal_mode, world.astar.jumping_enabled], 3)


func set_weights(weights: Dictionary) -> void:
	var image: Image = world.map.texture.get_image()
	var width: int = image.get_width()
	var height: int = image.get_height()
	var pixels_land: int = 0
	var pixels_border: int = 0
	var pixels_ocean: int = 0
	var pixels_coastal: int = 0
	var pixels_waypoint: int = 0

	for x: int in range(width):
		for y: int in range(height):
			var color: Color = image.get_pixel(x, y)
			var point: Vector2i = Vector2i(x, y)

			if color == Color(str(weights["land"])):
				world.astar.set_point_solid(point, true)
				pixels_land += 1

			if color == Color(str(weights["border"])):
				world.astar.set_point_solid(point, true)
				pixels_border += 1

			if color == Color(str(weights["ocean"])):
				world.astar.set_point_weight_scale(point, 1)
				pixels_ocean += 1

			if color == Color(str(weights["coastal"])):
				world.astar.set_point_weight_scale(point, 1.3)
				pixels_coastal += 1

			if color == Color(str(weights["waypoint"])):
				world.astar.set_point_weight_scale(point, 0.1)
				pixels_waypoint += 1

	Debug.log("set weights: land %d, border %d, ocean %d, coastal %d, waypoint %d " % [pixels_land, pixels_border, pixels_ocean, pixels_coastal, pixels_waypoint], 3)


func set_regions(regions: Dictionary) -> void:
	var regions_container: Node2DContainer = Registry.get_container("Regions")

	for region_name: String in regions.keys():
		var region: Region = Region.new(region_name)
		regions_container.add_child(region)

		region.collision_layer = 3 # region
		region.collision_mask = 4 # player(1) + city(16)

		var hitbox: CollisionPolygon2D = CollisionPolygon2D.new()
		hitbox.name = "Hitbox"
		hitbox.build_mode = CollisionPolygon2D.BUILD_SOLIDS
		region.add_child(hitbox)
		region.hitbox = hitbox

		var area: PackedVector2Array
		var json: Array = regions[region_name]["area"]
		for pos: Array in json:
			var pos_x: int = pos[0]
			var pos_y: int = pos[1]
			var vector: Vector2i = Vector2i(pos_x, pos_y)
			area.append(vector)
		region.hitbox.polygon = area

	Debug.log("created %d regions" % regions.size(), 3)


func set_subregions() -> void:
	var subregions: Dictionary = world.metadata.subregions
	var subregions_container: Node2DContainer = Registry.get_container("Subregions")

	for subregion_name: String in subregions.keys():
		# Create new subregion
		var subregion: Subregion = Subregion.new(subregion_name)
		subregions_container.add_child(subregion)

		# Subregions should collide with [city?]
		subregion.collision_layer = 4 # subregion
		subregion.collision_mask = 5 # city

		var hitbox: CollisionPolygon2D = CollisionPolygon2D.new() # configured by mod manager
		hitbox.name = "Hitbox"
		hitbox.build_mode = CollisionPolygon2D.BUILD_SOLIDS
		subregion.add_child(hitbox)
		subregion.hitbox = hitbox

		var area: PackedVector2Array
		var json: Array = subregions[subregion_name]["area"]
		for pos: Array in json:
			var pos_x: int = pos[0]
			var pos_y: int = pos[1]
			var vector: Vector2i = Vector2i(pos_x, pos_y)
			area.append(vector)
		subregion.hitbox.polygon = area

	Debug.log("created %d subregions" % subregions.size(), 3)


func set_cities(cities: Dictionary) -> void:
	var cities_container: Node2DContainer = Registry.get_container("Cities")
	for city_name: String in cities.keys():
		#  create new City
		var city: City = City.new(city_name)
		cities_container.add_child(city)

		# set its position from mod metadata
		var city_pos: Array = world.metadata.cities[city_name].position
		var city_pos_x: float = city_pos[0]
		var city_pos_y: float = city_pos[1]
		city.position = Vector2(city_pos_x, city_pos_y)
		world.astar.set_point_solid(city.position, false)

		# city should collide with player and NPC ships
		city.collision_layer = 5 # city
		city.collision_mask = 3 # player (1) + NPC (2)

		# create small visual representation on map
		var marker: ColorRect = ColorRect.new()
		marker.color = Color(0, 0, 1)
		marker.size = Vector2(1, 1)
		marker.name = "Marker"
		city.add_child(marker)
		marker.position = marker.position - Vector2(marker.size / 2)
		city.marker = marker

		# create hitbox for collisions
		var hitbox: CollisionShape2D = CollisionShape2D.new()
		var hitbox_shape: CircleShape2D = CircleShape2D.new()
		hitbox_shape.radius = 1
		hitbox.shape = hitbox_shape
		hitbox.name = "Hitbox"
		city.add_child(hitbox)
		hitbox.position = hitbox.position + Vector2(marker.size / 2)
		city.hitbox = hitbox

		# add trade resources (uses dict, not array[tradeitem])
		var city_dict: Dictionary = cities[city_name]
		if city_dict.has("trade_items"):
			var rand_1: float = randf_range(1.0, 1.9)
			var rand_2: float = randf_range(0.1, 0.9)
			for trade_item_name: String in cities[city_name]["trade_items"]:
				city.trade_items[trade_item_name] = {
					"base_price": world.trade_items[trade_item_name]["base_price"],
					"buy_price": (world.trade_items[trade_item_name]["base_price"] * rand_1),
					"sale_price": (world.trade_items[trade_item_name]["base_price"] * rand_2),
				}

	Debug.log("created %d cities" % cities.size(), 3)


func set_countries(countries: Dictionary) -> void:
	var countries_container: Node2DContainer = Registry.get_container("Countries")

	for country_name: String in countries.keys():
		var country: Country = Country.new(country_name)
		countries_container.add_child(country)

		var capital_name: String = countries[country_name]["capital"]
		var capital: City = Registry.get_city(capital_name)
		if capital.is_capital:
			Debug.log("cannot reassign capital %s to: %s" % [capital, country], 2)
			return
		else:
			var color: String = countries[country_name]["color"]
			country.capital = capital
			country.color = color
			capital.marker.color = color
			capital.is_capital = true
			capital.ruler = country

	Debug.log("created %d countries" % countries.size(), 3)


func set_city_ruler(cities: Dictionary) -> void:
	var count_neutral: int = 0
	for city_name: String in cities.keys():
		var city: City = Registry.get_city(city_name)

		if city.is_capital:
			city.influence[city.ruler.name] = 100
			city.ruler.cities.append(city)

		else:
			var city_metadata: Dictionary = cities[city_name]
			if city_metadata.has("ruler"):
				var ruler_name: String = cities[city_name].ruler
				var ruler: Country = Registry.get_country(ruler_name)
				city.ruler = ruler
				city.influence[city.ruler.name] = randi_range(75, 95)
				city.ruler.cities.append(city)
			else:
				count_neutral += 1

	Debug.log("processed influence dict for %d cities (%d neutral)" % [cities.size(), count_neutral], 3)
