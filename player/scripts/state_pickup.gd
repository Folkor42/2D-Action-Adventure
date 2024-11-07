class_name State_Pickup extends State

@export var pickup_audio : AudioStream
@export var carry : State

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func Enter() -> void:
	player.UpdateAnimation("pickup")
	player.animation_player.animation_finished.connect( state_complete )
	player.audio.stream = pickup_audio
	player.audio.play()
	pass

func state_complete ( _a ) -> void:
	player.animation_player.animation_finished.disconnect( state_complete )
	state_machine.ChangeState(carry)
	pass

func Exit() -> void:
	print("Pickup complete")
	pass

func Process( _delta : float ) -> State:
	player.velocity=Vector2.ZERO
	return null
