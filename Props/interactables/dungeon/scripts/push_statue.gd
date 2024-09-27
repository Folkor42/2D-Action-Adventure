class_name PushStatue extends RigidBody2D


@export var push_speed : float = 30.0

var push_direction : Vector2 = Vector2.ZERO : set = _set_push 
var new_position : Vector2

@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var has_moved = $HasMoved

func _ready():
	SaveManager.game_loaded.connect( _set_statue_location )
	_set_statue_location()
	pass

func _set_statue_location() -> void:
	if SaveManager.check_persistant_locations( has_moved._get_name() ):
		print ("Exists")
		new_position = SaveManager.get_persistant_location( has_moved._get_name() )
		global_position=new_position
	print (str(new_position))    
	pass

func _physics_process( _delta: float) -> void:
	linear_velocity = push_direction * push_speed
	pass
	
func _set_push( value : Vector2 ) -> void:
	push_direction = value
	if push_direction == Vector2.ZERO:
		audio.stop()
		has_moved.set_coords(global_position)
	else:
		audio.play()
	pass

