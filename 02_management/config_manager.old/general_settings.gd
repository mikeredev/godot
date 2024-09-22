class_name GeneralSettings extends RefCounted

static var section_key: String = "general"
static var options: Dictionary = {
	"language": {
		"default": "en"
	},
}


static func apply() -> void:
	var language: String = ConfigManager.user_settings.get_value(section_key, "language")
	set_language(language)


static func set_language(language: String) -> void:
	match language:
		"en":
			TranslationServer.set_locale(language)
		_:
			Debug.log("language unavailable: %s" % language)
			set_language("en")
			return
	Debug.log("set language: %s" % language, 3)
