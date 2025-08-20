# collectable_component.gd
# Handles collection logic for items in the game world.
class_name CollectableComponent
extends Area2D

# Editor Exports 
@export var collectable_name: String # Name/ID of the collectable (used in InventoryManager)


# Signals
func _on_body_entered(body: Node2D) -> void:
	# Only allow the Player to collect
	if body is Player: 
		# Add item to inventory (make sure InventoryManager is a global autoload)
		InventoryManager.add_collectable(collectable_name)
		
		# Debug log
		print("Collected: ", collectable_name)
		
		# Remove the collectable object from the scene
		get_parent().queue_free()
