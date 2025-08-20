# day_and_night_panel.gd
# Handles the UI display for the day and time, and controls the game speed.
extends Control

# References to UI labels
@onready var day_label: Label = $DayPanel/MarginContainer/DayLabel
@onready var time_label: Label = $TimePanel/MarginContainer/TimeLabel

# Game speed settings
@export var normal_speed: int = 5
@export var fast_speed: int = 100
@export var cheetah_speed: int = 200

func _ready() -> void:
	# Connect to the DayAndNightCycleManager to update UI on each time tick
	DayAndNightCycleManager.time_tick.connect(on_time_tick)


# Called every time the in-game time updates
func on_time_tick(day: int, hour: int, minute: int) -> void:
	# Update day label
	day_label.text = "Day " + str(day)
	
	# Update time label with zero-padded format (HH:MM)
	time_label.text = "%02d:%02d" % [hour, minute]


# Set game speed to normal
func _on_normal_speed_button_pressed() -> void:
	DayAndNightCycleManager.game_speed = normal_speed


# Set game speed to fast
func _on_fast_speed_button_pressed() -> void:
	DayAndNightCycleManager.game_speed = fast_speed


# Set game speed to cheetah (very fast)
func _on_cheetah_speed_buttonn_pressed() -> void:
	DayAndNightCycleManager.game_speed = cheetah_speed
