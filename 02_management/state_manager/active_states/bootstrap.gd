class_name Bootstrap extends ActiveState


func _init() -> void:
	self.name = "BOOT"


func enter() -> void:
	ConfigManager.apply_user_settings()
	self.build_tree()
	Debug.log("Bootstrapping complete")
	State.change(Startup.new())


func input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_left"):
		print("left")


func process(_delta: float) -> void:
	pass


func exit() -> void:
	pass


func build_tree() -> void:
	Debug.log("Building node tree")

	# add top-level management nodes
	var root: NodeRoot = Registry.get_root()
	var node_tree: Dictionary = NodeContainerDB.node_tree
	for management_node_key: String in node_tree.keys():
		var management_node_name: String = node_tree[management_node_key].name
		var management_node: NodeContainer = NodeContainer.new(management_node_name)
		root.add_child(management_node)

	# add node-based managers
	var manager_node: NodeContainer = Registry.get_container("Management")
	var state_manager: State = State.new()
	var dialog_manager: Dialog = Dialog.new()
	var time_manager: TimeManager = TimeManager.new()
	manager_node.add_child(state_manager)
	manager_node.add_child(dialog_manager)
	manager_node.add_child(time_manager)

	# add display containers
	var display_container_name: String = node_tree["DISPLAY"].name
	var display_container: NodeContainer = Registry.get_container(display_container_name)
	for subcontainer_name: String in node_tree["DISPLAY"].containers:
		var subcontainer: NodeContainer = NodeContainer.new(subcontainer_name)
		display_container.add_child(subcontainer)


func get_json(file_path: String) -> Dictionary:
	var json: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	var dict: Dictionary = JSON.parse_string(json.get_as_text())
	return dict
