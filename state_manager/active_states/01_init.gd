class_name Init extends ActiveState

var main: Node:
	get():
		if not main:
			main = Registry.main
		return main


func _init() -> void:
	name = "INIT"


func enter() -> void:
	main = Registry.main

	Debug.log("Applying configuration")
	ConfigManager.apply()

	Debug.log("Creating node tree")
	self.create_node_tree()

	## ready
	StateManager.change(LoadMods.new())


func create_node_tree() -> void:
	var management: NodeContainer = NodeContainer.new("Management")
	main.add_child(management)

	var state_manager: StateManager = StateManager.new() # requires _process
	management.add_child(state_manager)

	TimeManager.setup(management) # adds WorldClock timer to management node

	var world: World = World.new()
	main.add_child(world)

	var display: ControlContainer = ControlContainer.new("Display")
	display.set_anchors_preset(Control.PRESET_FULL_RECT)
	main.add_child(display)

	var display_containers: PackedStringArray = [ "Splash", "Menu", "Admin" ]
	for display_container_name: String in display_containers:
		var display_container: ControlContainer = ControlContainer.new(display_container_name)
		display_container.set_anchors_preset(Control.PRESET_FULL_RECT)
		display_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
		display.add_child(display_container)
