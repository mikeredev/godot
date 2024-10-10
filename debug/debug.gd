class_name Debug extends RefCounted


static func log(message: Variant, log_level: int = 0, current_state: String = "NONE", in_game_time: String = "N/A") -> void:
	var ticks: int = Time.get_ticks_msec()

	if StateManager.current_state:
		current_state = StateManager.current_state.name

	if TimeManager.get_iso_timestamp():
		in_game_time = TimeManager.get_iso_timestamp()

	match log_level:
		0:
			print_rich("[color=white]INFO | %d | %s | %s[/color]" % [ticks, current_state, str(message)])
		1:
			print_rich("[color=orange]WARN | %d | %s | [b]%s[/b][/color]" % [ticks, current_state, str(message)])
			push_warning(str(message))
		2:
			print_rich("[color=red]FAIL | %d | %s | [b]%s[/b][/color]" % [ticks, current_state, str(message)])
			push_error(str(message))
		3:
			print_rich("[color=#999999]DBUG | %d | %s | %s | %s[/color]" % [ticks, current_state, in_game_time, str(message)])
