class_name NodeRoot extends Node


func _ready() -> void:
	Debug.log("Ready")
	Registry.add_root(self)
	StateManager.change(InitState.new("INIT"))
