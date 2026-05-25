extends Node2D

signal gameWin

@export var good_bean: String
@export var bad_beans: Array[String]

@onready var message_label: Label = $Label
@onready var trash_area: Area2D = $TrashArea
@onready var positions: Node2D = $Positions

const BAD_ITEMS_TOTAL := 4
var bad_items_trashed: int = 0

func _add_good_bean(node: Node2D):
	var good_bean = load(good_bean).instantiate()
	node.add_child(good_bean)

func _add_bad_bean(node: Node2D):
	var choice = randi_range(0, len(bad_beans) - 1)
	var bad_bean = load(bad_beans[choice]).instantiate()
	node.add_child(bad_bean)

func _ready() -> void:
	add_to_group("prep_puzzle_root")
	if message_label:
		message_label.text = ""
	var bad_beans_added = 0
	var good_beans_added = 0
	for pos in positions.get_children():
		if good_beans_added >= BAD_ITEMS_TOTAL:
			_add_bad_bean(pos)
			bad_beans_added += 1
			continue
		if bad_beans_added >= BAD_ITEMS_TOTAL:
			_add_good_bean(pos)
			good_beans_added += 1
			continue
		var coin_flip = randi_range(0,1)
		if coin_flip == 1:
			_add_good_bean(pos)
			good_beans_added += 1
		else:
			_add_bad_bean(pos)
			bad_beans_added += 1


func _process(delta: float) -> void:
	$showGameTimer.set_text(str($"Puzzel time limit".get_time_left()).pad_decimals(1))


func _on_puzzel_time_limit_timeout() -> void:
	GameController.close_puzzle()


func _on_button_pressed() -> void:
	GameController.close_puzzle()


func _on_game_win() -> void:
	GameController.close_puzzle()
	GameController.station_repaired("CoffeeMachine")


func on_item_dropped(item: Node) -> void:
	if not item.has_method("reset"):
		return

	var is_good: bool = item.is_good
	var is_over_trash: bool = trash_area.overlaps_area(item)

	if is_over_trash:
		if is_good:
			_show_message("Oops! you just threw a good bean in the trash, try again")
			_reset_puzzle()
		else:
			if not item.trashed:
				item.trashed = true
				item.visible = false
				bad_items_trashed += 1

				if bad_items_trashed >= BAD_ITEMS_TOTAL:
					gameWin.emit()
	# otherwise do nothing


func _reset_puzzle() -> void:
	bad_items_trashed = 0

	var items = get_tree().get_nodes_in_group("draggable_item")
	for node in items:
		if node.has_method("reset"):
			node.reset()


func _show_message(text: String) -> void:
	if message_label:
		message_label.text = text
