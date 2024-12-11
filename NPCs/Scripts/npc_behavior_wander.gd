@tool
extends NPCBehavior

const DIRECTIONS = [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]

@export var wander_range : int = 2 : set = _set_wander_range
@export var wander_speed : float = 30.0
@export var wander_duration : float = 1.0
@export var idle_duration : float = 1.0

var original_position : Vector2

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	super()
	$CollisionShape2D.queue_free()
	original_position = npc.global_position
	pass 

func _process( _delta: float ) -> void:
	if Engine.is_editor_hint():
		return
	#if abs( global_position.distance_to( original_position ) ) > wander_range * 32:
		#npc.velocity *= -1
		#npc.direction *= -1
		#npc.update_direction( global_position + npc.direction )
		#npc.update_animation()
	pass

func start () -> void:
	# Idle Phase
	if npc.do_behavior==false:
		return
	npc.state = "idle"
	npc.velocity = Vector2.ZERO
	npc.update_animation()
	await get_tree().create_timer( randf() * idle_duration + idle_duration * 0.5 ).timeout
	if npc.do_behavior==false:
		return
	# Walk Phase
	npc.state = "walk"
	var _dir : Vector2 = DIRECTIONS[ randi_range (0,3) ]
	if abs( global_position.distance_to( original_position ) ) > wander_range * 32:
		var dir_to_area : Vector2 = global_position.direction_to( original_position )
		var best_directions : Array [float]
		for d in DIRECTIONS:
			best_directions.append( d.dot(dir_to_area) )
		_dir = DIRECTIONS[ best_directions.find( best_directions.max() ) ]
		pass
	npc.direction = _dir
	npc.velocity = wander_speed * _dir
	npc.update_direction(global_position + _dir)
	npc.update_animation()
	await get_tree().create_timer( randf() * wander_duration + wander_duration * 0.5 ).timeout
	# Repeat 
	if npc.do_behavior == false:
		return
	start()
	pass

func _set_wander_range ( v: int ) -> void:
	wander_range = v
	$CollisionShape2D.shape.radius = v * 32.0
	pass
