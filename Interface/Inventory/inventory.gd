extends Node

var items_VHS: Array
var items_Keys: Array = [["This is a key, it can't give birth", preload("res://Interface/Inventory/ItemIcons/key.png")]]
var items_Notes: Array
var items_Equipment: Array = []

func scan_list(list_name: String, item_name: String):
	var list: Array = get(list_name)
	
	if list == null:
		return false
	var found_item = false
	for i in list.size():
		if list[i][0] == item_name:
			found_item = true
	return found_item

func remove_item(list_name: String, item_name: String):
	var list: Array = get(list_name)
	
	for i in list.size():
		if list[i][0] == item_name:
			list.remove_at(i)
