# door.gd
# This component controls a door's interaction, animation, and collision behavior.
extends StaticBody2D

# References to child nodes
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var interactable_component = $InteractableComponent

func _ready():
	# Connect interactable signals to handle door activation/deactivation
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	
	# Set initial collision layer (1 = default)
	collision_layer = 1
	

func on_interactable_activated() -> void:
	# Play the door opening animation
	animated_sprite_2d.play("open_door")
	
	# Change collision layer to allow passage
	collision_layer = 2
	print("door activated")
	

func on_interactable_deactivated() -> void: 
	# Play the door closing animation
	animated_sprite_2d.play("close_door") 
	
	# Reset collision layer to block passage
	collision_layer = 1
	print("door deactivated")
