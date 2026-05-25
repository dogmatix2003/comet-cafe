extends Area2D

#Script for falling boxes

@export var fall_speed := 150.0

# Called when the node enters the scene tree for the first time.
func _process(delta):
	position.y += fall_speed * delta
	
	if position.y > 900:
		queue_free()
