# save_game_data_resource.gd
# A container resource that stores all NodeDataResource instances for a save file.
# This acts as the root save data object which can be serialised/deserialised.
class_name SaveGameDataResource
extends Resource

# An array of NodeDataResource objects, each representing saved data for a node.
# Example: InventoryDataResource, DayCycleSaveDataResource, etc.
@export var save_data_nodes: Array[NodeDataResource]
