class_name Player 
extends CharacterBody2D

@onready var hit_component: HitComponent = $HitComponent

@export var current_tool: DataTypes.Tools = DataTypes.Tools.None
@export var animated_sprite_2d: AnimatedSprite2D

var player_direction: Vector2

func _ready() -> void:
	ToolManager.tool_selected.connect(on_tool_selected)

func _physics_process(delta):
	if player_direction.x < 0:
		animated_sprite_2d.flip_h = true

	elif player_direction.x > 0:
		animated_sprite_2d.flip_h = false
		
func on_tool_selected(tool: DataTypes.Tools) -> void: 
	current_tool = tool
	hit_component.current_tool = tool 
	print("Tool:", tool)
