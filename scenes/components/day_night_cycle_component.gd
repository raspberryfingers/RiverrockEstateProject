# day_night_cycle_component.gd
# Handles the day/night cycle visuals using a gradient on CanvasModulate.
# Syncs with the DayAndNightCycleManager to apply initial values and update colour over time.
class_name DayNightCycleComponent 
extends CanvasModulate

# Exported Variables 
@export var initial_day: int = 1: 
	set(id):
		# Update local variable and sync with the manager
		initial_day = id 
		DayAndNightCycleManager.initial_day = id
		DayAndNightCycleManager.set_initial_time()

@export var initial_hour: int = 12:
	set(ih):
		# Update local variable and sync with the manager
		initial_hour = ih
		DayAndNightCycleManager.initial_hour
		DayAndNightCycleManager.set_initial_time()

@export var initial_minute: int = 30: 
	set(im): 
		# Update local variable and sync with the manager
		initial_minute = im
		DayAndNightCycleManager.initial_minute
		DayAndNightCycleManager.set_initial_time()
		
@export var day_night_gradient_texture: GradientTexture1D # Gradient texture used for day/night colour blending


func _ready() -> void:
	# Apply initial values to the manager when the scene starts
	DayAndNightCycleManager.initial_day = initial_day 
	DayAndNightCycleManager.initial_hour = initial_hour 
	DayAndNightCycleManager.initial_minute = initial_minute
	DayAndNightCycleManager.set_initial_time()
	
	# Connect to the manager's time signal to update visuals continuously
	DayAndNightCycleManager.game_time.connect(on_game_time)
	
func on_game_time(time: float) -> void: 
	# Convert time value into a range [0.0, 1.0] using sine wave for smooth transitions
	var sample_value = 0.5 * (sin(time - PI * 0.5) + 1.0)
	
	# Apply gradient color to CanvasModulate to simulate day/night transition
	color = day_night_gradient_texture.gradient.sample(sample_value)
	
