class_name StartMenu extends ActiveState


func _init() -> void:
	name = "START"


func enter() -> void:
	SceneManager.produce("res://05_entity/menu/start.tscn", "Menu")


func exit() -> void:
	SceneManager.empty_container("Menu")
