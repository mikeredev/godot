@tool
extends EditorPlugin

const KEY_ASTAR: Key = KEY_F11
const KEY_AUTOSTART: Key = KEY_F12

var astar: String = Env.DEBUG_ASTAR_ENABLED
var autostart: String = Env.DEBUG_AUTOSTART_ENABLED

var nav_main: HBoxContainer
var ui_astar: Button
var ui_autostart: Button


func _enter_tree() -> void:
	nav_main = HBoxContainer.new()
	_create_astar_button()
	_create_autostart_button()
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, nav_main)


func _exit_tree() -> void:
	if nav_main:
		remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, nav_main)
		nav_main.queue_free()


func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ASTAR):
		ui_astar.button_pressed = !ui_astar.button_pressed

	if Input.is_key_pressed(KEY_AUTOSTART):
		ui_autostart.button_pressed = !ui_autostart.button_pressed


func set_astar(p_toggled: bool) -> void:
	ProjectSettings.set_setting(astar, p_toggled)
	ProjectSettings.save()
	Debug.log_debug("Set A*: %s (effective on next project run)" % p_toggled)


func set_autostart(p_toggled: bool) -> void:
	ProjectSettings.set_setting(autostart, p_toggled)
	ProjectSettings.save()
	Debug.log_debug("Set autostart: %s (effective on next project run)" % p_toggled)


func _create_astar_button() -> void:
	ui_astar = Button.new()
	ui_astar.toggle_mode = true
	ui_astar.button_pressed = ProjectSettings.get_setting(astar, false)
	ui_astar.text = "A*"
	ui_astar.toggled.connect(set_astar)
	nav_main.add_child(ui_astar)


func _create_autostart_button() -> void:
	ui_autostart = Button.new()
	ui_autostart.toggle_mode = true
	ui_autostart.button_pressed = ProjectSettings.get_setting(autostart, false)
	ui_autostart.text = "AUTO"
	ui_autostart.toggled.connect(set_autostart)
	nav_main.add_child(ui_autostart)
