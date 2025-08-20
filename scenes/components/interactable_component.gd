# interactable_component.gd
# A component that detects when the player or other objects
# enter or exit its area, triggering interactable signals.
class_name InteractableComponent
extends Area2D

# Emitted when a body enters the interactable area.
signal interactable_activated 

# Emitted when a body exits the interactable area.
signal interactable_deactivated 

# Called when a body (e.g., player) enters this Area2D.
func _on_body_entered(body: Node2D) -> void:
	# Emits the `interactable_activated` signal.
	interactable_activated.emit()


# Called when a body exits this Area2D.
func _on_body_exited(body: Node2D) -> void:
	# Emits the `interactable_deactivated` signal.
	interactable_deactivated.emit()
