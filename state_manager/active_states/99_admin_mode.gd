class_name AdminMode extends ActiveState


func _init() -> void:
	name = "ADMIN"


func enter() -> void:
	SceneManager.produce("res://05_entity/panel/admin.tscn", "Admin")


func process(_delta: float) -> void:
	pass


func exit() -> void:
	pass
