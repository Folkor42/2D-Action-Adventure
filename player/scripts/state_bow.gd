class_name State_Bow extends State

const ARROW = preload("res://Props/interactables/arrow/Arrow.tscn")

@onready var idle : State = $"../Idle"

var direction : Vector2 = Vector2.ZERO
var next_state : State = null

func _ready() -> void:
	pass

func Enter() -> void:
	player.UpdateAnimation("bow")
	player.animation_player.animation_finished.connect ( _on_animation_finished )
	direction = player.cardinal_direction
	
	var arrow : Arrow = ARROW.instantiate()
	player.add_sibling( arrow )
	arrow.global_position = player.global_position + ( direction * 16 )
	arrow.fire(direction)
	pass
	
		
func Exit() -> void:
	player.animation_player.animation_finished.disconnect ( _on_animation_finished )
	next_state = null
	pass
		
func Process(_delta : float) -> State:
	player.velocity=Vector2.ZERO
	return next_state
	
func _on_animation_finished ( _anim : String ) -> void:
	next_state=idle
	pass
