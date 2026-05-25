extends TileMapLayer

const cell_rows = 5
const cell_columns = 5

var tile_placement = Vector2i(4,0)
var corner_placement = Vector2i(4,0)

var blue_correct = false
var green_correct = false
var red_correct = false
var yellow_correct = false

var blue_start
var green_start
var red_start
var yellow_start

var blue_end
var green_end
var red_end
var yellow_end

#for help with rotating wire tile to horisontal
var flip_h := TileSetAtlasSource.TRANSFORM_FLIP_H
var flip_v := TileSetAtlasSource.TRANSFORM_FLIP_V
var transpose := TileSetAtlasSource.TRANSFORM_TRANSPOSE

signal gameWin

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	var seed = rng.randi_range(1,3)
	#print(seed)
	
	if seed == 1:
		blue_start = Vector2i(1,1)
		blue_end = Vector2i(2,4)
		green_start = Vector2i(2,2)
		green_end = Vector2i(1,5)
		red_start = Vector2i(3,1)
		red_end = Vector2i(4,3)
		yellow_start = Vector2i(5,2)
		yellow_end = Vector2i(4,4)
		
	elif seed == 2:
		blue_start = Vector2i(2,1)
		blue_end = Vector2i(4,3)
		green_start = Vector2i(5,1)
		green_end = Vector2i(3,5)
		red_start = Vector2i(2,2)
		red_end = Vector2i(1,5)
		yellow_start = Vector2i(3,3)
		yellow_end = Vector2i(2,5)
	
	else:
		blue_start = Vector2i(5,1)
		blue_end = Vector2i(4,5)
		green_start = Vector2i(1,1)
		green_end = Vector2i(2,4)
		red_start = Vector2i(3,1)
		red_end = Vector2i(4,3)
		yellow_start = Vector2i(2,1)
		yellow_end = Vector2i(1,5)
		
	setTerminalTiles()

func setTerminalTiles() -> void:
	set_cell(blue_start, 0, Vector2i(0,0), 0)
	set_cell(blue_end, 0, Vector2i(0,0), 0)
	set_cell(green_start, 0, Vector2i(1,0), 0)
	set_cell(green_end, 0, Vector2i(1,0), 0)
	set_cell(red_start, 0, Vector2i(3,0), 0)
	set_cell(red_end, 0, Vector2i(3,0), 0)
	set_cell(yellow_start, 0, Vector2i(2,0), 0)
	set_cell(yellow_end, 0, Vector2i(2,0), 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: #inefficency at its finest
	
	blue_correct = checkPath(blue_start, Vector2i(0,0), "blue") #Vector2i represent the alpha position for the teminal nodes
	green_correct = checkPath(green_start, Vector2i(1,0), "green")
	red_correct =  checkPath(red_start, Vector2i(3,0), "red")
	yellow_correct = checkPath(yellow_start, Vector2i(2,0), "yellow")
	
	if blue_correct && green_correct && red_correct && yellow_correct:
		gameWin.emit()
		for i  in range(1,6):
			for j in range(1,6):
				set_cell(Vector2i(j,i), 0, Vector2i(4,1), 0) #first vector is cell coords, second vector is atles location of the bright green tile
				await get_tree().create_timer(0.25).timeout #create a fill effect
		await get_tree().create_timer(0.5).timeout
		await flash()

func flash() -> void:
	for num in range(1,4):
		for i  in range(1,6):
			for j in range(1,6):
				set_cell(Vector2i(j,i), 0, Vector2i(4,0), 0) #first vector is cell coords, second vector is atles location of the bright green tile
	
		await get_tree().create_timer(0.25).timeout #create a fill effect
	
		for i  in range(1,6):
			for j in range(1,6):
				set_cell(Vector2i(j,i), 0, Vector2i(4,1), 0) #first vector is cell coords, second vector is atles location of the bright green tile
		
		await get_tree().create_timer(0.25).timeout #create a fill effect

func checkPath(startNode: Vector2i, alphaTerminalNode: Vector2i, color: String) -> bool:
	var funcOutput = []
	var pathArray = []
	var alphaStraight: Vector2i
	var alphaCorner: Vector2i
	
	#set the loaction of the tile to be able to tell if the right wire is conecting the node
	if color == "red":
		alphaStraight =  Vector2i(3,1)
		alphaCorner = Vector2i(3,2)
	elif color == "blue":
		alphaStraight =  Vector2i(0,1)
		alphaCorner = Vector2i(0,2)
	elif color == "green":
		alphaStraight =  Vector2i(1,1)
		alphaCorner = Vector2i(1,2)
	elif color == "yellow":
		alphaStraight =  Vector2i(2,1)
		alphaCorner = Vector2i(2,2)
	
	#go through and check the nodes
	pathArray = checkNearByCells(startNode, alphaStraight, Vector2i(99,99))
	pathArray += checkNearByCells(startNode, alphaCorner, Vector2i(99,99))
	for pipe in pathArray:
		funcOutput = checkNearByCells(pipe, alphaTerminalNode, startNode)
		if funcOutput.size() > 0: # if it has a element then it found a conection to end node
			pathArray.push_front(startNode)
			pathArray.push_back(funcOutput[0])
			smoothPath(pathArray)
			return true
		funcOutput = checkNearByCells(pipe, alphaStraight, Vector2i(99,99))
		funcOutput += checkNearByCells(pipe, alphaCorner, Vector2i(99,99))
		for item in funcOutput:
			if item not in pathArray:
				pathArray.append(item)
	pathArray.push_front(startNode) #add the start node
	smoothPath(pathArray)
	
	#no path is found between the two terminals
	return false

func smoothPath(pathArray: Array) -> void:
	for index in pathArray.size(): #first node is the start node so we dont need to change the graphic
		if index == 0:
			pass
		elif index == pathArray.size()-1: # last node is the end node so we dont need to change the graphic
			pass
		#check if it needs to be horizontal
		elif pathArray[index-1].y == pathArray[index].y && pathArray[index].y == pathArray[index+1].y:
			set_cell(pathArray[index], 0, get_cell_atlas_coords(pathArray[index]), flip_h + transpose)
		#check if it should be a corner
		#left /  up
		elif (pathArray[index-1] - pathArray[index] == Vector2i(0,-1) && (pathArray[index+1] - pathArray[index]) == Vector2i(-1,0)
			 || (pathArray[index+1] - pathArray[index]) == Vector2i(0,-1) && (pathArray[index-1] - pathArray[index]) == Vector2i(-1,0)):
			set_cell(pathArray[index], 0, Vector2i(get_cell_atlas_coords(pathArray[index]).x, 2), transpose + flip_v)
		#up/ right
		elif (pathArray[index-1] - pathArray[index] == Vector2i(0,-1) && (pathArray[index+1] - pathArray[index]) == Vector2i(1,0)
			 || (pathArray[index+1] - pathArray[index]) == Vector2i(0,-1) && (pathArray[index-1] - pathArray[index]) == Vector2i(1,0)):
			set_cell(pathArray[index], 0, Vector2i(get_cell_atlas_coords(pathArray[index]).x, 2), 0)
		#down/ right
		elif (pathArray[index-1] - pathArray[index] == Vector2i(0,1) && (pathArray[index+1] - pathArray[index]) == Vector2i(1,0)
			 || (pathArray[index+1] - pathArray[index]) == Vector2i(0,1) && (pathArray[index-1] - pathArray[index]) == Vector2i(1,0)):
			set_cell(pathArray[index], 0, Vector2i(get_cell_atlas_coords(pathArray[index]).x, 2), transpose + flip_h)
		#down / left
		elif (pathArray[index-1] - pathArray[index] == Vector2i(-1,0) && (pathArray[index+1] - pathArray[index]) == Vector2i(0,1)
			 || (pathArray[index+1] - pathArray[index]) == Vector2i(-1,0) && (pathArray[index-1] - pathArray[index]) == Vector2i(0,1)):
			set_cell(pathArray[index], 0, Vector2i(get_cell_atlas_coords(pathArray[index]).x, 2), flip_v + flip_h)
		
		

func checkNearByCells(cellCoords: Vector2i, atlasCoords: Vector2i, notcoord: Vector2i) -> Array:
	var returnArray = [] 
	for i in [cellCoords + Vector2i(0,-1), cellCoords + Vector2i(1,0), cellCoords + Vector2i(0,1), cellCoords + Vector2i(-1,0)]:
		if get_cell_atlas_coords(i) == atlasCoords && i != notcoord:
			returnArray.append(i)
	return returnArray


func _input(event : InputEvent) -> void:
	if event.is_action_pressed("PrimaryClick"):
		var cellAtMouse : Vector2i = local_to_map(get_local_mouse_position())
		placePipe(cellAtMouse)
	if event.is_action_pressed("SecondaryClick"):
		var cellAtMouse : Vector2i = local_to_map(get_local_mouse_position())
		removePipe(cellAtMouse)
		
func placePipe(cellCoords : Vector2i) -> void:
	# check click was inside the boundary of the grid
	if (cellCoords.y <= 5 && cellCoords.x <= 5 && cellCoords.y >= 1 && cellCoords.x >= 1):
		# check that the click wasnt on one of the start / end tiles
		if (cellCoords != blue_start && cellCoords != green_start && cellCoords != red_start && cellCoords != yellow_start &&
			cellCoords != blue_end && cellCoords != green_end && cellCoords != red_end && cellCoords != yellow_end):
			set_cell(cellCoords, 0, tile_placement, 0)

func removePipe(cellCoords : Vector2i) -> void:
	if (cellCoords.y <= 5 && cellCoords.x <= 5 && cellCoords.y >= 1 && cellCoords.x >= 1):
		# check that the click wasnt on one of the start / end tiles
		if (cellCoords != blue_start && cellCoords != green_start && cellCoords != red_start && cellCoords != yellow_start &&
			cellCoords != blue_end && cellCoords != green_end && cellCoords != red_end && cellCoords != yellow_end):
			set_cell(cellCoords, 0, Vector2i(4,0), 0)

func _on_blue_wire_select_pressed() -> void:
	tile_placement = Vector2i(0,1)


func _on_red_wire_select_pressed() -> void:
	tile_placement = Vector2i(3,1)


func _on_green_wire_select_pressed() -> void:
	tile_placement = Vector2i(1,1)


func _on_yellow_wire_select_pressed() -> void:
	tile_placement = Vector2i(2,1)
