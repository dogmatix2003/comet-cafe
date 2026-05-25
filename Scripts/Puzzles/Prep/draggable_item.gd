extends Area2D

@export var is_good: bool = false

var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var start_position: Vector2 = Vector2.ZERO
var trashed: bool = false

@onready var puzzle_root: Node = get_tree().get_first_node_in_group("prep_puzzle_root")


func _ready() -> void:
	start_position = global_position
	add_to_group("draggable_item")


func reset() -> void:
	global_position = start_position
	trashed = false
	visible = true
	dragging = false


func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if trashed:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			drag_offset = global_position - event.position
		else:
			dragging = false
			if puzzle_root and puzzle_root.has_method("on_item_dropped"):
				puzzle_root.on_item_dropped(self)


func _process(delta: float) -> void:
	if dragging:
		var mouse_pos: Vector2 = get_viewport().get_mouse_position()
		global_position = mouse_pos + drag_offset
