@tool
class_name Debug extends EditorPlugin

enum LogLevel { VERBOSE, DEBUG, INFO, WARNING, ERROR }

const NAMESPACE: String = "runtime/plugin/debug/log_level"

const COLOR: Dictionary[LogLevel, Color] = {
	LogLevel.VERBOSE: Color.DARK_CYAN,
	LogLevel.DEBUG: Color.WEB_GRAY,
	LogLevel.INFO: Color.CORNSILK,
	LogLevel.WARNING: Color.ORANGE,
	LogLevel.ERROR: Color.RED }

var dock: HBoxContainer

static var threshold: LogLevel = LogLevel.DEBUG
static var history: Dictionary[LogLevel, Array] = {}
static var _state: ActiveCoreState


func _enter_tree() -> void:
	dock = HBoxContainer.new()
	var option: OptionButton = OptionButton.new()
	for severity: String in LogLevel.keys():
		var value: int = LogLevel[severity]
		option.add_item("  %s" % severity.to_pascal_case(), value)
		option.set_item_metadata(value, value)
		if value == threshold:
			option.select(value)
			set_threshold(value)

	option.item_selected.connect(_on_editor_severity_selected)
	dock.add_child(option)
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, dock)


func _exit_tree() -> void:
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, dock)
	dock.queue_free()


static func connect_signals() -> void: # call from Main
	Broadcast.state_entered.connect(_on_state_entered)


static func log_verbose(p_text: Variant) -> void:
	_notify(str(p_text), LogLevel.VERBOSE)


static func log_debug(p_text: Variant) -> void:
	_notify(str(p_text), LogLevel.DEBUG)


static func log_info(p_text: Variant) -> void:
	_notify(str(p_text), LogLevel.INFO)


static func log_warning(p_text: Variant, p_metadata: Dictionary = {}) -> bool:
	_notify(str(p_text), LogLevel.WARNING, p_metadata)
	_send_notification(str(p_text))
	push_warning(str(p_text))
	return false


static func log_error(p_text: Variant, p_fatal: bool = false, p_metadata: Dictionary = {}) -> bool:
	_notify(str(p_text), LogLevel.ERROR, p_metadata)
	_send_notification(str(p_text))
	push_error(str(p_text))
	if p_fatal:
		assert(false, str(p_text))
	return false


static func set_threshold(p_threshold: LogLevel) -> void:
	var out: String = "Set log threshold %d: %s" % [p_threshold, Debug.LogLevel.keys()[p_threshold]]
	threshold = p_threshold
	ProjectSettings.set_setting(NAMESPACE, threshold)
	Debug.log_info(out)


static func _notify(p_text: Variant, p_severity: LogLevel, p_metadata: Dictionary = {}) -> void:
	if p_severity < threshold: return
	var color: Color = _get_color(p_severity)
	var timestamp: String = _get_timestamp()
	var state: String = _get_state_name()
	var text: String = _get_text(p_text)
	var result: String = "%s | %s | [color=%s]%s[/color]" % [timestamp, state, color.to_html(), text ]
	print_rich(result)
	_update_history(timestamp, result, p_severity, p_metadata)


static func _get_color(p_severity: LogLevel) -> Color:
	return COLOR.get(p_severity)


static func _get_state_name() -> String:
	var color: Color = Color.DIM_GRAY
	var state_name: String = "NONE"
	if _state:
		match _state.type:
			ActiveCoreState.Type.PHASE_INIT:
				color = Color.CYAN
				state_name = "INIT"
			ActiveCoreState.Type.PHASE_STAGE:
				color = Color.YELLOW
				state_name = "STAGE"
			ActiveCoreState.Type.PHASE_START:
				color = Color.MEDIUM_PURPLE
				state_name = "START"
			ActiveCoreState.Type.PHASE_BUILD:
				color = Color.LIME_GREEN
				state_name = "BUILD"
			ActiveCoreState.Type.PHASE_CONFIGURE:
				color = Color.SKY_BLUE
				state_name = "CONF"
			ActiveCoreState.Type.PHASE_SIMULATE:
				color = Color.NAVAJO_WHITE
				state_name = "SIM"
			ActiveCoreState.Type.PHASE_READY:
				color = Color.CORAL
				state_name = "READY"
			ActiveCoreState.Type.IN_CITY:
				color = Color.BISQUE
				state_name = "INCITY"
			ActiveCoreState.Type.AT_SEA:
				color = Color.DEEP_SKY_BLUE
				state_name = "ATSEA"
	return "[color=%s]%s[/color]" % [color.to_html(), state_name]


static func _get_text(p_text: Variant) -> String:
	return str(p_text)


static func _get_timestamp() -> String:
	return str(Time.get_ticks_msec())


func _on_editor_severity_selected(p_index: LogLevel) -> void:
	set_threshold(p_index)
	ProjectSettings.save() # only save from within editor


static func _on_state_entered(p_state: ActiveCoreState) -> void:
	_state = p_state


static func _send_notification(p_text: String) -> void:
	Broadcast.notify_send.emit(p_text)


static func _update_history(p_timestamp: String, p_text: String, p_severity: LogLevel, p_metadata: Dictionary = {}) -> void:
	var data: Dictionary = {
		"timestamp": p_timestamp,
		"text": p_text,
		"severity": p_severity,
		"metadata": p_metadata }

	if not history.has(p_severity):
		history[p_severity] = []

	var log: Array = history[p_severity]
	log.append(data)
