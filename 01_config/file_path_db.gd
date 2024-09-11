class_name FilePathDB extends RefCounted


static var system: Dictionary = {
	"hud": "res://05_entities/ui/hud.tscn",
	"notification": "res://05_entities/dialog/notification.tscn",
}

static var content: Dictionary = {
	"core": "res://04_core/",
	"custom": "user://mod/"
}

static var settings: Dictionary = {
	"user": "res://settings.ini",
}

static var world: Dictionary = {
	"root": "res://05_entities/world/world/world.tscn",
	"overworld": "res://05_entities/world/overworld/overworld.tscn",
	"city_scene": "res://05_entities/world/city/city.tscn",
}

static var player: String = "res://05_entities/player/player.tscn"

static var menu: Dictionary = {
	"new_profile": "res://05_entities/menu/new_profile/new_profile.tscn",
}
