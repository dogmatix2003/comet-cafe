extends Node2D

signal gameWin

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$showGameTimer.set_text(str($"Puzzel time limit".get_time_left()).pad_decimals(1))


func _on_puzzel_time_limit_timeout() -> void:
	Input.set_custom_mouse_cursor(null)
	GameController.close_puzzle()


func _on_button_pressed() -> void:
	Input.set_custom_mouse_cursor(null)
	GameController.close_puzzle()
	
	

func _on_character_body_2d_game_win() -> void: #trigger by using gameWin.emit()
	Input.set_custom_mouse_cursor(null)
	GameController.close_puzzle()
	GameController.station_repaired("IceMachine")
