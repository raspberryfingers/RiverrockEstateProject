# inventory_panel_data_resource.gd
# A resource class for saving and loading player inventory data.
class_name InventoryDataResource
extends NodeDataResource

# Stores all inventory data in a dictionary.
# Keys/values depend on how InventoryManager defines its inventory structure.
@export var inventory_data: Dictionary = {}


# Save the current inventory state from the InventoryManager singleton.
func _save_data(source_node: Node) -> void:
	super._save_data(source_node)
	
	# Ensure the InventoryManager is available before saving.
	# Duplicate with "true" for a deep copy, preventing reference issues.
	if InventoryManager:
		inventory_data = InventoryManager.inventory.duplicate(true)


# Load the saved inventory state back into the InventoryManager singleton.
func _load_data(window: Window) -> void:
	# Get the node tied to this resource (if needed in your save/load system).
	var scene_node = window.get_node_or_null(node_path)
	
	# Restore inventory and notify listeners that the inventory has changed.
	if InventoryManager:
		InventoryManager.inventory = inventory_data.duplicate(true)
		InventoryManager.inventory_changed.emit()
