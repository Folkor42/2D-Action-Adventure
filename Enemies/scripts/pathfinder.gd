class_name Pathfinder extends Node2D

var vectors : Array[ Vector2 ] = [
	Vector2(0, -1), #UP
	Vector2(1, -1), #UP/RIGHT
	Vector2(1, 0), #RIGHT
	Vector2(1, 1), #DOWN/RIGHT
	Vector2(0, 1), #DOWN
	Vector2(-1, 1), #DOWN/LEFT
	Vector2(-1, 0), #LEFT
	Vector2(-1, -1) #UP/LEFT
]
var interests : Array [ float ]
var obstacles : Array [ float ] = [0,0,0,0,0,0,0,0]
var outcomes : Array [ float ] = [0,0,0,0,0,0,0,0]
var rays : Array [ RayCast2D ]

var move_dir : Vector2 = Vector2.ZERO
var best_path : Vector2

@onready var timer: Timer = $Timer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Gather all RayCast2D Nodes
	for r in get_children():
		if r is RayCast2D:
			rays.append( r )
			
	#Normalize all vectors
	for v in vectors:
		v = v.normalized()
	
	#Perform initial pathfinder funciton
	set_path()
	
	#Connect our Timer
	timer.timeout.connect ( set_path )
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#Update towards the best path
	move_dir = lerp ( move_dir, best_path, 10 * _delta)
	pass

# Set the best path Vector by checking desired direction and obstacles
func set_path () -> void:
	#Get player Direction
	var player_dir : Vector2 = global_position.direction_to(PlayerManager.player.global_position)
	
	#Reset values to 0
	for i in 8:
		obstacles[i] = 0
		outcomes[i] = 0
	
	#Check each Raycast for collisions and update Obstacles
	for i in 8:
		if rays[i].is_colliding():
			obstacles[i] += 4
			obstacles[get_next_i(i)] += 1
			obstacles[get_previous_i(i)] += 1
	
	#If no Obstacles, recommend path
	if obstacles.max() == 0:
		best_path=player_dir
		return
	
	#if Obstabcles, set interest array
	interests.clear()
	for v in vectors:
		interests.append( v.dot( player_dir ) )	
	
	#Populate outcomes array by combining interest and obstacle arrays
	for i in 8:
		outcomes[i]=interests[i]-obstacles[i]

	# set best path
	best_path= vectors[ outcomes.find( outcomes.max() ) ]
	
	pass

func get_next_i(i : int)->int:
	if i >= 7:
		return 0
	else:
		return i+1 
		
func get_previous_i(i : int)->int:
	if i <= 0:
		return 7
	else:
		return i-1 
