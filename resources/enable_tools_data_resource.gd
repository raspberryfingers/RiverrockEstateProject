# enable_tools_data_resource.gd
# A resource class for saving and loading the state of unlocked tools.
class_name EnableToolsDataResource
extends NodeDataResource

# Stores a list of unlocked tools.
# DataTypes.Tools is assumed to be an enum or custom type representing tools.
@export var unlocked_tools: Array[DataTypes.Tools] = []

# Save the current unlocked tools from the ToolManager or a UI panel.
# This captures which tools were unlocked during gameplay.
func _save_data(source_node: Node) -> void:
	super._save_data(source_node)
	
	# Check if the source_node can provide the unlocked tools list.
	# Duplicate with "true" to ensure a deep copy, preventing accidental reference sharing.
	if source_node.has_method("get_unlocked_tools"):
		unlocked_tools = source_node.get_unlocked_tools().duplicate(true)

# Load the unlocked tools back into the ToolManager.
# This will reactivate the corresponding tool buttons when the game is resumed.
func _load_data(window: Window) -> void:
	# Get the node tied to this resource (if relevant to your save/load system).
	var scene_node = window.get_node_or_null(node_path)
	
	# Apply the saved unlocked tools back into the ToolManager.
	if ToolManager:
		for tool in unlocked_tools:
			ToolManager.enable_tool_button(tool)
