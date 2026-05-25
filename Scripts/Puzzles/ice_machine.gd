extends StaticBody2D

@onready var interaction_area: InteractionArea = $InteractionArea

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
	if (GameController.phase == GameConstants.PHASES.PREP):
		GameController.launch_puzzle("res://Scenes/Prep_puzzels/prep_Ice_machine.tscn")
	else:
		GameController.launch_puzzle("res://Scenes/Service_games/Service_Ice_Machine.tscn")
	#use await signal to know when mini game is finished
	#get_tree().change_scene_to_file(“file path”)
	#if else for deciding if the game is in service phase or not
