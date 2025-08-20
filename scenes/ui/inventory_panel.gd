# inventory_panel.gd
# Updates the UI labels to reflect the current inventory.
extends Panel

# References to the UI labels for each inventory item
@onready var log_label: Label = $MarginContainer/VBoxContainer/Logs/LogLabel
@onready var coin_label: Label = $MarginContainer/VBoxContainer/Coins/CoinLabel
@onready var stone_label: Label = $MarginContainer/VBoxContainer/Stones/StoneLabel
@onready var eggs_label: Label = $MarginContainer/VBoxContainer/Eggs/EggsLabel
@onready var milk_label: Label = $MarginContainer/VBoxContainer/Milk/MilkLabel
@onready var wheat_label: Label = $MarginContainer/VBoxContainer/Wheat/WheatLabel
@onready var tomato_label: Label = $MarginContainer/VBoxContainer/Tomatoes/TomatoLabel

func _ready() -> void:
	# Connect to the inventory_changed signal so the UI updates whenever inventory changes
	InventoryManager.inventory_changed.connect(on_inventory_changed)

	
func on_inventory_changed() -> void: 
	# Get the current inventory dictionary
	var inventory: Dictionary = InventoryManager.inventory
	
	# Update each label if the corresponding item exists in the inventory
	if inventory.has("coin"):
		coin_label.text = str(inventory["coin"])
		
	if inventory.has("log"): 
		log_label.text = str(inventory["log"])
		
	if inventory.has("stone"):
		stone_label.text = str(inventory["stone"])
		
	if inventory.has("eggs"):
		eggs_label.text = str(inventory["eggs"])
		
	if inventory.has("milk"):
		milk_label.text = str(inventory["milk"])
		
	if inventory.has("wheat"):
		wheat_label.text = str(inventory["wheat"])
		
	if inventory.has("tomato"):
		tomato_label.text = str(inventory["tomato"])
