class_name NodeDataResource
extends Resource

@export var global_position: Vector2
@export var node_path: NodePath
@export var parent_node_path: NodePath


func _save_data(source_node: Node) -> void:
	global_position = source_node.global_position
	node_path = source_node.get_path()
	
	var parent_node = source_node.get_parent()
	
	if parent_node != null:
		parent_node_path = parent_node.get_path()


func _load_data(_window: Window) -> void:
	pass
