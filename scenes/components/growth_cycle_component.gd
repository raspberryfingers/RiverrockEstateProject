# GrowthCycleComponent.gd
# This component manages the lifecycle of a crop, including growth stages,
# maturity, and harvesting readiness, based on in-game days and watering.
class_name GrowthCycleComponent
extends Node

# Exported Variables 
# The current growth state of the crop (default is Germination).
@export var current_growth_state : DataTypes.GrowthStates = DataTypes.GrowthStates.Germination

# How many days it takes until the crop is ready to be harvested. 
# Minimum is 5 days, maximum is 365 days.
@export_range(5, 365) var days_until_harvest: int = 7 

# Signals 
signal crop_maturity # Emitted when the crop reaches the "Maturity" stage.
signal crop_harvesting # Emitted when the crop is ready to be harvested.

var is_watered: bool # Tracks if the crop has been watered (required for growth).
var starting_day: int # The in-game day when the crop's growth cycle started.
var current_day: int # The current in-game day, updated by the day-night cycle manager.

# Called when the node is added to the scene tree.
func _ready() -> void:
	# Connect to the day-night cycle manager to receive day tick updates.
	DayAndNightCycleManager.time_tick_day.connect(on_time_tick_day)


# Called each time a new in-game day passes.
# If watered, the crop progresses through growth states.
func on_time_tick_day(day: int) -> void: 
	if is_watered: 
		if starting_day == 0:
			# Record the day the crop first started growing.
			starting_day = day 
			
		# Update growth state based on elapsed days.
		growth_states(starting_day, day)
		# Check if crop is ready for harvesting.
		harvest_state(starting_day, day)



# Updates the crop's growth stage based on elapsed time. 
func growth_states(starting_day: int, current_day: int) -> void: 
	# If already mature, no need to update further.
	if current_growth_state == DataTypes.GrowthStates.Maturity:
		return
		
	var num_states = 6
	
	# Calculate days passed since planting and determine state index.
	var growth_days_passed = (current_day - starting_day) % num_states
	var state_index = growth_days_passed % num_states + 2 
	
	# Update the current growth state.
	current_growth_state = state_index
	
	# Debug print for testing and tracking growth.
	var name = DataTypes.GrowthStates.keys()[current_growth_state]
	print("Current Growth State: ", name, " State Index: ", state_index)
	
	# If the crop has reached maturity, emit the signal.
	if current_growth_state == DataTypes.GrowthStates.Maturity:
		crop_maturity.emit() 


# Checks if the crop is ready for harvesting based on the number of days passed.
func harvest_state(starting_day: int, current_day: int) -> void: 
	# If already in harvesting state, no need to update.
	if current_growth_state == DataTypes.GrowthStates.Harvesting:
		return
	
	# Calculate how many days have passed since planting.
	var days_past = (current_day - starting_day) % days_until_harvest
	
	# If the crop is within 2 days of the harvest date, transition state.
	if days_past == days_until_harvest -2: 
		current_growth_state = DataTypes.GrowthStates.Harvesting
		crop_harvesting.emit()
		

# Returns the current growth state of the crop.
func get_current_growth_state() -> DataTypes.GrowthStates:
	return current_growth_state
