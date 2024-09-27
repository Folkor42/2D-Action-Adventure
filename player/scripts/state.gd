class_name State extends Node

## Stores a reference to the player that this State belongs
static var player : Player
static var state_machine : PlayerStateMachine

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init () -> void:
	pass
	
func Enter() -> void:
	pass

func Exit() -> void:
	pass

func Process( _delta : float ) -> State:
	return null
	
func Physics ( _delta : float ) -> State:
		return null
		
func HandleInput ( _event: InputEvent ) -> State:
	return null
	
