class_name CropsCursorComponent
extends Node

@export var tilled_dirt_tile_map_layer: TileMapLayer
@export var terrain_set: int = 0
@export var terrain: int = 3

var player: Node = null

var wheat_plant_scene = preload("res://scenes/objects/plants/wheat.tscn")
var tomato_plant_scene = preload("res://scenes/objects/plants/tomato.tscn")

var mouse_position: Vector2
var cell_position: Vector2i
var local_cell_position: Vector2
var distance: float

# How close a crop must be to count as "on the same tile"
const CROP_SNAP_THRESHOLD: float = 8.0


func _ready() -> void:
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("remove_dirt") and ToolManager.selected_tool == DataTypes.Tools.TillGround:
		_get_cell_under_mouse()
		_remove_crop()
	elif event.is_action_pressed("hit") and (
		ToolManager.selected_tool == DataTypes.Tools.PlantWheat
		or ToolManager.selected_tool == DataTypes.Tools.PlantTomato
	):
		_get_cell_under_mouse()
		_add_crop()


func _get_cell_under_mouse() -> void:
	# local mouse position relative to the tilemap
	mouse_position = tilled_dirt_tile_map_layer.get_local_mouse_position()
	cell_position = tilled_dirt_tile_map_layer.local_to_map(mouse_position)
	# map_to_local gives a position relative to the tilemap node; convert to global
	local_cell_position = tilled_dirt_tile_map_layer.map_to_local(cell_position)
	# if it needs the global position to place nodes in world coordinates, convert:
	# var world_pos = tilled_dirt_tile_map_layer.to_global(local_cell_position)
	# distance to player (player.global_position should exist)
	if player:
		# use global position of the tile for distance calculation
		var tile_world_pos = tilled_dirt_tile_map_layer.to_global(local_cell_position)
		distance = player.global_position.distance_to(tile_world_pos)
		# store the tile_world_pos for placement
		local_cell_position = tile_world_pos
	else:
		distance = 9999.0


func _is_tile_on_tilled_layer(cell_pos: Vector2i) -> bool:
	# Simple presence check: the tilled dirt tilemap layer must have a tile at this cell
	# get_cell_source_id returns -1 when there's no tile
	var source_id = tilled_dirt_tile_map_layer.get_cell_source_id(cell_pos)
	return source_id != -1


func _crop_exists_at(pos: Vector2) -> bool:
	var crop_fields = get_parent().get_node_or_null("CropFields")
	if crop_fields == null:
		return false
	for child in crop_fields.get_children():
		if child is Node2D:
			# compare world distance so small float offsets won't break exact equality
			if child.global_position.distance_to(pos) <= CROP_SNAP_THRESHOLD:
				return true
	return false


func _add_crop() -> void:
	# Must be close enough to the tile and the tile must exist on the tilled dirt layer
	if distance < 20.0 and _is_tile_on_tilled_layer(cell_position):
		# do not plant if a crop already exists on this tile
		if _crop_exists_at(local_cell_position):
			print("Cannot plant: crop already exists at that tile.")
			return


		var instance: Node2D = null
		if ToolManager.selected_tool == DataTypes.Tools.PlantWheat:
			instance = wheat_plant_scene.instantiate() as Node2D
		elif ToolManager.selected_tool == DataTypes.Tools.PlantTomato:
			instance = tomato_plant_scene.instantiate() as Node2D

		if instance:
			instance.global_position = local_cell_position
			var crop_fields = get_parent().get_node_or_null("CropFields")
			if crop_fields:
				crop_fields.add_child(instance)
				print("Planted at cell:", cell_position)
			else:
				push_error("CropFields node not found under parent: " + str(get_parent()))
	else:
		if distance >= 20.0:
			print("Too far to plant. Distance:", distance)
		elif not _is_tile_on_tilled_layer(cell_position):
			print("Not tilled soil at cell:", cell_position)


func _remove_crop() -> void:
	if distance < 20.0:
		var crop_fields = get_parent().get_node_or_null("CropFields")
		if crop_fields == null:
			return
		for node in crop_fields.get_children():
			if node is Node2D:
				if node.global_position.distance_to(local_cell_position) <= CROP_SNAP_THRESHOLD:
					node.queue_free()
					print("Crop removed at cell:", cell_position)
					return
