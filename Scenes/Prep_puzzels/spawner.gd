extends Node2D

@export var point1: Vector2 = Vector2(240,151) #position of the lock sprite
@export var point2: Vector2 = Vector2(464,444) #positoon of the lock sprite + its dimentions multiplyed by its scale

@onready var target: Resource = preload("res://Scenes/Prep_puzzels/clickableCircle.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_random_point_inside(p1: Vector2, p2: Vector2) -> Vector2:
	var x_value: float = randf_range(p1.x, p2.x)
	var y_value: float = randf_range(p1.y, p2.y)
	
	var random_point: Vector2 = Vector2(x_value, y_value)
	
	return random_point

func spawn():
	var target_instance: Node = target.instantiate()
	add_child(target_instance)
	
	var spawn_location: Vector2 = get_random_point_inside(point1, point2)
	target_instance.set_position(spawn_location)


func _on_target_spawn_timeout() -> void:
	if !(InteractionManager.num_dead > 8):
		spawn()
