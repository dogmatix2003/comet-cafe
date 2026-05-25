extends Area2D

var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var locked = false

@onready var puzzle_root: Node = get_tree().get_first_node_in_group("service_puzzle_root")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dragging:
		var mouse_pos: Vector2 = get_viewport().get_mouse_position()
		global_position = mouse_pos + drag_offset

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if locked:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			drag_offset = global_position - event.position
		else:
			dragging = false
			puzzle_root.on_item_dropped(self)
