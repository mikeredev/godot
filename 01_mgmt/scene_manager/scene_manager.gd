extends Node


func _ready() -> void:
	event.emit_signal(config.signal_db.NODE_READY, self)


func add(filepath: String) -> Node:
	var packed_scene: PackedScene = load(filepath)
	var new_scene: Node = packed_scene.instantiate()
	return new_scene


func create(new_scene: Node, container: Node) -> void:
	container.add_child(new_scene)
