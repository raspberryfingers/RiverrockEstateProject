class_name CropsCursorComponent
extends Node

@export var tilled_dirt_tile_map_layer: TileMapLayer
@export var terrain_set: int = 0 
@export var terrain: int = 2

@onready var player: Player = get_tree().get_first_node_in_group("player")

var wheat_plant_scene = preload("res://scenes/objects/plants/wheat.tscn")
var tomato_plant_scene = preload("res://scenes/objects/plants/tomato.tscn")

var mouse_position: Vector2
var cell_position: Vector2i
var cell_source_id: int
var local_cell_position: Vector2
var distance: float

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("remove_dirt"): 
		if ToolManager.selected_tool == DataTypes.Tools.TillGround: 
			get_cell_under_mouse()
			remove_crop()
			
	elif event.is_action_pressed("hit"):
		if ToolManager.selected_tool == DataTypes.Tools.PlantWheat or ToolManager.selected_tool == DataTypes.Tools.PlantTomato:
			get_cell_under_mouse()
			add_crop()
			
func get_cell_under_mouse() -> void: 
	mouse_position = tilled_dirt_tile_map_layer.get_local_mouse_position()
	cell_position = tilled_dirt_tile_map_layer.local_to_map(mouse_position)
	cell_source_id = tilled_dirt_tile_map_layer.get_cell_source_id(cell_position)
	local_cell_position = tilled_dirt_tile_map_layer.map_to_local(cell_position)
	distance = player.global_position.distance_to(local_cell_position)
	
func add_crop() -> void: 
	if distance < 20.0:
		if ToolManager.selected_tool == DataTypes.Tools.PlantWheat: 
			var wheat_instance = wheat_plant_scene.instantiate() as Node2D
			wheat_instance.global_position = local_cell_position
			get_parent().find_child("CropFields").add_child(wheat_instance)
			print("wheat planted")
			
		if ToolManager.selected_tool == DataTypes.Tools.PlantTomato:
			var tomato_instance = tomato_plant_scene.instantiate() as Node2D
			tomato_instance.global_position = local_cell_position
			get_parent().find_child("CropFields").add_child(tomato_instance)
			print("tomato planted")
			
func remove_crop() -> void: 
	if distance < 20.0: 
		var crop_nodes = get_parent().find_child("CropFields").get_children()
		
		for node: Node2D in crop_nodes:
			if node.global_position == local_cell_position:
				node.queue_free()
