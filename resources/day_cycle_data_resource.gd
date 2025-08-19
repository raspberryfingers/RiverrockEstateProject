# day_cycle_data_resource
# A resource class for saving and loading day/night cycle data.

class_name DayCycleSaveDataResource
extends NodeDataResource

# The current in-game time (floating point representation).
@export var time: float = 0.0

# The current day number.
@export var current_day: int = 0

# The current minute within the day.
@export var current_minute: int = 0 


# Called when saving data from the source node into this resource.
# Stores values from the DayAndNightCycleManager singleton.
func _save_data(source_node: Node) -> void:
	super._save_data(source_node)
	
	# Ensure the DayAndNightCycleManager is available before saving.
	if DayAndNightCycleManager:
		time = DayAndNightCycleManager.time
		current_day = DayAndNightCycleManager.current_day
		current_minute = DayAndNightCycleManager.current_minute


# Called when loading data into the game.
# Restores values back into the DayAndNightCycleManager singleton.
func _load_data(window: Window) -> void:
	if DayAndNightCycleManager:
		DayAndNightCycleManager.time = time
		DayAndNightCycleManager.current_day = current_day
		DayAndNightCycleManager.current_minute = current_minute
