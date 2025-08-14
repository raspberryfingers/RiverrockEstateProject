class_name DayCycleSaveDataResource
extends NodeDataResource

@export var time: float = 0.0
@export var current_day: int = 0
@export var current_minute: int = 0 


func _save_data(source_node: Node) -> void:
	super._save_data(source_node)
	
	# Assuming DayAndNightCycleManager is autoloaded
	if DayAndNightCycleManager:
		time = DayAndNightCycleManager.time
		current_day = DayAndNightCycleManager.current_day
		current_minute = DayAndNightCycleManager.current_minute


func _load_data(window: Window) -> void:
	if DayAndNightCycleManager:
		DayAndNightCycleManager.time = time
		DayAndNightCycleManager.current_day = current_day
		DayAndNightCycleManager.current_minute = current_minute
