extends Node2D

signal gameWin

func _process(delta: float) -> void:
	$showGameTimer.set_text(str($"PuzzelTimeLimit".get_time_left()).pad_decimals(1))

func _on_puzzel_time_limit_timeout() -> void:
	GameController.close_puzzle()


func _on_button_pressed() -> void:
	GameController.close_puzzle()


func _on_tile_map_layer_game_win() -> void: #trigger by using gameWin.emit()
	#fix machine (Robert/Connor will sort out)
	$PuzzelTimeLimit.paused = true
	await get_tree().create_timer(10).timeout #lets the player realize they won
	GameController.close_puzzle()
	GameController.station_repaired("Oven")
