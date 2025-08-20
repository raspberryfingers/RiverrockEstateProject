# data_types.gd
# Centralised enum definitions for tools and crop growth states used throughout the game.
class_name DataTypes

# Enum representing the different tools the player can use
enum Tools {
	None, # No tool selected
	AxeWood, # Axe for chopping wood
	TillGround, # Tool for tilling soil
	WaterCrops, # Watering can for crops
	PlantWheat, # Tool to plant wheat
	PlantTomato # Tool to plant tomatoes
}

# Enum representing the growth stages of crops
enum GrowthStates {
	Seed, # Just planted seed
	Germination, # Seed sprouting
	Vegetative, # Growing leaves/stems
	Reprofuction, # Flowering or pre-fruiting stage 
	Maturity, # Fully grown, ready to harvest
	Harvesting # Harvesting stage
}
