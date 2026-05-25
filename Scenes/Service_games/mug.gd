extends Area2D

@export var move_speed: float = 300.0   # not strictly needed for dragging, but you can ignore/remove

# Fill level from 0 (empty) to 4 (full)
var _fill_level: int = 0

@onready var sprite: Sprite2D = $Sprite2D

@export var mug_empty: Texture2D
@export var mug_level_1: Texture2D
@export var mug_level_2: Texture2D
@export var mug_level_3: Texture2D
@export var mug_level_4: Texture2D

var _dragging: bool = false
var _drag_offset: Vector2 = Vector2.ZERO


func _ready() -> void:
	_update_sprite()


func _input(event: InputEvent) -> void:
	# Handle mouse press / release and movement for dragging

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Check if the click is on the mug's sprite
			var local_pos := to_local(event.position)
			if sprite.get_rect().has_point(local_pos):
				_dragging = true
				_drag_offset = global_position - event.position
		else:
			# Mouse button released
			_dragging = false

	elif event is InputEventMouseMotion and _dragging:
		# While dragging, update position
		global_position = event.position + _drag_offset


func add_coffee(amount: int) -> void:
	if _fill_level >= 4:
		return

	_fill_level += amount
	if _fill_level > 4:
		_fill_level = 4

	_update_sprite()

	if _fill_level == 4:
		get_parent().gameWin.emit()


func _update_sprite() -> void:
	match _fill_level:
		0:
			sprite.texture = mug_empty
		1:
			sprite.texture = mug_level_1
		2:
			sprite.texture = mug_level_2
		3:
			sprite.texture = mug_level_3
		4:
			sprite.texture = mug_level_4
