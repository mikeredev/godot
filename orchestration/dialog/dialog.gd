class_name Dialog extends Node

enum Notice { INFO, WARN, ERROR, CONFIRM }
static var scene_root: Control
static var _connect: int


func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("ui_cancel") and scene_root:
		close_scene_root()


static func load_dialog(notice: Notice) -> void:
	var panel: MarginContainer
	scene_root = SceneManager.create(FilePathDB.system["notification"])
	var dialogue_container: NodeContainer = Registry.get_container("Dialogue")
	SceneManager.add(scene_root, dialogue_container)
	scene_root.process_mode = Node.PROCESS_MODE_ALWAYS

	for child: MarginContainer in scene_root.get_children():
		child.visible = false

	match notice:
		Notice.INFO:
			panel = scene_root.get_node("%MarginContainerInfo")
		Notice.WARN:
			pass
		Notice.ERROR:
			pass
		Notice.CONFIRM:
			panel = scene_root.get_node("%MarginContainerConfirm")
	panel.visible = true


static func info(message: String) -> void:
	load_dialog(Notice.INFO)
	var label_info = scene_root.get_node("%LabelInfo")
	#label_info.custom_minimum_size.x = 400
	label_info.text = message


static func confirm(
	message: String,
	confirm_action: Callable,
	cancel_action: Callable = close_scene_root) -> void:

	load_dialog(Notice.CONFIRM)

	var button_confirm: Button = scene_root.get_node("%ButtonConfirm")
	_connect = button_confirm.connect("button_up", confirm_action)

	var button_cancel: Button = scene_root.get_node("%ButtonCancel")
	_connect = button_cancel.connect("button_up", cancel_action)

	var label_confirm: Label = scene_root.get_node("%LabelConfirm")
	label_confirm.text = message


static func close_scene_root() -> void:
	if scene_root.get_tree().paused == true:
		scene_root.get_tree().paused = false
	scene_root.queue_free()
	scene_root = null
