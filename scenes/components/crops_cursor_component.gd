# crops_cursor_component.gd
# Handles planting and removing crops on the tilled soil layer.
# Supports Wheat and Tomato crops, ensuring no overlap and distance restrictions.

class_name CropsCursorComponent
extends Node

# Editor Exports
@export var tilled_dirt_tile_map_layer: TileMapLayer  # TileMap layer representing tilled soil
@export var terrain_set: int = 0 # Terrain set ID used for planting
@export var terrain: int = 3 # Terrain type ID used for planting

# Internal Variables
var player: Node = null # Reference to the player node
var wheat_plant_scene = preload("res://scenes/objects/plants/wheat.tscn") # Wheat plant scene
var tomato_plant_scene = preload("res://scenes/objects/plants/tomato.tscn") # Tomato plant scene

var mouse_position: Vector2 # Mouse position relative to tilemap
var cell_position: Vector2i # Tile cell under mouse
var local_cell_position: Vector2 # World/local position for placing crops
var distance: float # Distance from player to targeted tile

# How close a crop must be to count as "on the same tile"
const CROP_SNAP_THRESHOLD: float = 8.0


func _ready() -> void:
	# Wait one frame to ensure all nodes are initialized
	await get_tree().process_frame
	# Get the first player node in the group
	player = get_tree().get_first_node_in_group("player")


func _unhandled_input(event: InputEvent) -> void:
	# Handle planting or removing crops based on input and selected tool
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
	# Convert mouse position to tile coordinates
	mouse_position = tilled_dirt_tile_map_layer.get_local_mouse_position()
	cell_position = tilled_dirt_tile_map_layer.local_to_map(mouse_position)
	local_cell_position = tilled_dirt_tile_map_layer.map_to_local(cell_position)

	# Calculate distance from player to tile for validation
	if player:
		var tile_world_pos = tilled_dirt_tile_map_layer.to_global(local_cell_position)
		distance = player.global_position.distance_to(tile_world_pos)
		local_cell_position = tile_world_pos
	else:
		distance = 9999.0  # Arbitrary large distance if player not found


func _is_tile_on_tilled_layer(cell_pos: Vector2i) -> bool:
	# Check if there is a tile at the specified cell in the tilled dirt layer
	var source_id = tilled_dirt_tile_map_layer.get_cell_source_id(cell_pos)
	return source_id != -1


func _crop_exists_at(pos: Vector2) -> bool:
	# Check if a crop already exists within the snap threshold
	var crop_fields = get_parent().get_node_or_null("CropFields")
	if crop_fields == null:
		return false

	for child in crop_fields.get_children():
		if child is Node2D and child.global_position.distance_to(pos) <= CROP_SNAP_THRESHOLD:
			return true
	return false


func _add_crop() -> void:
	# Only plant if player is close enough and the tile is tilled
	if distance < 20.0 and _is_tile_on_tilled_layer(cell_position):
		# Prevent planting if a crop already exists at this position
		if _crop_exists_at(local_cell_position):
			print("Cannot plant: crop already exists at that tile.")
			return

		var instance: Node2D = null
		# Instantiate the correct crop based on selected tool
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
		# Inform player why planting failed
		if distance >= 20.0:
			print("Too far to plant. Distance:", distance)
		elif not _is_tile_on_tilled_layer(cell_position):
			print("Not tilled soil at cell:", cell_position)


func _remove_crop() -> void:
	# Only remove crops if player is close enough
	if distance < 20.0:
		var crop_fields = get_parent().get_node_or_null("CropFields")
		if crop_fields == null:
			return
		for node in crop_fields.get_children():
			if node is Node2D and node.global_position.distance_to(local_cell_position) <= CROP_SNAP_THRESHOLD:
				node.queue_free()
				print("Crop removed at cell:", cell_position)
				return
