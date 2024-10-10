class_name RecreateEnvironment extends ActiveState

var savedata: Dictionary = {}


func _init(world_savedata: Dictionary) -> void:
	name = "ENV"
	savedata = world_savedata


func enter() -> void:
	#if savedata.has("ships"):
		#if savedata.ships.size() > 0:
			#Debug.log("%d ships to restore" % savedata.ships.size(), 3)
		#else:
			#Debug.log("no ships to restore", 3)

	StateManager.change(AdminMode.new())



#func restore_ships(savedata: Dictionary) -> void:
	#Debug.log(savedata.keys(), 3)
