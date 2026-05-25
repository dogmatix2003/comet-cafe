extends Node2D

signal gameWin

var cubes_in_frame = 0

#variables to tell if a tray is alreay taken
var tray1_full = false
var tray2_full = false
var tray3_full = false
var tray4_full = false
var tray5_full = false
var tray6_full = false

var trayFullArray
var locationArray
var trayCapacity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$showGameTimer.set_text(str($"time limit".get_time_left()).pad_decimals(1))

func _ready() -> void:
	
	var rng = RandomNumberGenerator.new()
	var cubeTray = rng.randi_range(1,3)

	if cubeTray == 1:
		trayFullArray = [false,false,false,false,false] # one bool per ice tray spot
		locationArray = [$CubeOutlines1/tray1, $CubeOutlines1/tray2, $CubeOutlines1/tray3, $CubeOutlines1/tray4, $CubeOutlines1/tray5]
		trayCapacity = 5
		$CubeOutlines1.position = Vector2(250,500)
	elif cubeTray ==  2:
		trayFullArray = [false, false, false, false, false, false]
		locationArray = [$CubeOutlines2/tray1, $CubeOutlines2/tray2, $CubeOutlines2/tray3, $CubeOutlines2/tray4, $CubeOutlines2/tray5, $CubeOutlines2/tray6]
		trayCapacity = 6
		$CubeOutlines2.position = Vector2(250,500)
	else:
		trayFullArray = [false, false, false, false, false]
		locationArray = [$CubeOutlines3/tray1, $CubeOutlines3/tray2, $CubeOutlines3/tray3, $CubeOutlines3/tray4, $CubeOutlines3/tray5]
		trayCapacity = 5
		$CubeOutlines3.position = Vector2(250,500)

func _on_time_limit_timeout() -> void:
	GameController.close_puzzle()


func _on_button_pressed() -> void:
	GameController.close_puzzle()


func _on_game_win() -> void: #trigger by using gameWin.emit()
	#add item to players inventory (Robert/Connor will sort out)
	GameController.close_puzzle()
	if PlayerInventory.contains_any_of([GameConstants.ITEMS.COFFEE]):
		PlayerInventory.replace_item(GameConstants.ITEMS.COFFEE, GameConstants.ITEMS.ICED_COFFEE)

func on_item_dropped(item: Node) -> void:
	for index in range(locationArray.size()):
		if locationArray[index].overlaps_area(item):
			if item.locked == false && trayFullArray[index] ==  false:
				item.locked = true
				trayFullArray[index] = true
				cubes_in_frame += 1
				item.set_global_position(locationArray[index].global_position)
	
	if cubes_in_frame >= trayCapacity:
		gameWin.emit()

func temp(item) -> void:
	#print(item.locked)
	var over_tray1: bool = $CubeOutlines1/tray1.overlaps_area(item)
	var over_tray2: bool = $CubeOutlines1/tray2.overlaps_area(item)
	var over_tray3: bool = $CubeOutlines1/tray3.overlaps_area(item)
	var over_tray4: bool = $CubeOutlines1/tray4.overlaps_area(item)
	var over_tray5: bool = $CubeOutlines1/tray5.overlaps_area(item)
	
	if not item.locked:
		if over_tray1 && !tray1_full:
			item.locked = true
			tray1_full = true
			cubes_in_frame += 1
			item.set_global_position($CubeOutlines1/tray1.global_position)
		if over_tray2 && !tray2_full:
			item.locked = true
			tray2_full = true
			cubes_in_frame += 1
			item.set_global_position($CubeOutlines1/tray2.global_position)
		if over_tray3 && !tray3_full:
			item.locked = true
			tray3_full = true
			cubes_in_frame += 1
			item.set_global_position($CubeOutlines1/tray3.global_position)
		if over_tray4 && !tray4_full:
			item.locked = true
			tray4_full = true
			cubes_in_frame += 1
			item.set_global_position($CubeOutlines1/tray4.global_position)
		if over_tray5 && !tray5_full:
			item.locked = true
			tray5_full = true
			cubes_in_frame += 1
			item.set_global_position($CubeOutlines1/tray5.global_position)

	if cubes_in_frame >= trayCapacity:
		gameWin.emit()
