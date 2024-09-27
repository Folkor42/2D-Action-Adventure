@tool
extends NPCBehavior

const COLORS = [ Color(1,0,0) , Color(1,1,0) , Color(0,1,0) , Color(0,1,1) , Color(0,0,1) , Color(1,0,1)]

@export var walk_speed : float = 30.0

var patrol_locaitons : Array [PatrolLocation]
var current_location_index : int = 0
var target : PatrolLocation
var to_travel : float = 0.0

var has_started : bool = false
var last_phase : String = ""
var direction : Vector2
@onready var timer: Timer = $Timer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_gather_patrol_locations()
	if Engine.is_editor_hint():
		child_entered_tree.connect( _gather_patrol_locations )
		child_order_changed.connect( _gather_patrol_locations )
		return

	super()
	if patrol_locaitons.size() == 0:
		process_mode = Node.PROCESS_MODE_DISABLED
		return
	target = patrol_locaitons[ 0 ]

func idle_phase () ->void:
	#IDLE PHASE
	#npc.global_position = target.target_position #Warps the NPC to the first patrol point.
	npc.state = "idle"
	npc.velocity = Vector2.ZERO
	npc.update_animation()
	
	var wait_time : float = target.wait_time
	
	current_location_index += 1
	if current_location_index >= patrol_locaitons.size():
		current_location_index = 0
	target = patrol_locaitons[current_location_index]
	
	if wait_time>0:
		timer.start(wait_time)
		await timer.timeout
	
	if npc.do_behavior == false:
		return
	
	walk_phase()
	pass
func walk_phase() -> void:
	npc.state = "walk"
	var _dir = global_position.direction_to( target.target_position )
	npc.direction = _dir
	print(str(npc.direction))
	npc.velocity = walk_speed * _dir
	print(str(npc.velocity))
	npc.update_direction( target.target_position )
	npc.update_animation()
	pass
	
func start () -> void:
	if npc.do_behavior == false || patrol_locaitons.size() < 2:
		return
	if has_started:
		if timer.time_left == 0:
			walk_phase()
		else:
			idle_phase()
		return
	has_started=true
	idle_phase()
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if npc.global_position.distance_to( target.target_position ) < 1:
		idle_phase()
	if npc.state == "walk":
		check_dir_to_next()
	pass

func check_dir_to_next() -> void:
	var distance_to : float  = npc.global_position.distance_to(target.target_position)
	if distance_to > to_travel:
		var new_dir : Vector2 = npc.global_position.direction_to( target.target_position )
		npc.direction = lerp ( npc.direction, new_dir, 0.25 )
		npc.velocity = npc.direction * walk_speed
		npc.update_direction( target.target_position )
		npc.update_animation()
	to_travel = npc.global_position.distance_to(target.target_position)
	pass
	
func _gather_patrol_locations( _n : Node = null ) -> void:
	patrol_locaitons = []
	for c in get_children():
		if c is PatrolLocation:
			patrol_locaitons.append( c )
			
	if Engine.is_editor_hint():
		if patrol_locaitons.size() > 0:
			for i in patrol_locaitons.size():
				var _p = patrol_locaitons[i] as PatrolLocation
				
				if !_p.transform_changed.is_connected( _gather_patrol_locations):
					_p.transform_changed.connect ( _gather_patrol_locations )
				
				_p.update_label( str(i) )
				_p.modulate = _get_color_by_index( i )
				
				var _next : PatrolLocation
				if i < patrol_locaitons.size() - 1:
					_next = patrol_locaitons[ i + 1]
				else:
					_next = patrol_locaitons[0]
				_p.update_line( _next.position )
	pass

func _get_color_by_index( i : int ) -> Color:
	var color_count = COLORS.size()
	while i > color_count-1 :
		i -= color_count
	return COLORS[i]
