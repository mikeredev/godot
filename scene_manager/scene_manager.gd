class_name SceneManager extends Node


func _init() -> void:
	name = "SceneManager"


func _ready() -> void:
	Debug.log("added scene manager: %s" % self, 3)


static func create(file_path: String) -> Node:
	var packed_scene: PackedScene = load(file_path)
	var scene: Node = packed_scene.instantiate()
	Debug.log("instantiated scene: %s" % scene, 3)
	return scene


static func produce(file_path: String, container_name: String) -> void:
	var scene: Node = create(file_path)
	var container: Node = Registry.get_container(container_name)
	container.add_child(scene)


static func empty_container(container_name: String) -> void:
	var container: ControlContainer = Registry.get_container(container_name)
	for child: Control in container.get_children():
		container.remove_child(child)
		child.queue_free()



## threaded loading, wip
#static var is_loading: bool = false
#static var scene_path: String
#static var loaded_scene: PackedScene
#static var load_progress: Array = []
#var load_status: int
#
#
#static func start_threaded_load(path: String) -> void:
	#ResourceLoader.load_threaded_request(path)
	#scene_path = path
	#is_loading = true
#
#
#static func get_loaded_scene() -> PackedScene:
	#return loaded_scene
#
#
#func _process(_delta: float) -> void:
	#if not is_loading:
		#return
#
	#load_status = ResourceLoader.load_threaded_get_status(scene_path, load_progress)
#
	#if load_progress.size() > 0:
		#print(load_progress[0])
#
	#if load_status == ResourceLoader.THREAD_LOAD_LOADED:
		#loaded_scene = ResourceLoader.load_threaded_get(scene_path)
		#print("done")
		#is_loading = false
