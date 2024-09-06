class_name SceneManager extends RefCounted


static func create(path: String) -> Node:
	var packed_scene: PackedScene = load(path)
	var scene: Node = packed_scene.instantiate()
	Debug.log("new scene instantiated: %s" % scene)
	return scene


static func add(scene: Node, container: NodeContainer) -> void:
	container.add_child(scene)
