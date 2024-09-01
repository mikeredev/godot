extends Node


func log(
	caller: Node,
	text: Variant,
	log_level: int = 0) -> void:

	var ticks: int = Time.get_ticks_usec()

	match log_level:
		0:
			print_rich("[color=white]INFO | %s | %s | %s[/color]" % [ticks, caller.name, str(text)])
		1:
			print_rich("[color=orange]WARN | %s | %s | %s[/color]" % [ticks, caller.name, str(text)])
			push_warning(str(text))
		2:
			print_rich("[color=red]FAIL | %s | %s | %s[/color]" % [ticks, caller.name, str(text)])
			push_error(str(text))
		3:
			print_rich("[color=#999999]DBUG | %s | %s | %s[/color]" % [ticks, caller.name, str(text)])


func _ready() -> void:
	self.log(self, "ready", 3)
