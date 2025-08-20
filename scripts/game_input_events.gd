# game_input_events.gd
# A static helper class for handling player input events like movement and tool usage.
class_name GameInputEvents 

# Stores the last detected movement direction
static var direction: Vector2 

# Returns the current movement input as a Vector2
# LEFT = (-1, 0), RIGHT = (1, 0), UP = (0, -1), DOWN = (0, 1)
# If no input is pressed, returns Vector2.ZERO
static func movement_input() -> Vector2: 
	if Input.is_action_pressed("walk_left"):
		direction = Vector2.LEFT 
	elif Input.is_action_pressed("walk_right"): 
		direction = Vector2.RIGHT
	elif Input.is_action_pressed("walk_up"):
		direction = Vector2.UP
	elif Input.is_action_pressed("walk_down"): 
		direction = Vector2.DOWN 
	else: 
		direction = Vector2.ZERO 
		
	return direction
	

# Returns true if there is any movement input, false otherwise
static func is_movement_input() -> bool: 
	if direction == Vector2.ZERO: 
		return false 
	else: 
		return true 


# Returns true if the player just pressed the "hit" action to use a tool
static func use_tool() -> bool: 
	var use_tool_value: bool = Input.is_action_just_pressed("hit") 
	
	return use_tool_value 
