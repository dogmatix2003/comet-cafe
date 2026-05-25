extends Sprite2D

@export var prep_sprite: Resource
@export var service_sprite: Resource

func _phase_updated():
	if GameController.phase == GameConstants.PHASES.PREP:
		texture = prep_sprite
	else: 
		texture = service_sprite

func _ready() -> void:
	GameController.phase_updated.connect(_phase_updated)
	_phase_updated()
