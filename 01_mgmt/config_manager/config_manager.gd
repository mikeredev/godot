extends Node

@onready var filepath_db: FilepathDB = FilepathDB.new()
@onready var signal_db: SignalDB = SignalDB.new()


func _ready() -> void:
	event.emit_signal(signal_db.NODE_READY, self)
