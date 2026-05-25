extends Node2D

# These are now min/max speed instead of a single fixed value
@export var min_speed: float = 250.0
@export var max_speed: float = 650.0

@export var left_limit: float = -70.0
@export var right_limit: float = 100.0

@onready var coffee_area: Area2D = $CoffeeArea
@onready var pour_timer: Timer = $PourTimer

var _direction: float = 1.0
var _mug_in_stream: bool = false
var _mug: Area2D = null

var _rng := RandomNumberGenerator.new()
var move_speed: float = 150.0  # actual current speed


func _ready() -> void:
	_rng.randomize()
	_randomize_speed()

	if coffee_area == null:
		push_error("Spout.gd: Could not find child node 'CoffeeArea'.")
	else:
		coffee_area.area_entered.connect(_on_coffee_area_area_entered)
		coffee_area.area_exited.connect(_on_coffee_area_area_exited)

	if pour_timer == null:
		push_error("Spout.gd: Could not find child node 'PourTimer'.")
	else:
		pour_timer.timeout.connect(_on_pour_timer_timeout)
		pour_timer.start()


func _process(delta: float) -> void:
	position.x += _direction * move_speed * delta

	# When we hit a boundary, flip direction AND randomize speed
	if position.x < left_limit:
		position.x = left_limit
		_direction = 1.0
		_randomize_speed()
	elif position.x > right_limit:
		position.x = right_limit
		_direction = -1.0
		_randomize_speed()


func _randomize_speed() -> void:
	move_speed = _rng.randf_range(min_speed, max_speed)
	# print("New spout speed:", move_speed)  # uncomment to debug


func _on_coffee_area_area_entered(area: Area2D) -> void:
	if area.name == "Mug":
		_mug_in_stream = true
		_mug = area


func _on_coffee_area_area_exited(area: Area2D) -> void:
	if area == _mug:
		_mug_in_stream = false
		_mug = null


func _on_pour_timer_timeout() -> void:
	if _mug_in_stream and _mug != null:
		_mug.add_coffee(1)
