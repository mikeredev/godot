class_name Scene extends RefCounted


static func create(path: String) -> Node:
	var packed_scene: PackedScene = load(path)
	var scene: Node = packed_scene.instantiate()
	Debug.log("new scene instantiated: %s" % scene, 3)
	return scene
