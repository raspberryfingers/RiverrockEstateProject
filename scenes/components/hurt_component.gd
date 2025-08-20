# hurt_compoent.gd
# A component that detects when it is hit by a matching tool 
# and emits a signal with the damage value.
class_name HurtComponent
extends Area2D

# The tool type that can damage this object (default is None).
@export var tool : DataTypes.Tools = DataTypes.Tools.None

# Emitted when the object is hurt.
# Carries the damage amount from the hit.
signal hurt 

# Called automatically when another Area2D enters this one.
func _on_area_entered(area):
	var hit_component = area as HitComponent
	
	# If the entering area is a HitComponent and the tool matches,
	if tool == hit_component.current_tool: 
		# it emits the `hurt` signal with the hit damage.
		hurt.emit(hit_component.hit_damage)
