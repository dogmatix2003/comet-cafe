extends TileMapLayer

func _ready() -> void:
	PlayerInventory.inventory_updated.connect(_update_display)
	_update_display()

func _update_display():
	clear()
	
	var inventory = PlayerInventory.get_raw()
	
	var max_display = min(4, inventory.size())
	
	for i in range(max_display):
		var item = inventory[i]
		set_cell(Vector2i(0, i * 6), 0, GameConstants.item_to_tileset_pos(item))
