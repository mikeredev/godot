@tool
extends EditorPlugin

const ADDONS: String = "res://addons" # no trailing slash
const NAME: String = "Plugins" # short name displayed in editor tab
const SELF: String = "plugin_toggle" # matches dir in addons/

var nav_main: VBoxContainer
var nav_content: Tree


func _enter_tree() -> void:
	Debug.log_debug("Started plugin: %s" % SELF.to_upper())
	nav_main = VBoxContainer.new()
	nav_main.size_flags_vertical = Control.SIZE_EXPAND_FILL
	nav_main.name = NAME

	var hbox: HBoxContainer = HBoxContainer.new()
	hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	nav_main.add_child(hbox)

	var label: Label = Label.new()
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.text = "Available plugins:"
	hbox.add_child(label)

	var reload_button: Button = Button.new()
	reload_button.text = "Refresh"
	reload_button.pressed.connect(refresh)
	hbox.add_child(reload_button)

	nav_content = Tree.new()
	nav_content.size_flags_vertical = Control.SIZE_EXPAND_FILL
	nav_content.name = SELF.to_pascal_case()
	nav_content.item_edited.connect(_on_plugin_toggled)
	nav_content.hide_root = true
	nav_content.columns = 1
	nav_main.add_child(nav_content)

	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UL, nav_main)

	await nav_main.get_tree().process_frame # let other plugins start

	configure()


func _exit_tree() -> void:
	if nav_main:
		remove_control_from_docks(nav_main)
		nav_main.queue_free()
		Debug.log_debug("Stopped plugin: %s" % SELF.to_upper())


func configure() -> void:
	var root: TreeItem = nav_content.create_item()
	var addons: PackedStringArray = _get_plugins()
	addons.sort()
	for plugin: String in addons:
		if plugin == SELF: continue
		var item: TreeItem = nav_content.create_item(root)
		var cfg: ConfigFile = _get_config("res://addons/%s/plugin.cfg" % plugin)
		item.set_cell_mode(0, TreeItem.CELL_MODE_CHECK)
		item.set_checked(0, EditorInterface.is_plugin_enabled(plugin))
		item.set_text(0, cfg.get_value("plugin", "name"))
		item.set_editable(0, true)
		item.set_metadata(0, plugin)
		#if EditorInterface.is_plugin_enabled(plugin):
		#	item.set_custom_bg_color(0, Color(0.1, 0.5, 0.1, 0.2))


func refresh() -> void:
	Debug.log_info("Refreshing plugin list...")
	nav_content.clear()
	configure()


func _get_config(p_path: String) -> ConfigFile:
	var config: ConfigFile = ConfigFile.new()
	var err: Error = config.load(p_path)
	if err != OK: Debug.log_error("Failed to load: %s" % p_path)
	return config


func _get_plugins() -> PackedStringArray:
	var plugins: PackedStringArray = []
	var addons: PackedStringArray = DirAccess.get_directories_at(ADDONS)
	for plugin: String in addons:
		var plugin_cfg: String = "%s/%s/plugin.cfg" % [ADDONS, plugin]
		if FileAccess.file_exists(plugin_cfg): plugins.append(plugin)
	return plugins


func _on_plugin_toggled() -> void:
	var item: TreeItem = nav_content.get_edited()
	var plugin_name: String = item.get_metadata(0)
	var should_enable: bool = item.is_checked(0)
	EditorInterface.set_plugin_enabled(plugin_name, should_enable)
	Debug.log_info("Plugin %s enabled: %s" % [plugin_name.to_upper(), should_enable])
