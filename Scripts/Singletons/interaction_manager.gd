extends Node2D
#made with help from https://www.youtube.com/watch?v=ajCraxGAeYU

#some vars for prep_Ice_Machine
var is_pickaxe = false #reffers to whether the mouse icon is a pickaxe or not
var num_dead = 0 #reffers to how many circles have been clicked on

@onready var player =  get_tree().get_first_node_in_group("player")
@onready var label = $Label

const base_text = "[E] to "

var active_areas = []
var can_interact = true

func register_area(area: InteractionArea):
	#check if in prep phase, if so check if given area is broken
	active_areas.push_back(area)

func unregister_area(area: InteractionArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)


func _process(delta):
	if active_areas.size() > 0 && can_interact:
		#active_areas.sort_custom(_sort_by_distance_to_player)
		label.text = base_text + active_areas[0].action_name
		label.global_position.y = active_areas[0].global_position.y - 36
		label.global_position.x = active_areas[0].global_position.x - (label.size.x / 2)
		label.show()
	else:
		label.hide()
	

#func _sort_by_distance_to_player(area1, area2):
	#var area1_to_player = player.global_position.distance_to(area1.global_position)
	#var area2_to_player = player.global_position.distance_to(area2.global_position)
	#return area1_to_player < area2_to_player

func _input(event):
	if event.is_action_pressed("Interact") && can_interact && !GameController.puzzle_active:
		if active_areas.size() > 0:
			can_interact = false
			label.hide()
			
			await active_areas[0].interact.call()
			
			can_interact = true
