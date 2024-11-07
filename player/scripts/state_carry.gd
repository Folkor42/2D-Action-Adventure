class_name State_Carry extends State

@export var move_speed : float = 100.0
@export var throw_audio : AudioStream

var walking : bool = false
var throwable : Throwable

@onready var idle: State_Idle = $"../Idle"
@onready var stun: State_Stun = $"../Stun"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func Enter() -> void:
	print ("Now carrying")
	player.UpdateAnimation("carry")
	walking=false
	pass

func Exit() -> void:
	if throwable:
		#throw direciton
		if player.direction == Vector2.ZERO:
			throwable.throw_direction = player.cardinal_direction
		else:
			throwable.throw_direction = player.direction
		#stunned? drop instead of throw
		if state_machine.next_state == State_Stun:
			throwable.throw_direction=throwable.throw_direction.rotated( PI )
			throwable.drop()
			pass
		else:
			player.audio.stream = throw_audio
			player.audio.play()
			throwable.throw()
			pass
		pass
	pass
	
func Process( _delta: float ) -> State:
	if player.direction == Vector2.ZERO:
		walking = false
		player.UpdateAnimation("carry")
	elif player.SetDirection() or !walking: 
		player.UpdateAnimation("carry_walk")
		walking = true
		
	player.velocity = player.direction * move_speed
	return null

func HandleInput ( _event: InputEvent ) -> State:
	if _event.is_action_pressed("attack") or _event.is_action_pressed("interact"):
		return idle
	return null
