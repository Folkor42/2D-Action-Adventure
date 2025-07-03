class_name PlayerAbilites extends Node

const BOOMERANG = preload("res://player/boomerang.tscn")
const BOMB = preload("res://Props/interactables/bomb/bomb.tscn")

var abilities : Array [ String ] = [ "BOOMERANG", "GRAPPLE", "BOW", "BOMB" ]

var selected_ability : int = 0
var player : Player
var boomerang_instance : Boomerang = null

@onready var state_machine: PlayerStateMachine = $"../StateMachine"
@onready var pickup: State_Pickup = $"../StateMachine/Pickup"
@onready var idle: State_Idle = $"../StateMachine/Idle"
@onready var walk: State_Walk = $"../StateMachine/Walk"


func _ready() -> void:
	player = PlayerManager.player
	PlayerHud.update_arrow_count( player.arrow_count )
	PlayerHud.update_bomb_count( player.bomb_count )

func _unhandled_input( event : InputEvent ) -> void:
	if event.is_action_pressed("ability"):
		match selected_ability:
			0: boomerang_ability()
			1: print("Grapple")
			2: print("Bow")
			3: bomb_ability()
	
	elif event.is_action_pressed("right_bumper") and !PauseMenu.is_paused:
		toggle_ability(1)
	elif event.is_action_pressed("left_bumper") and !PauseMenu.is_paused:
		toggle_ability(-1)
	pass

func toggle_ability(change) -> void:
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
		#update player hud
		PlayerHud.update_bomb_count( player.bomb_count )
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
