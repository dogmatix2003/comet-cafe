extends Node2D

signal gameWin

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$showGameTimer.set_text(str($"time limit".get_time_left()).pad_decimals(1))


func _on_puzzel_time_limit_timeout() -> void:
	GameController.close_puzzle()


func _on_button_pressed() -> void:
	GameController.close_puzzle()


func _on_game_win() -> void: #trigger by using gameWin.emit()
	#add item to players inventory (Robert/Connor will sort out)
	await get_tree().create_timer(1).timeout
	GameController.close_puzzle()
	PlayerInventory.add_item(GameConstants.ITEMS.COFFEE)
