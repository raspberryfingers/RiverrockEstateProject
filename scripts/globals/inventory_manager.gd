# inventory_manager.gd
# Manages the player's inventory and emits signals whenever it changes.
extends Node

# Dictionary storing the quantity of each collectable item
var inventory : Dictionary = Dictionary() 

# Signal emitted whenever the inventory changes
signal inventory_changed 

# Adds one unit of the specified collectable to the inventory
func add_collectable(collectable_name : String) -> void:
	# Ensure the key exists
	inventory.get_or_add(collectable_name)
	
	# Initialise or increment the item count
	if inventory[collectable_name] == null: 
		inventory[collectable_name] = 1 
	else: 
		inventory[collectable_name] += 1 
		
	# Notify listeners that the inventory has changed
	inventory_changed.emit() 


# Removes one unit of the specified collectable from the inventory
func remove_collectable(collectable_name : String) -> void:
	# Initialise if missing
	if inventory[collectable_name] == null: 
		inventory[collectable_name] = 0 
	else: 
		# Decrement only if the count is greater than 0
		if inventory[collectable_name] > 0: 
			inventory[collectable_name] -= 1 
		
	# Notify listeners that the inventory has changed
	inventory_changed.emit() 
	
