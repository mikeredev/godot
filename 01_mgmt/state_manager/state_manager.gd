extends Node

var current_state: ActiveState = null


func _ready() -> void:
	event.emit_signal(config.signal_db.NODE_READY, self)
	#change()

func _input(event: InputEvent) -> void:
	if current_state:
		current_state.input(event)


func change(new_state: ActiveState) -> void:
	if current_state:
		current_state.exit()
		debug.log(self, "exited state: %s" % current_state.name, 3)

	current_state = new_state
	current_state.enter()
	debug.log(self, "entered state: %s" % current_state.name, 3)
