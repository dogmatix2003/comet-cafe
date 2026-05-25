extends CharacterBody2D

signal gameWin

var noIce = load("res://Assets/PuzzleSprites/Ice_Machine_Lock_Puzzle/ice_box_door_zoom_2_open.png")
var phase2 = false

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if InteractionManager.num_dead > 8 && phase2 == false:
		$"lock sprite".texture = noIce
		phase2 = true


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if phase2 == true:
		if event is InputEventMouseButton && InteractionManager.is_pickaxe == false:
			phase2 = false #reset the var just incase
			gameWin.emit()
