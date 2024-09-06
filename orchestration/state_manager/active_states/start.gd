class_name StartState extends ActiveState


func _init(_name: String) -> void:
	name = _name


func enter() -> void:
	Debug.log("hi from start")


func process(delta: float) -> void:
	pass


func exit() -> void:
	Debug.log("bye from start")
