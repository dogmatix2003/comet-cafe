extends Label

func _day_updated():
	text = "Day: " + str(GameController.day)

func _ready() -> void:
	GameController.day_updated.connect(_day_updated)
	_day_updated()
