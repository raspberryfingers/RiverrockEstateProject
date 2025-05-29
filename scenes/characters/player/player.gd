class_name Player 
extends CharacterBody2D

@export var current_tool: DataTypes.Tools = DataTypes.Tools.None
@export var animated_sprite_2d: AnimatedSprite2D

var player_direction: Vector2

func _physics_process(delta):
	if player_direction.x < 0:
		animated_sprite_2d.flip_h = true

	elif player_direction.x > 0:
		animated_sprite_2d.flip_h = false
