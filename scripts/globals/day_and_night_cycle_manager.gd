# day_and_night_cycle_manager.gd
# Manages the in-game day and night cycle, tracking time, days, and emitting signals for updates.
extends Node

# Preload external day/night data if needed
var day_night_data = preload("res://scripts/globals/day_and_night_cycle_manager.gd")

# Constants for time calculations
const MINUTES_PER_DAY: int = 24 * 60 # Total minutes in one day 
const MINUTES_PER_HOUR: int = 60 # Total minutes in one hour
const GAME_MINUTE_DURATION: float = TAU / MINUTES_PER_DAY # Rotation equivalent for one in-game minute

# Game speed multiplier
var game_speed: float = 5.0

# Initial time settings
var initial_day: int = 1
var initial_hour: int = 12
var initial_minute: int = 30

# Time tracking variables
var time: float = 0.0
var current_minute: int = -1
var current_day: int = 0

# Signals
signal game_time(time: float) # Emits continuously with the current time (float)
signal time_tick(day: int, hour: int, minute: int) # Emits when minute changes
signal time_tick_day(day: int) # Emits when day changes

func _ready() -> void:
	# Initialise time at the start of the game
	if current_day == 0: 
		set_initial_time()
	else: 
		# Load saved day/night data if available
		day_night_data = load("res://data/DayNightCycleData.tres")


func _process(delta: float) -> void:
	# Advance time based on game speed
	time += delta * game_speed * GAME_MINUTE_DURATION
	game_time.emit(time)
	
	# Recalculate the current day, hour, and minute
	recalculate_time()


# Sets the initial time in the game based on exported values
func set_initial_time() -> void:
	var initial_total_minutes = initial_day * MINUTES_PER_DAY + (initial_hour * MINUTES_PER_HOUR) + initial_minute
	
	time = initial_total_minutes * GAME_MINUTE_DURATION


# Converts the accumulated time into day, hour, and minute
# Emits signals if a new minute or day has started
func recalculate_time() -> void:
	var total_minutes: int = int(time / GAME_MINUTE_DURATION)
	@warning_ignore("integer_division")
	var day: int = int(total_minutes / MINUTES_PER_DAY)
	var current_day_minutes: int = total_minutes % MINUTES_PER_DAY
	@warning_ignore("integer_division")
	var hour: int = int(current_day_minutes / MINUTES_PER_HOUR)
	var minute: int = int(current_day_minutes % MINUTES_PER_HOUR)
	
	# Emit signal if minute changed
	if current_minute != minute:
		current_minute = minute
		time_tick.emit(day, hour, minute)
	
	# Emit signal if day changed
	if current_day != day:
		current_day = day
		time_tick_day.emit(day)
	
