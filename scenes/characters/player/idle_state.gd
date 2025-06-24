extends NodeState 

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D

var direction: Vector2 
var not_on_ui : bool = false


func _on_process(_delta : float) -> void:
	if not Input.is_action_pressed("hit"):
		not_on_ui = false


func _unhandled_input(event):
	if event.is_action_pressed("hit"):
		not_on_ui = true


func _on_physics_process(_delta : float) -> void:	
	if player.player_direction == Vector2.UP: 
		animated_sprite_2d.play("idle_back")
	elif player.player_direction == Vector2.RIGHT: 
		animated_sprite_2d.play("idle_left")
	elif player.player_direction == Vector2.DOWN:
		animated_sprite_2d.play("idle_front")
	elif player.player_direction == Vector2.LEFT:
		animated_sprite_2d.play("idle_left")
	else: 
		animated_sprite_2d.play("idle_front")


func _on_next_transitions() -> void:
	GameInputEvents.movement_input()
	
	if GameInputEvents.is_movement_input(): 
			transition.emit("Walk")
	
	elif not_on_ui:
			
		if player.current_tool == DataTypes.Tools.AxeWood && GameInputEvents.use_tool():
			transition.emit("Chopping")
			
		if player.current_tool == DataTypes.Tools.TillGround && GameInputEvents.use_tool():
			transition.emit("Tilling")
			
		if player.current_tool == DataTypes.Tools.WaterCrops && GameInputEvents.use_tool():
			transition.emit("Watering")


func _on_enter() -> void:
	pass


func _on_exit() -> void:
	animated_sprite_2d.stop()
