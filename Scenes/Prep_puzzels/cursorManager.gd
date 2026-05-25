extends Node

var pickaxe = load("res://Assets/PuzzleSprites/Ice_Machine_Lock_Puzzle/pickaxe_cursor.png")
var key = load("res://Assets/PuzzleSprites/Ice_Machine_Lock_Puzzle/key_cursor.png")

#InteractionManger is used to alow comunication between the target and the scene

func _on_select_pickaxe_pressed() -> void:
	Input.set_custom_mouse_cursor(pickaxe)
	InteractionManager.is_pickaxe = true


func _on_select_key_pressed() -> void:
	Input.set_custom_mouse_cursor(key)
	InteractionManager.is_pickaxe = false
