class_name State_ChargeAttack extends State

@export var charge_duration : float = 1.0
@export var move_speed : float = 80.0
@export var sfx_charge : AudioStream
@export var sfx_spin : AudioStream

var timer : float = 0.0
var walking : bool = false
var is_attacking : bool = false
var particles : ParticleProcessMaterial

@onready var idle: State_Idle = $"../Idle"
@onready var charge_hurt_box: HurtBox = %ChargeHurtBox
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"
@onready var spin_sprite: Sprite2D = $"../../SpinSprite"
@onready var spin_animation_player: AnimationPlayer = $"../../SpinSprite/AnimationPlayer"
@onready var gpu_particles_2d: GPUParticles2D = $"../../Sprite2D/ChargeHurtBox/GPUParticles2D"


func init() -> void:
	spin_sprite.visible=false
	gpu_particles_2d.emitting=false
	particles = gpu_particles_2d.process_material as ParticleProcessMaterial
	pass

func Enter() -> void:
	print ("CHARGE")
	timer = charge_duration
	is_attacking = false
	walking = false
	charge_hurt_box.monitoring=true
	charge_hurt_box.damage = 0
	gpu_particles_2d.emitting=true
	gpu_particles_2d.amount = 4
	gpu_particles_2d.explosiveness=0
	particles.initial_velocity_min=10
	particles.initial_velocity_max=30
	pass

func Exit() -> void:
	charge_hurt_box.monitoring=false
	spin_sprite.visible=false
	gpu_particles_2d.emitting=false
	pass

func Process( _delta : float ) -> State:
	# handle timer, when down complete notification
	if timer > 0:
		timer -= _delta
		if timer <= 0:
			timer = 0
			charge_complete()
			
	#detect input, walking
	if is_attacking == false:
		if player.direction == Vector2.ZERO:
			walking = false
			player.UpdateAnimation( "charge" )
		elif player.SetDirection() or !walking:
			walking = true
			player.UpdateAnimation( "charge_walk" )
			pass
	
	player.velocity = player.direction * move_speed
	return null

func charge_complete()-> void:
	play_audio( sfx_charge )
	gpu_particles_2d.amount=50
	gpu_particles_2d.explosiveness = 1
	particles.initial_velocity_min=50
	particles.initial_velocity_max=100
	await get_tree().create_timer( 0.5 ).timeout
	gpu_particles_2d.explosiveness=0
	gpu_particles_2d.amount=10
	particles.initial_velocity_min=10
	particles.initial_velocity_max=30
	pass
	
func Physics ( _delta : float ) -> State:
	return null
		
func HandleInput ( _event: InputEvent ) -> State:
	if _event.is_action_released("attack"):
		if timer >0:
			return idle
		elif !is_attacking:
			charge_attack()
	return null
	
func charge_attack() -> void:
	print ("Charge Attack")
	is_attacking = true
	player.animation_player.play("charge_attack")
	player.animation_player.seek( get_spin_frame() )
	play_audio( sfx_spin )
	spin_sprite.visible=true
	spin_animation_player.play("spin")
	var _duration : float = player.animation_player.current_animation_length
	player.invulnerable = true
	charge_hurt_box.damage = 5
	await get_tree().create_timer( _duration * 0.875 ).timeout
	state_machine.ChangeState(idle)
	pass

func get_spin_frame()->float:
	var interval : float = 0.05
	match player.cardinal_direction:
		Vector2.DOWN:
			return interval * 0
		Vector2.UP:
			return interval * 4
		_:
			return interval * 6
			
func play_audio( _audio : AudioStream )->void:
	audio_stream_player_2d.stream = _audio
	audio_stream_player_2d.play()
	pass
