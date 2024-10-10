class_name TimeManager extends RefCounted

enum Unit { SECOND, MINUTE, HOUR, DAY, MONTH, YEAR }
const TIMER_WAIT_TIME: int = 1 ## update every n seconds

static var seconds_per_update: int = 3600:
	set(new_interval):
		seconds_per_update = new_interval
		Event.emit_signal("clock_speed_changed")
		Debug.log("in-game time adjusted to: %d" % seconds_per_update, 3)

static var year: int = 1970
static var month: int = 1
static var day: int = 1
static var hour: int = 0
static var minute: int = 0
static var second: int = 0

static var timer: Timer


static func setup(timer_parent: Node) -> void:
	timer = Timer.new()
	timer.wait_time = TIMER_WAIT_TIME
	timer.connect("timeout", _on_clock_tick)
	timer_parent.add_child(timer)
	timer.name = "WorldClock"


static func start(start_date: String) -> void:
	var dict: Dictionary = Time.get_datetime_dict_from_datetime_string(start_date, false)
	year = dict["year"]
	month = dict["month"]
	day = dict["day"]
	hour = dict["hour"]
	minute = dict["minute"]
	second = dict["second"]

	timer.start()
	Debug.log("start date: %s, update every: %ds, base in-game seconds per update: %s" % [get_iso_timestamp(), TIMER_WAIT_TIME, seconds_per_update], 3)


static func pause() -> void:
	timer.paused = true


static func resume() -> void:
	timer.paused = false


static func get_iso_timestamp() -> String:
	return "%04d-%02d-%02dT%02d:%02d:%02d" % [year, month, day, hour, minute, second]


static func get_short_timestamp() -> String:
	return "%04d%02d%02d%02d%02d%02d" % [year, month, day, hour, minute, second]


static func get_dict() -> Dictionary:
	return Time.get_datetime_dict_from_datetime_string(get_iso_timestamp(), false)


static func is_leap_year(_year: int) -> bool:
	return (_year % 4 == 0 and _year % 100 != 0) or (_year % 400 == 0)


static func get_month_name(_month: int) -> String: # localization strings
	match _month:
		1: return "MONTH_JANUARY"
		2: return "MONTH_FEBRUARY"
		3: return "MONTH_MARCH"
		4: return "MONTH_APRIL"
		5: return "MONTH_MAY"
		6: return "MONTH_JUNE"
		7: return "MONTH_JULY"
		8: return "MONTH_AUGUST"
		9: return "MONTH_SEPTEMBER"
		10: return "MONTH_OCTOBER"
		11: return "MONTH_NOVEMBER"
		12: return "MONTH_DECEMBER"
		_: return "NULL"


static func get_current(_get: Unit) -> int:
	match _get:
		Unit.SECOND: return second
		Unit.MINUTE: return minute
		Unit.HOUR: return hour
		Unit.DAY: return day
		Unit.MONTH:return month
		Unit.YEAR: return year
		_: return -1


static func _on_clock_tick() -> void:
	_update_second(seconds_per_update)


static func _update_second(i: int) -> void:
	second += i
	if second >= 60:
		_update_minute(int(second / 60.0))
		second %= 60
	Event.emit_signal("clock_ticked")


static func _update_minute(i: int) -> void:
	minute += i
	if minute >= 60:
		_update_hour(int(minute / 60.0))
		minute %= 60
	Event.emit_signal("minute_ticked")


static func _update_hour(i: int) -> void:
	hour += i
	if hour >= 24:
		_update_day(int(hour / 24.0))
		hour %= 24
	Event.emit_signal("hour_ticked")


static func _update_day(i: int) -> void:
	day += i

	if month == Time.MONTH_FEBRUARY and day > 28:
		if not is_leap_year(year):
			_update_month(int(day / 28.0))
			day %= 28

	if month == Time.MONTH_FEBRUARY and day > 29:
			_update_month(int(day / 29.0))
			day %= 29

	if (month == Time.MONTH_APRIL
		or month == Time.MONTH_JUNE
		or month == Time.MONTH_SEPTEMBER
		or month == Time.MONTH_NOVEMBER):
		if day > 30:
			_update_month(int(day / 30.0))
			day %= 30

	if day > 31:
		_update_month(int(day / 31.0))
		day %= 31

	Event.emit_signal("day_ticked")


static func _update_month(i: int) -> void:
	month += i
	if month > 12:
		_update_year(int(month / 12.0))
		month %= 12
	Event.emit_signal("month_ticked")


static func _update_year(i: int) -> void:
	year += i
	Event.emit_signal("year_ticked")
