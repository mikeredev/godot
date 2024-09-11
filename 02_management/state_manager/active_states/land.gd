class_name Land extends ActiveState

var start_location: City
var scene: Node


func _init(_start_location: City) -> void:
	name = "LAND"
	start_location = _start_location
	scene = Scene.create(FilePathDB.world["city_scene"])
	var container: NodeContainer = Registry.get_container("Port")
	container.add_child(scene)


func enter() -> void:
	Debug.log("ahoy hoy welcome to %s" % start_location)


func process(delta: float) -> void:
	pass


func exit() -> void:
	pass
