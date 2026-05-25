extends CharacterBody2D

var _animated_sprite: AnimatedSprite2D

@export var SPEED = 400
	
func _ready():
	_animated_sprite = get_node("AnimatedSprite2D")

func _calculate_facing(input_direction: Vector2):
	if abs(input_direction.x) > abs(input_direction.y):
		if input_direction.x > 0:
			_animated_sprite.rotation_degrees = 90
		elif input_direction.x < 0:
			_animated_sprite.rotation_degrees = 270
	else:
		if input_direction.y > 0:
			_animated_sprite.rotation_degrees = 180
		elif input_direction.y < 0:
			_animated_sprite.rotation_degrees = 0

func _physics_process(delta: float) -> void:
	if !GameController.puzzle_active:
		var input_direction = Input.get_vector("MoveLeft", "MoveRight", "MoveUp", "MoveDown")
		velocity = input_direction * SPEED
		
		_calculate_facing(input_direction)
		
		move_and_slide()
