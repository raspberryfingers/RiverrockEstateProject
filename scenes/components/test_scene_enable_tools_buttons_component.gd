# test_scene_enable_tools_component.gd
# This component enables specific tool buttons in the ToolManager when the scene is ready.
# It uses call_deferred to ensure ToolManager is fully initialised before enabling tools.
extends Node

func _ready() -> void:
	# Defer enabling tool buttons to avoid initialisation order issues
	call_deferred("enable_tool_buttons")

	
func enable_tool_buttons() -> void: 
	# Enable the tool buttons in ToolManager for the specified tools 
	ToolManager.enable_tool_button(DataTypes.Tools.TillGround)
	ToolManager.enable_tool_button(DataTypes.Tools.WaterCrops)
	ToolManager.enable_tool_button(DataTypes.Tools.PlantTomato)
	ToolManager.enable_tool_button(DataTypes.Tools.PlantWheat)
