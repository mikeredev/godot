class_name SaveManager extends RefCounted

static var world: World:
	get():
		if not world:
			world = Registry.world
		return world

static var metadata: Dictionary = {} # holds dictionary that will be saved


static func save_world() -> void:
	# get world metadata
	var saved_game: SavedGame = SavedGame.new()
	world.metadata.timestamp = TimeManager.get_iso_timestamp()
	saved_game.metadata = world.metadata

	# pass this dictionary to each node in the savedata group for completion
	var savedata: Dictionary = {
		"ships": {}
	}
	var main: Node = Registry.main
	main.get_tree().call_group("savedata", "get_savedata", savedata)
	saved_game.savedata = savedata

	ResourceSaver.save(saved_game, "res://_save.tres")
	print("Saved")


static func load_world() -> void:
	var saved_game: SavedGame = load("res://_save.tres") as SavedGame
	var saved_game_mod_list: Dictionary = saved_game.metadata.mod_list
	var save_game_mods: PackedStringArray = []

	for mod_directory: String in saved_game_mod_list.keys():
		save_game_mods.append(mod_directory)

	if save_game_mods == ModManager.active_mods:
		world.metadata = saved_game.metadata
		world.savedata = saved_game.savedata
		Debug.log("Loading saved profile")
		StateManager.change(CreateWorld.new())
	else:
		Debug.log("This save requires the following mods loaded: %s" % str(saved_game_mod_list.keys()), 1)


static func quick_load() -> void:
	Debug.log("Preparing to quick load saved profile")
	world = Registry.world
	var count_removed_display: int = 0
	var count_removed_country: int = 0
	var count_removed_region: int = 0
	var count_removed_subregion: int = 0
	var count_removed_city: int = 0
	var count_removed_ship: int = 0
	var count_removed_routes: int = 0

	var display_container: ControlContainer = Registry.get_container("Display") # clear all UI content
	for top_level: ControlContainer in display_container.get_children():
		for child: Node in top_level.get_children():
			top_level.remove_child(child)
			child.queue_free()
			count_removed_display += 1

	for top_level: Node in world.get_children(): # top levels (map and world objects)
		if top_level is TextureRect: # map
			var map: TextureRect = top_level
			map.texture = null

		for child: Node in top_level.get_children(): # empty all containers
			if child is Country:
				count_removed_country += 1
			elif child is Region:
				count_removed_region += 1
			elif child is Subregion:
				count_removed_subregion += 1
			elif child is City:
				count_removed_city += 1
			elif child is Ship:
				count_removed_ship += 1
			elif child is Line2D:
				count_removed_routes += 1
			else:
				Debug.log("Unexpected node found while quick loading: %s" % child, 2)

			top_level.remove_child(child)
			child.queue_free()

	Debug.log("cleaned up (%d display), (%d country), (%d region), (%d subregion), (%d city), (%d ship), (%d lanes)" % [count_removed_display, count_removed_country, count_removed_region, count_removed_subregion, count_removed_city, count_removed_ship, count_removed_routes], 3)
	load_world()
