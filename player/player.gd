class_name Player extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN
const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]
var direction : Vector2 = Vector2.ZERO

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var state_machine = $StateMachine
@onready var hit_box : HitBox = $HitBox
@onready var effect_animation_player : AnimationPlayer = $EffectAnimationPlayer
@onready var audio = $Audio/AudioStreamPlayer2D
@onready var pickup: State_Pickup = $StateMachine/Pickup
@onready var held_item: Sprite2D = $Sprite2D/HeldItem



signal DirectionChanged ( new_direction : Vector2 )
signal player_damaged ( hurt_box : HurtBox )

var invulnerable : bool = false
var hp : int = 6
var max_hp : int = 6

func _ready():
	PlayerManager.player = self
	state_machine.Initialize( self )
	hit_box.Damaged.connect ( _take_damage )
	update_hp( 99 )
	pass
	
func _process( _delta ):
	#direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	#direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	direction = Vector2(
		Input.get_axis("left","right"),
		Input.get_axis("up","down")
	).normalized()


	pass
	
func _physics_process( _delta ):
	move_and_slide()

func calculate_direction_index(direction_temp: Vector2, cardinal_direction_temp: Vector2, dir_size: int) -> int:
	var direction_bias = 0.1
	var angle = (direction_temp + cardinal_direction_temp * direction_bias).angle()
	var normalized_angle = angle / TAU
	var direction_idx = int(round(normalized_angle * dir_size))
	return direction_idx
	
func SetDirection() -> bool:
	if direction == Vector2.ZERO:
		return false
	
	var direction_id : int = calculate_direction_index(direction, cardinal_direction, DIR_4.size())
	var new_dir = DIR_4[ direction_id ]
		
	if new_dir == cardinal_direction:
		return false
	cardinal_direction = new_dir
	DirectionChanged.emit( new_dir )
	sprite.scale.x = -1 if cardinal_direction== Vector2.LEFT else 1
	return true
	
func UpdateAnimation( state : String ) -> void:
	animation_player.play( state + "_" + AnimDirection() )
	pass
	
func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

func _take_damage ( hurt_box : HurtBox ) -> void:
	if invulnerable == true:
		return
	if hp > 0:
		update_hp( -hurt_box.damage )
		player_damaged.emit( hurt_box )
	pass
	
func update_hp ( delta : int ) -> void:
	hp = clampi( hp + delta, 0, max_hp )
	PlayerHud.update_hp( hp, max_hp )
	pass
	
func make_invulnerable ( _duration : float = 1.0 ) -> void:
	invulnerable = true
	hit_box.monitoring = false
	
	await get_tree().create_timer( _duration ).timeout
	invulnerable = false
	hit_box.monitoring = true
	pass

func _unhandled_input(_event):
	#if _event.is_action_pressed("test"):
		#PlayerManager.shake_camera()
	pass
	
func revive_player() -> void:
	update_hp( 99 )
	state_machine.ChangeState( $StateMachine/Idle )
	pass

func pickup_item ( _t : Throwable ) -> void:
	state_machine.ChangeState(pickup)
	#store throwable object
	pass
