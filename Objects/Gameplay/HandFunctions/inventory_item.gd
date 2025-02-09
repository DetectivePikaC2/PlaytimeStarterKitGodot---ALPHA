extends Node
class_name InventoryItem

enum tabs {
	Keys,
	VHS,
	Notes,
	Equipment
}
@export var item_type = tabs.Keys
@export var item_name: String = "none"
@export var item_has_description: bool = false
@export var item_description: String = "none"
@export var item_image: Texture2D

func add_to_inventory():
	var list: String = tabs.keys()[item_type]
	var item_array: Array = Inventory.get(str("items_", list))
	
	if item_has_description:
		item_array.append([item_name, item_image, item_description])
	else:
		item_array.append([item_name, item_image])
