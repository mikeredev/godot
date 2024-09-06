class_name StateManager extends Node

static var current_state: ActiveState = null


func _init(_name: String) -> void:
	name = _name


func _input(event: InputEvent) -> void:
	if current_state:
		current_state.input(event)


static func change(new_state: ActiveState) -> void:
	var active_state: ActiveState

	if current_state:
		current_state.exit()

	active_state = new_state
	current_state = active_state
	active_state.enter()
