# tools_panel.gd
# Handles the UI for the player's tools, enabling/disabling buttons and selecting tools.
extends PanelContainer

# References to the tool buttons in the UI
@onready var tool_axe: Button = $MarginContainer/HBoxContainer/ToolAxe
@onready var tool_tilling: Button = $MarginContainer/HBoxContainer/ToolTilling
@onready var tool_watering_can: Button = $MarginContainer/HBoxContainer/ToolWateringCan
@onready var tool_wheat: Button = $MarginContainer/HBoxContainer/ToolWheat
@onready var tool_tomato: Button = $MarginContainer/HBoxContainer/ToolTomato


func _ready() -> void:
	# Connect to the ToolManager signal to enable buttons dynamically
	ToolManager.enabled_tool.connect(on_enable_tool_button) 
	
	# Disable all tools except the axe initially
	tool_tilling.disabled = true 
	tool_tilling.focus_mode = Control.FOCUS_NONE
	
	tool_watering_can.disabled = true 
	tool_watering_can.focus_mode = Control.FOCUS_NONE 
	
	tool_wheat.disabled = true 
	tool_wheat.focus_mode = Control.FOCUS_NONE 
	
	tool_tomato.disabled = true 
	tool_tomato.focus_mode = Control.FOCUS_NONE 


# Called when the Axe button is pressed
func _on_tool_axe_button_down() -> void:
	ToolManager.select_tool(DataTypes.Tools.AxeWood)


# Called when the Tilling button is pressed
func _on_tool_tilling_button_down() -> void:
	ToolManager.select_tool(DataTypes.Tools.TillGround)


# Called when the Watering Can button is pressed
func _on_tool_watering_can_button_down() -> void:
	ToolManager.select_tool(DataTypes.Tools.WaterCrops)


# Called when the Wheat planting button is pressed
func _on_tool_wheat_button_down() -> void:
	ToolManager.select_tool(DataTypes.Tools.PlantWheat)


# Called when the Tomato planting button is pressed
func _on_tool_tomato_button_down() -> void:
	ToolManager.select_tool(DataTypes.Tools.PlantTomato)


func _unhandled_input(event: InputEvent) -> void:
	# Right-click cancels any selected tool and releases focus from buttons
	if event is InputEventMouseButton: 
		if event.button_index == MOUSE_BUTTON_RIGHT:
			ToolManager.select_tool(DataTypes.Tools.None)
			tool_axe.release_focus()
			tool_tilling.release_focus()
			tool_wheat.release_focus()
			tool_tomato.release_focus()
			

# Enables a tool button when the ToolManager signals it is available
func on_enable_tool_button(tool: DataTypes.Tools) -> void: 
	if tool == DataTypes.Tools.TillGround: 
		tool_tilling.disabled = false 
		tool_tilling.focus_mode = Control.FOCUS_ALL
	elif tool == DataTypes.Tools.WaterCrops: 
		tool_watering_can.disabled = false 
		tool_watering_can.focus_mode = Control.FOCUS_ALL
	elif tool == DataTypes.Tools.PlantWheat: 
		tool_wheat.disabled = false 
		tool_wheat.focus_mode = Control.FOCUS_ALL
	elif tool == DataTypes.Tools.PlantTomato: 
		tool_tomato.disabled = false 
		tool_tomato.focus_mode = Control.FOCUS_ALL
