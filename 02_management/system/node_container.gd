class_name NodeContainer extends Node


func _init(_name: String) -> void:
	name = _name


func _ready() -> void:
	Registry.add_container(self)
