class_name State_Pickup extends State

@export var pickup_audio : AudioStream
@export var carry : State

var start_anim_late : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func Enter() -> void:
	player.UpdateAnimation("pickup")
	if start_anim_late:
		player.animation_player.seek( 0.2 )
	player.animation_player.animation_finished.connect( state_complete )
	player.audio.stream = pickup_audio
	player.audio.play()
	pass

func state_complete ( _a ) -> void:
	player.animation_player.animation_finished.disconnect( state_complete )
	state_machine.ChangeState(carry)
	pass

func Exit() -> void:
	start_anim_late = false
	pass

func Process( _delta : float ) -> State:
	player.velocity=Vector2.ZERO
	return null
