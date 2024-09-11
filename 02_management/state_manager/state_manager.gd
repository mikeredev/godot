class_name State extends Node

static var current_state: ActiveState = null


func _init() -> void:
	self.name = "StateManager"


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
