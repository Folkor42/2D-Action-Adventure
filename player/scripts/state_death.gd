class_name State_Death extends State

@export var exhaust_audio : AudioStream
@onready var audio = $"../../Audio/AudioStreamPlayer2D"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init () -> void:
	pass
	
func Enter() -> void:
	player.animation_player.play( "death" )
	audio.stream = exhaust_audio
	audio.play()
	PlayerHud.show_game_over_screen()
	AudioManager.play_music( null )
	pass

func Exit() -> void:
	pass

func Process( _delta : float ) -> State:
	player.velocity = Vector2.ZERO
	return null
	
func Physics ( _delta : float ) -> State:
		return null
		
func HandleInput ( _event: InputEvent ) -> State:
	return null
	
