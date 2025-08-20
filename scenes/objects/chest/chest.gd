# chest_component.gd
# This component handles a chest that can be interacted with, opened to show dialogue,
# and used to feed animals, spawning harvest items and rewards.
extends Node2D

# Preloaded scenes
var balloon_scene = preload("res://dialogue/game_dialogue_balloon.tscn")
var wheat_harvest = preload("res://scenes/objects/plants/wheat_harvest_icon.tscn")
var tomato_harvest = preload("res://scenes/objects/plants/tomato_harvest_icon.tscn")

# Exported variables for customisation
@export var dialogue_start_command: String  # Dialogue command to start when chest is opened
@export var food_drop_height: int = 40 # Height above chest where harvested items appear
@export var reward_output_radius: int = 20 # Radius for random reward placement
@export var output_reward_scenes: Array[PackedScene] = [] # Rewards to spawn when feeding

# Onready references to child nodes
@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var feed_component: FeedComponent = $FeedComponent
@onready var reward_marker: Marker2D = $RewardMarker
@onready var interactable_lable_component: Control = $InteractableLableComponent

# Internal state variables
var in_range: bool # Is the player in range to interact with the chest
var is_chest_open: bool # Is the chest currently open

func _ready() -> void:
	# Connect signals for interaction and feeding
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	interactable_lable_component.hide()
	
	GameDialogueManager.feed_the_animals.connect(on_feed_the_animals)
	feed_component.food_recieved.connect(on_food_received)


# Called when player enters interaction range
func on_interactable_activated() -> void: 
	interactable_lable_component.show()
	in_range = true 
	

# Called when player leaves interaction range
func on_interactable_deactivated() -> void: 
	if is_chest_open:
		animated_sprite_2d.play("chest_close")
		
	is_chest_open = false 
	interactable_lable_component.hide()
	in_range = false 
	
	
func _unhandled_input(event: InputEvent) -> void:
	if in_range: 
		if event.is_action_pressed("show_dialogue"): 
			# Open the chest and start dialogue 
			interactable_lable_component.hide() 
			animated_sprite_2d.play("chest_open")
			is_chest_open = true 
			
			# create some dialogue 
			var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate()
			get_tree().root.add_child(balloon)
			balloon.start(load("res://dialogue/chest.dialogue"), dialogue_start_command)


# Triggered when the "feed the animals" event occurs
func on_feed_the_animals() -> void: 
	if in_range: 
		trigger_feed_harvest("wheat", wheat_harvest)
		trigger_feed_harvest("tomato", tomato_harvest)


# Spawns harvested items from inventory, animates them to chest position, and removes them from inventory
func trigger_feed_harvest(inventory_item: String, scene: Resource) -> void: 
	var inventory: Dictionary = InventoryManager.inventory
	
	if !inventory.has(inventory_item):
		return
	
	var inventory_item_count = inventory[inventory_item]
	
	for index in inventory_item_count:
		var harvest_instance = scene.instantiate() as Node2D
		harvest_instance.global_position = Vector2(global_position.x, global_position.y - food_drop_height)
		get_tree().root.add_child(harvest_instance)
		var target_position = global_position
		
		var time_delay = randf_range(0.5, 2.0)
		await get_tree().create_timer(time_delay).timeout
		
		var tween = get_tree().create_tween()
		tween.tween_property(harvest_instance, "position", target_position, 1.0)
		tween.tween_property(harvest_instance, "scale", Vector2(0.5, 0.5), 1.0)
		tween.tween_callback(harvest_instance.queue_free)
		
		InventoryManager.remove_collectable(inventory_item)


# Called when feed_component receives food
func on_food_received(area: Area2D) -> void:
	call_deferred("add_reward_scene")


# Adds reward scenes around the reward marker in a random circular area
func add_reward_scene() -> void:
	for scene in output_reward_scenes:
		var reward_scene: Node2D = scene.instantiate()
		var reward_position: Vector2 = get_random_position_in_circle(reward_marker.global_position, reward_output_radius)
		reward_scene.global_position = reward_position
		get_tree().root.add_child(reward_scene)


# Returns a random position within a circle around a given center
func get_random_position_in_circle(center: Vector2, radius: int) -> Vector2i:
	var angle = randf() * TAU
	
	var distance_from_center = sqrt(randf()) * radius
	
	var x: int = center.x + distance_from_center * cos(angle)
	var y: int = center.y + distance_from_center * cos(angle)
	
	return Vector2i(x, y)
