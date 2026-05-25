extends Node2D

signal gameWin

var _game_ready = false
var _item_grabbed: GameConstants.ITEMS = GameConstants.ITEMS.NONE

# The three fixed X positions where food can appear
var food_positions = [162.0, 578.0, 1026.0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Crane.connect("grabbed_item", Callable(self, "_on_crane_grabbed"))
	randomize_food_positions()

func randomize_food_positions():
	# Shuffle the positions array
	food_positions.shuffle()
	
	# Get references to the food items
	var foods = [$Food1, $Food2, $Food3]
	
	# Assign shuffled positions to each food item
	for i in range(foods.size()):
		foods[i].position.x = food_positions[i]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	$showGameTimer.set_text(str($Timer.get_time_left()).pad_decimals(1))
	if !Input.is_action_just_pressed("Interact"):
		_game_ready = true
	elif _game_ready:
		$Crane.drop()  #calls crane drop fn

func _on_crane_grabbed(item):
	_item_grabbed = item.item_value
	gameWin.emit()

func _on_time_limit_timeout() -> void:
	GameController.close_puzzle()


func _on_button_pressed() -> void:
	GameController.close_puzzle()


func _on_game_win() -> void: #trigger by using gameWin.emit()
	#add item to players inventory (Robert/Connor will sort out)
	GameController.close_puzzle()
	PlayerInventory.add_item(_item_grabbed)
