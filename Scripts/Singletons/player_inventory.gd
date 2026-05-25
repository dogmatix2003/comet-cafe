extends Node

signal inventory_updated

var _inventory_data: Array[GameConstants.ITEMS] = []

## Returns the first item in the provided array that exists in the inventory
## If no item in the provided array exists in the inventory, returns GameConstants.ITEMS.NONE
func contains_any_of(items: Array[GameConstants.ITEMS]) -> GameConstants.ITEMS:
	for search_item in items:
		if search_item in _inventory_data:
			return search_item
	return GameConstants.ITEMS.NONE

## Returns true if the inventory contains all items in the provieded array, false otherwise
func constains_all_of(items: Array[GameConstants.ITEMS]) -> bool:
	for search_item in items:
		if search_item not in _inventory_data:
			return false
	return true

## Removes a single instance of the provided item from the inventory
## Note: Will not do anything if the provided item doesn't exist in the inventory
func remove_item(item: GameConstants.ITEMS):
	_inventory_data.erase(item)
	inventory_updated.emit()

## Adds a single instance of the provided item to the inventory
## Note: Ignores GameConstants.ITEMS.NONE
func add_item(item: GameConstants.ITEMS):
	if item == GameConstants.ITEMS.NONE:
		return
	_inventory_data.append(item)
	inventory_updated.emit()

## Removes a single instance of each item in the provieded array from the inventory
## Note: Ignores items that don't exist in the inventory
func remove_all_of(items: Array[GameConstants.ITEMS]):
	for search_item in items:
		remove_item(search_item)

## Replaces the provided item_to_remove with the item_to_add in the inventory
## Note: Will add the provided item to the inventory even if the item_to_remove does not exist in the inventory
func replace_item(item_to_remove: GameConstants.ITEMS, item_to_add: GameConstants.ITEMS):
	remove_item(item_to_remove)
	add_item(item_to_add)

func clear() -> void:
	_inventory_data.clear()
	inventory_updated.emit()

func get_raw() -> Array[GameConstants.ITEMS]:
	return _inventory_data
	
func get_string() -> String:
	var output_string = ""
	for item in _inventory_data:
		output_string += GameConstants.item_to_string(item) + "\n"
	return output_string
