extends Node2D

signal gameWin

@export var collected := 0
@export var needed_boxes := 7


# Called when the node enters the scene tree for the first time.
func _ready():
	#starting to spawn boxes
	
	$BoxSpawner.start()
	$BadBoxSpawner.start()
	
	$Basket.connect("area_shape_entered", Callable(self, "_on_Basket_area_shape_entered"))

func _process(delta: float) -> void:
	$showGameTimer.set_text(str($"puzzle time limit".get_time_left()).pad_decimals(1))

#Creating a box for each box spawn
func on_box_spawn():
	#new box instance
	var box = preload("res://Scenes/Prep_puzzels/box.tscn").instantiate() 
	
	
	#spawned at random x position
	box.position = Vector2(randi() % 1100 + 50, -50)
	
	
	$Boxes.add_child(box)
	
#Creating a bad box for each badBox spawn
func on_bad_box_spawn() -> void:
	var badBox = preload("res://Scenes/Prep_puzzels/badBox.tscn").instantiate()
	
	badBox.position = Vector2(randi() % 1100 + 50, -50)
	
	$BadBoxes.add_child(badBox)

#Catching boxes
func _on_Basket_area_shape_entered(area: Area2D) -> void:
	
	#Boxes are in the "box" group, so checks if collision is in that group
	if area.is_in_group("box"):
		area.queue_free()
		collected += 1
		#Updating the label so player knows how many boxes left
		get_node("Label")._label_Update()
		
		if collected == needed_boxes:
			$WinTimer.start()
	
	if area.is_in_group("badBoxes"):
		area.queue_free()
		collected -= 1
		#Updating the label so player knows how many boxes left
		get_node("Label")._label_Update()
		
		if collected == needed_boxes:
			$WinTimer.start()
		
		

func _on_puzzle_time_limit_timeout() -> void:
	GameController.close_puzzle()


func _on_button_pressed() -> void:
	GameController.close_puzzle()

func _on_game_win() -> void: #trigger by using gameWin.emit()
	#fix machine (Robert/Connor will sort out)
	GameController.close_puzzle()
	GameController.station_repaired("FoodDisplay")


func on_win() -> void:
	emit_signal("gameWin")
