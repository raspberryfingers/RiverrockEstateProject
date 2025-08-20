# feed_component.gd 
class_name FeedComponent 
extends Area2D

# Signal emitted when food is received (another Area2D enters this one).
# The signal passes the area that entered as an argument.
signal food_recieved(area: Area2D)


# Triggered when another Area2D enters this one.
# Emits the 'food_received' signal with the area that entered.
func _on_area_entered(area: Area2D) -> void:
	food_recieved.emit(area)
