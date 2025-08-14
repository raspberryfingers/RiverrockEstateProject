class_name InventoryDataResource
extends NodeDataResource

@export var inventory_data: Dictionary = {}


func _save_data(source_node: Node) -> void:
	super._save_data(source_node)
	
	# Assuming InventoryManager is autoloaded
	if InventoryManager:
		inventory_data = InventoryManager.inventory.duplicate(true)


func _load_data(window: Window) -> void:
	var scene_node = window.get_node_or_null(node_path)
	if InventoryManager:
		InventoryManager.inventory = inventory_data.duplicate(true)
		InventoryManager.inventory_changed.emit()
