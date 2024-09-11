class_name Settings extends RefCounted

## General
const SHOW_DEBUG_LOGS: bool = true

## Time Manager
const START_DATE: String = "2020-03-17T21:15:20" ## ISO 8601 (YYYY-MM-DDTHH:MM:SS)
const SECONDS_PER_UPDATE: int = 60  ## 1=realtime, 2=2x, etc
const TIMER_WAIT_TIME: int = 1 ## update every n seconds
