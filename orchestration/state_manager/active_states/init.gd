class_name InitState extends ActiveState


func _init(_name: String) -> void:
	name = _name


func enter() -> void:
	build_tree()
	ConfigManager.apply_user_settings()
	Dialog.info("info panel")
	Dialog.confirm("confirm?", exit)


func process(_delta: float) -> void:
	pass


func exit() -> void:
	pass


func build_tree() -> void:
	# add top-level management nodes
	var root: NodeRoot = Registry.get_root()
	var node_tree: Dictionary = NodeContainerDB.node_tree
	for management_node_key: String in node_tree.keys():
		var management_node_name: String = node_tree[management_node_key].name
		var management_node: NodeContainer = NodeContainer.new(management_node_name)
		root.add_child(management_node)

	# add display containers
	var display_container_name: String = node_tree["DISPLAY"].name
	var display_container: NodeContainer = Registry.get_container(display_container_name)
	for subcontainer_name: String in node_tree["DISPLAY"].containers:
		var subcontainer: NodeContainer = NodeContainer.new(subcontainer_name)
		display_container.add_child(subcontainer)
