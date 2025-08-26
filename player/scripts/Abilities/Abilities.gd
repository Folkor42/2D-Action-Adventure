class_name PlayerAbilites extends Node

const BOOMERANG = preload("res://player/boomerang.tscn")
const BOMB = preload("res://Props/interactables/bomb/bomb.tscn")

var abilities : Array [ String ] = [ "BOOMERANG", "", "BOW", "" ] # Boom,Grapple,Bow,Bomb

var selected_ability : int = 0
var player : Player
var boomerang_instance : Boomerang = null

@onready var state_machine: PlayerStateMachine = $"../StateMachine"
@onready var pickup: State_Pickup = $"../StateMachine/Pickup"
@onready var idle: State_Idle = $"../StateMachine/Idle"
@onready var walk: State_Walk = $"../StateMachine/Walk"
@onready var bow: State_Bow = $"../StateMachine/Bow"
@onready var grapple: State_Grapple = $"../StateMachine/Grapple"



func _ready() -> void:
	player = PlayerManager.player
	PlayerHud.update_arrow_count( player.arrow_count )
	PlayerHud.update_bomb_count( player.bomb_count )
	setup_abilities()
	
func setup_abilities() -> void:
	# Update the Pause Menu
	PauseMenu.update_ability_items(abilities)
	# Update the Hud
	PlayerHud.update_ability_items(abilities)
	selected_ability=0
	toggle_ability(0)
	pass

func _unhandled_input( event : InputEvent ) -> void:
	if event.is_action_pressed("ability"):
		match selected_ability:
			0: boomerang_ability()
			1: grapple_ability()
			2: bow_ability()
			3: bomb_ability()
	
	elif event.is_action_pressed("right_bumper") and !PauseMenu.is_paused:
		toggle_ability(1)
	elif event.is_action_pressed("left_bumper") and !PauseMenu.is_paused:
		toggle_ability(-1)
	pass

func toggle_ability(change) -> void:
	if abilities.count( "" ) == abilities.size():
		return
	selected_ability=wrap(selected_ability + change,0,4)
	while abilities[ selected_ability ] == "":
		selected_ability=wrap(selected_ability + change,0,4)
	PlayerHud.update_ability_ui(selected_ability)

func boomerang_ability() -> void:
	if boomerang_instance != null:
		return
	var _b = BOOMERANG.instantiate() as Boomerang
	player.add_sibling( _b )
	_b.global_position = player.global_position
	_b.global_position.y -= 32
	
	var throw_direction = player.direction
	if throw_direction == Vector2.ZERO:
		throw_direction = player.cardinal_direction
	_b.throw( throw_direction )
	boomerang_instance = _b
	pass

func bomb_ability() -> void:
	if player.bomb_count <= 0:
		return
	elif state_machine.current_state == idle or state_machine.current_state == walk:
		#decrese # of bombs
		player.bomb_count-=1
		#instiante a new bomb
		pickup.start_anim_late=true
		var bomb : Node2D = BOMB.instantiate()
		#player lift/carry
		player.add_sibling( bomb )
		bomb.global_position=player.global_position
		
		PlayerManager.interact_handled = false
		var throwable : ThrowableBomb = bomb.find_child("Throwable")
		throwable.player_interact()
	pass

func bow_ability() -> void:
	if player.arrow_count <= 0:
		return
	elif state_machine.current_state == idle or state_machine.current_state == walk:
		player.arrow_count-=1
		PlayerHud.update_arrow_count( player.arrow_count )

		state_machine.ChangeState(bow)
	pass
func grapple_ability() -> void:
	if state_machine.current_state == idle or state_machine.current_state == walk:
		state_machine.ChangeState(grapple)
