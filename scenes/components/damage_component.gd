# damage_component.gd
# A reusable component for handling damage logic on any Node2D.
# Tracks current damage, clamps values, and emits a signal when max damage is reached.
class_name DamageComponent
extends Node2D

# Exported Variables 
@export var max_damage = 1 # Maximum damage this entity can take
@export var current_damage = 0 # Current damage this entity has taken

# Signals 
signal max_damage_reached # Emitted when current_damage reaches max_damage


func apply_damage(damage : int) -> void: 
	# Apply incoming damage and clamp between 0 and max_damage
	current_damage = clamp(current_damage + damage, 0, max_damage)
	
	# Check if the entity has reached maximum damage
	if current_damage == max_damage: 
		# Emit the signal so other systems can react (e.g., death, destruction, etc.)
		max_damage_reached.emit()
