# player.gd
# Handles the player tool selection and sprite flipping. 
class_name Player 
extends CharacterBody2D

# Reference to the hit component (handles interactions like chopping, hitting, etc.)
@onready var hit_component: HitComponent = $HitComponent

# Currently equipped tool (defaults to None)
@export var current_tool: DataTypes.Tools = DataTypes.Tools.None
# Reference to the AnimatedSprite2D for player animations
@export var animated_sprite_2d: AnimatedSprite2D

# Tracks the player’s movement direction
var player_direction: Vector2

func _ready() -> void:
	# Connects the ToolManager signal so the player updates their current tool when selected
	ToolManager.tool_selected.connect(on_tool_selected)

func _physics_process(delta):
	# Flip the sprite horizontally depending on the player's direction
	if player_direction.x < 0:
		animated_sprite_2d.flip_h = true
	elif player_direction.x > 0:
		animated_sprite_2d.flip_h = false
		
func on_tool_selected(tool: DataTypes.Tools) -> void: 
	# Updates the current tool when the player selects a new one
	current_tool = tool
	hit_component.current_tool = tool 
	
	# Debug print to verify tool changes in the output
	print("Tool:", tool)
