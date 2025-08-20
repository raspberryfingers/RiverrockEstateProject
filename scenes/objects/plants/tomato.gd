# tomato.gd
# This component manages a tomato plant's growth cycle, particle effects, and harvest logic.
extends Node2D

# Preloaded scene for the tomato harvest item
var tomato_harvest_scene = preload("res://scenes/objects/plants/tomato_harvest.tscn")

# Onready references to child nodes
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var watering_particles: GPUParticles2D = $WateringParticles
@onready var flowering_particles: GPUParticles2D = $FloweringParticles
@onready var growth_cycle_component: GrowthCycleComponent = $GrowthCycleComponent
@onready var hurt_component: HurtComponent = $HurtComponent

# Internal variable tracking the current growth state
var growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Seed

func _ready() -> void:
	# Disable particle effects initially
	watering_particles.emitting = false
	flowering_particles.emitting = false
	
	# Connect signals
	hurt_component.hurt.connect(on_hurt)
	growth_cycle_component.crop_maturity.connect(on_crop_maturity)
	growth_cycle_component.crop_harvesting.connect(on_crop_harvesting)

	
func _process(delta: float) -> void:
	# Update current growth state from GrowthCycleComponent
	growth_state = growth_cycle_component.get_current_growth_state()
	
	# Update sprite frame based on growth state
	sprite_2d.frame = growth_state + 1
	
	# Enable flowering particles when plant reaches maturity
	if growth_state == DataTypes.GrowthStates.Maturity:
		flowering_particles.emitting = true


# Called when the plant takes damage (used here to simulate watering)
func on_hurt(hit_damage: int) -> void:
	if !growth_cycle_component.is_watered:
		watering_particles.emitting = true
		# Wait 5 seconds to simulate watering effect
		await get_tree().create_timer(5.0).timeout
		watering_particles.emitting = false
		# Mark plant as watered
		growth_cycle_component.is_watered = true
		
		
# Called when the crop reaches maturity
func on_crop_maturity() -> void:
	flowering_particles.emitting = true


# Called when the crop is ready for harvesting
func on_crop_harvesting() -> void:
	# Instantiate the tomato harvest item
	var tomato_harvest_instance = tomato_harvest_scene.instantiate() as Node2D
	tomato_harvest_instance.global_position = global_position
	get_parent().add_child(tomato_harvest_instance)
	
	# Remove the plant from the scene
	queue_free()
