# hit_component.gd 
class_name HitComponent
extends Area2D

# The tool currently being used to hit (default is None).
@export var current_tool : DataTypes.Tools = DataTypes.Tools.None

# The amount of damage dealt when a hit is registered.
@export var hit_damage : int = 1 
