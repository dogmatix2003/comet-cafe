extends Node2D

signal grabbed_item(item)

@export var move_speed := 150.0
@export var left_limit := 20
@export var right_limit := 1000

var moving_right := true
var going_down := false
var start_y := 0.0
@export var drop_distance := 200.0

func _ready():
	start_y = position.y
	# Start playing the animation (claw opening and closing)
	$AnimatedSprite2D.play("default")

func _process(delta):
	
	#Crane dropping
	if going_down:
		position.y += 250 * delta
		
		if position.y >= start_y + drop_distance:
			going_down = false
			check_grab()
			position.y = start_y      #goes back up immediately. Too quick?
			
		return   

	# Moving back and forth
	if moving_right:
		position.x += move_speed * delta
		if position.x >= right_limit:
			moving_right = false
	else:
		position.x -= move_speed * delta
		if position.x <= left_limit:
			moving_right = true


func drop():
	if not going_down:
		going_down = true

func open_claw():
	$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play("default")

func close_claw():
	$AnimatedSprite2D.frame = 1
	$AnimatedSprite2D.stop()

func check_grab():
	var overlapping = $Area2D.get_overlapping_areas()
	
	if overlapping.size() > 0:
		emit_signal("grabbed_item", overlapping[0])
