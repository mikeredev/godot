class_name TimeManager extends Node

enum GetCurrent { SECOND, MINUTE, HOUR, DAY, MONTH, YEAR }

static var year: int = 1970
static var month: int = 1
static var day: int = 1
static var hour: int = 0
static var minute: int = 0
static var second: int = 0

static var _timer: Timer
static var _self: TimeManager
static var _err: int ## TODO add setter to check if not 0


func _init() -> void:
	self.name = "TimeManager"
	_self = self
	if Settings.START_DATE:
		var dict: Dictionary = Time.get_datetime_dict_from_datetime_string(Settings.START_DATE, false)
		year = str(dict["year"]).to_int()
		month = str(dict["month"]).to_int()
		day = str(dict["day"]).to_int()
		hour = str(dict["hour"]).to_int()
		minute = str(dict["minute"]).to_int()
		second = str(dict["second"]).to_int()


static func start() -> void:
	_timer = Timer.new()
	_timer.wait_time = Settings.TIMER_WAIT_TIME
	_err = _timer.connect("timeout", _on_clock_tick)
	_self.add_child(_timer)
	_timer.start()
	Debug.log("start date: %s" % get_timestamp(), 3)


static func pause() -> void:
	_timer.paused = true


static func resume() -> void:
	_timer.paused = false


static func get_timestamp() -> String:
	return "%04d-%02d-%02dT%02d:%02d:%02d" % [year, month, day, hour, minute, second]


static func get_date_string() -> String:
	return "%s %d %04d" % [get_month_name(month), day, year]


static func get_time_string() -> String:
	return "%02d:%02d" % [hour, minute]


static func get_time_dict() -> Dictionary:
	return Time.get_datetime_dict_from_datetime_string(get_timestamp(), false)


static func is_leap_year(_year: int) -> bool:
	return (_year % 4 == 0 and _year % 100 != 0) or (_year % 400 == 0)


static func get_month_name(_month: int) -> String:
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


static func get_current(_get: GetCurrent) -> int:
	match _get:
		GetCurrent.SECOND:return second
		GetCurrent.MINUTE: return minute
		GetCurrent.HOUR: return hour
		GetCurrent.DAY:	return day
		GetCurrent.MONTH:return month
		GetCurrent.YEAR: return year
		_: return -1


static func _on_clock_tick() -> void:
	_update_second(Settings.SECONDS_PER_UPDATE)


static func _update_second(i: int) -> void:
	second += i
	if second >= 60:
		_update_minute(int(second / 60))
		second %= 60
	_err = Event.emit_signal("clock_ticked")


static func _update_minute(i: int) -> void:
	minute += i
	if minute >= 60:
		_update_hour(int(minute/60))
		minute %= 60
	_err = Event.emit_signal("minute_ticked")


static func _update_hour(i: int) -> void:
	hour += i
	if hour >= 24:
		_update_day(int(hour/24))
		hour %= 24
	_err = Event.emit_signal("hour_ticked")


static func _update_day(i: int) -> void:
	day += i

	if month == Time.MONTH_FEBRUARY and day > 28:
		if not is_leap_year(year):
			_update_month(int(day/28))
			day %= 28

	if month == Time.MONTH_FEBRUARY and day > 29:
			_update_month(int(day/29))
			day %= 29

	if (month == Time.MONTH_APRIL
		or month == Time.MONTH_JUNE
		or month == Time.MONTH_SEPTEMBER
		or month == Time.MONTH_NOVEMBER):
		if day > 30:
			_update_month(int(day/30))
			day %= 30

	if day > 31:
		_update_month(int(day/31))
		day %= 31

	_err = Event.emit_signal("day_ticked")


static func _update_month(i: int) -> void:
	month += i
	if month > 12:
		_update_year(int(month/12))
		month %= 12
	_err = Event.emit_signal("month_ticked")


static func _update_year(i: int) -> void:
	year += i
	_err = Event.emit_signal("year_ticked")
