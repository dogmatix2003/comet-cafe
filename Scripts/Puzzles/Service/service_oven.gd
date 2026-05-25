extends Node2D

signal gameWin

var buttonDown
var buttonUp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buttonDown = load("res://Assets/PuzzleSprites/OvenServicePuzzle/ButtonPressed.png")
	buttonUp = load("res://Assets/PuzzleSprites/OvenServicePuzzle/Button.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$showGameTimer.set_text(str($"time limit".get_time_left()).pad_decimals(1))
	var rotation = $Pin.get_global_rotation()
	if (rotation + PI/256) > 1.81:
		rotation = 1.81
	else:
		rotation += PI/256
	$Pin.set_global_rotation(rotation)
	
	if rotation < -1.1:
		$greenZoneTimer.set_paused(false)
	else:
		$greenZoneTimer.set_paused(true)


func _on_puzzel_time_limit_timeout() -> void:
	GameController.close_puzzle()


func _on_button_pressed() -> void:
	GameController.close_puzzle()


func _on_game_win() -> void: #trigger by using gameWin.emit()
	#add item to players inventory (Robert/Connor will sort out)
	GameController.close_puzzle()
	if PlayerInventory.contains_any_of([GameConstants.ITEMS.COLD_SANDWICH]):
		PlayerInventory.replace_item(GameConstants.ITEMS.COLD_SANDWICH, GameConstants.ITEMS.SANDWICH)

func _on_add_heat_button_button_down() -> void:
	$addHeatButton.set_button_icon(buttonDown)

func _on_add_heat_button_button_up() -> void:
	$addHeatButton.set_button_icon(buttonUp)

func _on_add_heat_button_pressed() -> void:
	var rotation = $Pin.get_global_rotation()
	if (rotation - PI/12) < -1.72:
		rotation = -1.73
	else:
		rotation -= PI/12
	$Pin.set_global_rotation(rotation)

func _on_green_zone_timer_timeout() -> void:
	gameWin.emit()
