extends Area2D

#Script for moving basket

@export var speed := 350.0
var direction := 0

func _process(delta):
	direction = 0
	
	if Input.is_action_pressed("MoveLeft"):
		direction = -1
	if Input.is_action_pressed("MoveRight"):
		direction = 1
		
	position.x += direction * speed * delta
	
	position.x = clamp(position.x, 50, 1150)
