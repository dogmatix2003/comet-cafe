extends CharacterBody2D

@export var mood_icons: Array[Resource]

var interaction_area: InteractionArea
@onready var order_bubble: TileMapLayer = $OrderBubble
@onready var mood_sprite: Sprite2D = $Mood

const speed = 100.0
const spawnPos =  Vector2(560,0)
const CounterPos = Vector2(560,184) #to be updated when have the actual cafe 
var order; #tbd by seperate function
var patience; #tbd by seperate function
var reward; #tbd by seperate function

var _mood: int = 0 # 0 = Happy, 1 = Medium, 2 = Unhappy
var _mood_interval = 7
var _active = false
var _active_time: int

func _update_order_bubble():
	order_bubble.clear()
	
	if order.is_empty():
		return
	
	var current_x = -4

	order_bubble.set_cell(Vector2i(current_x, -1), 0, GameConstants.item_tileset_left_bubble_pos)
	current_x += 4
	for item in order:
		order_bubble.set_cell(Vector2i(current_x, -5), 0, GameConstants.item_tileset_top_bubble_pos)
		order_bubble.set_cell(Vector2i(current_x, -1), 0, GameConstants.item_to_tileset_pos(item))
		order_bubble.set_cell(Vector2i(current_x, 3), 0, GameConstants.item_tileset_bottom_bubble_pos)
		current_x += 6
	order_bubble.set_cell(Vector2i(current_x - 2, -1), 0, GameConstants.item_tileset_right_bubble_pos)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var customer_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = customer_types.pick_random()
	$AnimatedSprite2D.play()
	_update_order_bubble()

func initialize(customer_interaction_area: InteractionArea, customer_order: Array[GameConstants.ITEMS], customer_patience: float, customer_reward: int) -> void:
	interaction_area = customer_interaction_area
	order = customer_order
	patience = customer_patience
	reward = customer_reward
	self.position.x = spawnPos[0]
	self.position.y = spawnPos[1]

func set_active():
	interaction_area.interact = Callable(self, "_on_interact")
	_active = true
	_active_time = Time.get_unix_time_from_system()

func _physics_process(delta: float) -> void:
	var distance_to_counter = position.distance_to(CounterPos)
	
	if distance_to_counter < 5.0:
		velocity = Vector2.ZERO
		return
	
	var direction = (CounterPos - position).normalized()
	var speed = 100.0
	velocity = direction * speed
	
	var blocked = false
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collision_direction = (collision.get_position() - position).normalized()
		if collision_direction.dot(direction) > 0.1:
			blocked = true
			break
	
	if blocked:
		velocity = Vector2.ZERO
	
	move_and_slide()

func _on_interact():
	if (PlayerInventory.constains_all_of(order)): #replace with a check in to the player inventory once its ready
		PlayerInventory.remove_all_of(order)
		GameController.customer_served()
		queue_free()

func _check_customer_mood() -> void:
	if _active && (_active_time + (_mood_interval * len(order) * (_mood + 1))) < Time.get_unix_time_from_system():
		_mood += 1
		if _mood > 2:
			GameController.customer_left()
			queue_free()
		else:
			mood_sprite.texture = mood_icons[_mood]

func _process(delta: float) -> void:
	_check_customer_mood()
