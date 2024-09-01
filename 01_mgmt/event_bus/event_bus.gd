extends Node

signal node_ready


func _ready() -> void:
	node_ready.connect(_on_node_ready)
	event.emit_signal("node_ready", self)


func _on_node_ready(node: Node) -> void:
	debug.log(node, "ready", 3)
