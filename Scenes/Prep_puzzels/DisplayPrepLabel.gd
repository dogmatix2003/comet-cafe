extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "Collect " + str(get_parent().needed_boxes - get_parent().collected) + " boxes by using A and D"


func _label_Update() -> void:
	if (get_parent().needed_boxes - get_parent().collected == 0):
		text = "You got enough!"
	elif (get_parent().needed_boxes > get_parent().collected):
		text = "Collect " + str(get_parent().needed_boxes - get_parent().collected) + " boxes by using A and D"
