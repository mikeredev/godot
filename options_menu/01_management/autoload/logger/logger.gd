extends Node


func write(log_message: String, log_level: int = 0) -> void:
	match log_level:
		0:
			print_rich("[color=white][INFO][/color] %s" % str(log_message))
		1:
			print_rich("[color=orange][b][WARN] %s[/b][/color] " % str(log_message))
			push_warning(str(log_message))
		2:
			printerr("[CRIT] %s " % str(log_message))
			push_error(str(log_message))
		3:
			print_rich("[color=#999999][DBUG] [i]%s[/i][/color]" % str(log_message))
