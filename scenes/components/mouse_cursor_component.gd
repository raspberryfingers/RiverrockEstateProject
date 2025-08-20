# cursor_component.gd
# Sets a custom mouse cursor for the game.
extends Node

# The texture to use for the custom cursor.
@export var cursor_component_texture: Texture2D

# Called when the node enters the scene tree.
func _ready() -> void:
	# Sets the custom mouse cursor to the provided texture.
	Input.set_custom_mouse_cursor(cursor_component_texture, Input.CURSOR_ARROW)
