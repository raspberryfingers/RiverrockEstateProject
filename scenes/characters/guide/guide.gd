# guide.gd
# Handles interaction prompts, dialogue balloon spawning, and enabling tools when crop seeds are given.
extends Node2D

# Preload the dialogue balloon scene for instantiation when dialogue is triggered.
var balloon_scene: PackedScene = preload("res://dialogue/game_dialogue_balloon.tscn")

# References to components inside the node.
@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var interactable_label_component: Control = $InteractableLableComponent

# Tracks whether the player is currently in interaction range.
var in_range: bool = false


func _ready() -> void: 
	# Connect interaction signals to show/hide the interaction prompt.
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	
	# Hide the label by default until the player enters range.
	interactable_label_component.hide()
	
	# Connect to GameDialogueManager signal that grants crop seeds.
	GameDialogueManager.give_crop_seeds.connect(on_give_crop_seeds) 
	

# Triggered when the player enters interaction range.
func on_interactable_activated() -> void: 
	interactable_label_component.show()
	in_range = true
	

# Triggered when the player leaves interaction range.
func on_interactable_deactivated() -> void: 
	interactable_label_component.hide()
	in_range = false 


# Handles input while in range of the NPC.
func _unhandled_input(event: InputEvent) -> void:
	if in_range and event.is_action_pressed("show_dialogue"):
		# Spawn and display a dialogue balloon at runtime.
		var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate()
		get_tree().root.add_child(balloon)
		
		# Start dialogue from the guide NPC's dialogue file.
		balloon.start(
			load("res://dialogue/conversations/guide.dialogue"),
			"start"
		)


# Callback for when the player is given crop seeds.
# Unlocks the relevant farming tools in the ToolManager.
func on_give_crop_seeds() -> void: 
	ToolManager.enable_tool_button(DataTypes.Tools.TillGround) 
	ToolManager.enable_tool_button(DataTypes.Tools.WaterCrops) 
	ToolManager.enable_tool_button(DataTypes.Tools.PlantWheat) 
	ToolManager.enable_tool_button(DataTypes.Tools.PlantTomato) 
