# game_dialogue_manager.gd
# Handles broadcasting dialogue-related gameplay actions such as giving seeds or feeding animals
extends Node

# Signals emitted to trigger specific gameplay actions
signal give_crop_seeds # Emitted when the player chooses to give crop seeds
signal feed_the_animals # Emitted when the player chooses to feed animals

# Emits the give_crop_seeds signal
func action_give_crop_seeds() -> void: 
	give_crop_seeds.emit() 
	

# Emits the feed_the_animals signal
func action_feed_the_animals() -> void: 
	feed_the_animals.emit()
