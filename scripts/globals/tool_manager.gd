# tool_manager.gd
# Manages the currently selected tool and enables UI buttons for tools.
extends Node

# Currently selected tool
var selected_tool: DataTypes.Tools = DataTypes.Tools.None

# Signals
signal tool_selected(tool: DataTypes.Tools) # Emitted when a tool is selected
signal enabled_tool(tool: DataTypes.Tools) # Emitted when a tool button is enabled

# Selects a tool and emits the selection signal
func select_tool(tool: DataTypes.Tools) -> void:
	tool_selected.emit(tool)
	selected_tool = tool 
	
	
# Enables a specific tool button in the UI
func enable_tool_button(tool: DataTypes.Tools) -> void:
	enabled_tool.emit(tool) 
	
