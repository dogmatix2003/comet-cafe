extends Node

enum PHASES {PREP, SERVICE}

## An enum of items, each item stage is defined as a different item
## Note: Contains a NONE value as well because GDScript doesn't have nullable typing
## 		 The NONE value should only be used for assertions and not stored as an instance of an item
enum ITEMS {NONE, COFFEE, ICED_COFFEE, COOKIE, CAKE, COLD_SANDWICH, SANDWICH}

func item_to_tileset_pos(value: ITEMS) -> Vector2i:
	var item_to_tile = {
		GameConstants.ITEMS.COFFEE: Vector2i(11, 2),
		GameConstants.ITEMS.ICED_COFFEE: Vector2i(11, 8),
		GameConstants.ITEMS.COOKIE: Vector2i(17, 8),
		GameConstants.ITEMS.CAKE: Vector2i(17, 2),
		GameConstants.ITEMS.COLD_SANDWICH: Vector2i(23, 8),
		GameConstants.ITEMS.SANDWICH: Vector2i(23, 2),
	}
	if not value in item_to_tile:
		return Vector2i(0, 0)
	return item_to_tile[value]

func enum_to_string(enum_type, value) -> String:
	return enum_type.keys()[value].capitalize()

func item_to_string(value: ITEMS) -> String:
	return enum_to_string(ITEMS, value)
	
func phase_to_string(value: PHASES) -> String:
	return enum_to_string(PHASES, value)

const item_tileset_left_bubble_pos = Vector2i(0, 0)
const item_tileset_right_bubble_pos = Vector2i(8, 0)
const item_tileset_top_bubble_pos = Vector2i(2, 0)
const item_tileset_bottom_bubble_pos = Vector2i(2, 8)
