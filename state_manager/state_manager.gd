class_name StateManager extends Node

static var current_state: ActiveState = null


func _init(node_name: String = "StateManager") -> void:
	name = node_name


func _ready() -> void:
	Debug.log("added state manager: %s" % self, 3)


func _process(delta: float) -> void:
	if current_state:
		current_state._process(delta)


func _input(event: InputEvent) -> void:
	if current_state:
		current_state.input(event)


static func change(new_state: ActiveState) -> void:
	if current_state:
		current_state.exit()

	current_state = new_state
	current_state.enter()
