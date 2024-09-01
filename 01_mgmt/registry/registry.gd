extends Node

var containers: Dictionary = {}


func _ready() -> void:
	event.emit_signal(config.signal_db.NODE_READY, self)


func add_container(container: Node) -> void:
	if not containers.has(container):
		containers[container.name] = container
		debug.log(self, "registered container: %s" % container, 3)


func get_container(container_name: String) -> Node:
	if containers.has(container_name):
		return containers[container_name]
	else:
		return null
