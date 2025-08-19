# tilemap_layer_data_resource.gd
# A resource class for saving and loading tilemap layer data.
# Extends NodeDataResource to also include base node info (paths, position, etc.).

class_name TilemapLayerDataResource
extends NodeDataResource

# Stores the list of cells used in this tilemap layer.
@export var tilemap_layer_used_cells: Array[Vector2i] = []

# Terrain set index (used by TileMap terrain system).
@export var terrain_set: int = 0

# Terrain index within the terrain set.
@export var terrain: int = 1


# Save the current tilemap layer data.
# Captures all used cells from the source TileMapLayer node.
func _save_data(source_node: Node) -> void: 
	super._save_data(source_node)
	
	# Ensure we are working with a TileMapLayer node.
	var tilemap_layer: TileMapLayer = source_node as TileMapLayer
	if tilemap_layer:
		# Get all used cells in the layer and store them.
		tilemap_layer_used_cells = tilemap_layer.get_used_cells()


# Load the saved tilemap layer data back into the scene.
# Restores cells and applies terrain connectivity.
func _load_data(window: Window) -> void: 
	# Retrieve the saved node from the scene tree.
	var scene_node: Node = window.get_node_or_null(node_path)
	
	if scene_node:
		var tilemap_layer: TileMapLayer = scene_node as TileMapLayer
		if tilemap_layer:
			# Restore the saved terrain configuration for all used cells.
			tilemap_layer.set_cells_terrain_connect(
				tilemap_layer_used_cells, 
				terrain_set, 
				terrain, 
				true
			)
