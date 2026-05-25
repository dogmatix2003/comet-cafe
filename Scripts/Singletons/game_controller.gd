extends Node

signal phase_updated
signal day_updated

var phase: GameConstants.PHASES = GameConstants.PHASES.PREP
var day: int = 0

var _stations_repaired: int = 0
var _customers_served: int = 0
var _customers_left: int = 0
var _last_phase_change: float = 0
var _last_day_change: float = 0
var _last_customer_spawned: float = 0

var puzzle_active = false

const time_between_customers = 30

func get_customers_left_to_serve() -> int:
	return (get_customer_count() - _customers_served) - get_live_customers()

## Function that determines how many prep repairs are required
func get_prep_repairs() -> int:
	return 2

## Function that determines how many customers must be served on a given day
func get_customer_count() -> int:
	return floor(day + 2 + (float(day) / 3))

func station_repaired(machine_name: String) -> void:
	_stations_repaired += 1
	var machine = get_node("/root/Cafe/Enviroment/" + machine_name)
	machine.get_child(3).visible = false
	machine.get_child(2).set_enabled(false)
	if phase == GameConstants.PHASES.PREP && get_prep_repairs() <= _stations_repaired:
		_change_to_service_phase()

func _customer_rotation() -> void:
	if get_live_customers() > 1: # This is called before the customer is destroyed (because the customer calls it) so we have to account for it still being there
		_get_customer_container_node().get_child(1).set_active()

func customer_served() -> void:
	_customers_served += 1
	_customer_rotation()
	if phase == GameConstants.PHASES.SERVICE && get_customer_count() <= _customers_served:
		_change_to_prep_phase()

func _reset_game():
	phase = GameConstants.PHASES.PREP
	day = 0
	_stations_repaired = 0
	_customers_served = 0
	_customers_left = 0
	_last_phase_change = 0
	_last_day_change = 0
	_last_customer_spawned = 0
	PlayerInventory.clear()
	get_tree().reload_current_scene()

func customer_left() -> void:
	_customers_left += 1
	_customer_rotation()
	if _customers_left > 1:
		_reset_game()

func _ready():
	_change_to_prep_phase()

func _get_machines() -> Array[StaticBody2D]:
	return [get_node("/root/Cafe/Enviroment/FoodDisplay"), \
		get_node("/root/Cafe/Enviroment/CoffeeMachine"), \
		get_node("/root/Cafe/Enviroment/Oven"), \
		get_node("/root/Cafe/Enviroment/IceMachine")]

func _change_to_service_phase():
	_last_phase_change = Time.get_unix_time_from_system()
	_customers_served = 0
	phase = GameConstants.PHASES.SERVICE
	phase_updated.emit()
	for m in _get_machines():
		m.get_child(2).set_enabled(true)
	
func _change_to_prep_phase():
	_customers_left = 0
	_last_phase_change = Time.get_unix_time_from_system()
	_last_day_change = Time.get_unix_time_from_system()
	_stations_repaired = 0
	PlayerInventory.clear()
	day += 1
	day_updated.emit()
	phase = GameConstants.PHASES.PREP
	phase_updated.emit()
	var machines = _get_machines()
	for m in machines:
		m.get_child(3).visible = false
		m.get_child(2).set_enabled(false)
	for i in range(2):
		var m: StaticBody2D = machines.pop_at(randi_range(0, len(machines) - 1))
		m.get_child(3).visible = true
		m.get_child(2).set_enabled(true)

func _get_customer_container_node() -> Node2D:
	return get_node("/root/Cafe/Customers")

func get_live_customers() -> int:
	return _get_customer_container_node().get_child_count()

func _get_random_item() -> GameConstants.ITEMS:
	var choice = randi_range(1,len(GameConstants.ITEMS) - 1)
	return GameConstants.ITEMS.values()[choice]

func _decide_customer_order() -> Array[GameConstants.ITEMS]:
	var choice = randi_range(0,3)
	if choice > 1:
		choice -= 1
	choice += 1
	var order: Array[GameConstants.ITEMS] = []
	for i in range(choice):
		order.append(_get_random_item())
	return order

func _spawn_customer():
	var customer = load("res://Scenes/Customer.tscn").instantiate()
	var order: Array[GameConstants.ITEMS] = _decide_customer_order()
	customer.initialize(get_node("/root/Cafe/Enviroment/CustomerInteractionArea"), order, 20.0, 20)
	
	if get_live_customers() < 1:
		customer.set_active()
	
	_get_customer_container_node().add_child(customer)
	_last_customer_spawned = Time.get_unix_time_from_system()
	

func puzzle_toggle(launch: bool) -> Node2D:
	var enviroment: Node2D = get_node("/root/Cafe/Enviroment")
	enviroment.visible = !launch
	var player_character: Node2D = get_node("/root/Cafe/MainCharacter")
	player_character.visible = !launch
	var customers: Node2D = get_node("/root/Cafe/Customers")
	customers.visible = !launch
	var ui_elements: Control = get_node("/root/Cafe/UI")
	ui_elements.visible = !launch
	var puzzle_container: Node2D = get_node("/root/Cafe/ActivePuzzle")
	puzzle_container.visible = launch
	
	var interaction_manager: Node2D = get_node("/root/InteractionManager")
	interaction_manager.visible = !launch
	
	puzzle_active = launch
	
	return puzzle_container

func launch_puzzle(scene: String):
	var puzzle_container = puzzle_toggle(true)
	var puzzle: Node2D = load(scene).instantiate()
	puzzle_container.add_child(puzzle)

func close_puzzle():
	var puzzle_container = puzzle_toggle(false)
	for node in puzzle_container.get_children():
		node.queue_free()

func _process(delta: float) -> void:
	if not get_node("/root/Cafe"):
		return
	if phase == GameConstants.PHASES.SERVICE:
		if get_customers_left_to_serve() > 0 \
			&& get_live_customers() < 3 \
			&& (get_live_customers() < 1 || _last_customer_spawned + time_between_customers < Time.get_unix_time_from_system()):
			_spawn_customer()
	var cia: Area2D = get_node("/root/Cafe/Enviroment/CustomerInteractionArea")
	if get_live_customers() > 0 && not cia.is_enabled():
		cia.set_enabled(true)
	elif get_live_customers() < 1 && cia.is_enabled():
		cia.set_enabled(false)
		
		
