# large_tree.gd
# This component handles tree damage, visual shake effect, and spawning log items upon destruction.
extends Sprite2D

# Child components
@onready var hurt_component: HurtComponent = $HurtComponent

@onready var damage_component = $DamageComponent

# Preloaded scene for the log item dropped when the tree is destroyed
var log_scene = preload("res://scenes/objects/trees/log.tscn")

func _ready() -> void:
	# Connect signals for taking damage and reaching maximum damage
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damage_reached.connect(on_max_damaged_reached)


# Called when the tree is hit by a tool
func on_hurt(hit_damage: int) -> void: 
	# Apply damage to the tree
	damage_component.apply_damage(hit_damage)
	
	# Shake the tree visually using a shader parameter
	material.set_shader_parameter("shake_intensity", 0.5)
	await get_tree().create_timer(0.5).timeout
	material.set_shader_parameter("shake_intensity", 0.0)


# Called when the tree's max damage is reached
func on_max_damaged_reached() -> void: 
	call_deferred("add_log_scene")
	print("max damage reached")
	# Remove the tree from the scene
	queue_free()


# Instantiates a log item at the tree's position
func add_log_scene() -> void: 
	var log_instance = log_scene.instantiate() as Node2D
	log_instance.global_position = global_position
	get_parent().add_child(log_instance)
