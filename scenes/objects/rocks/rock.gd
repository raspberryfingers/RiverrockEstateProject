# rock.gd
# This component handles rock damage, visual shake effect, and spawning stone items upon destruction.
extends Sprite2D

# Child components
@onready var hurt_component = $HurtComponent
@onready var damage_component = $DamageComponent

# Preloaded scene for the stone item dropped when the rock breaks
var stone_scene = preload("res://scenes/objects/rocks/stone.tscn")

func _ready() -> void:
	# Connect signals for taking damage and reaching maximum damage
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damage_reached.connect(on_max_damaged_reached)


# Called when the rock is hit by a tool
func on_hurt(hit_damage: int) -> void: 
	# Apply damage to the rock
	damage_component.apply_damage(hit_damage)
	print("rock hit")
	
	# Shake the rock visually using a shader parameter
	material.set_shader_parameter("shake_intensity", 0.3)
	await get_tree().create_timer(0.5).timeout
	material.set_shader_parameter("shake_intensity", 0.0)
	
	
# Called when the rock's max damage is reached
func on_max_damaged_reached() -> void: 
	call_deferred("add_stone_scene")
	print("max damage reached")
	# Remove the rock from the scene
	queue_free()
	
	
# Instantiates a stone item at the rock's position
func add_stone_scene() -> void: 
	var stone_instance = stone_scene.instantiate() as Node2D
	stone_instance.global_position = global_position
	get_parent().add_child(stone_instance)
