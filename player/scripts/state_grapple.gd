class_name State_Grapple extends State

@onready var idle: State_Idle = $"../Idle"
@onready var grapple_hook: Node2D = %GrappleHook
@onready var nine_patch_rect: NinePatchRect = $"../../GrappleHook/NinePatchRect"
@onready var chain_audio_player: AudioStreamPlayer2D = $"../../GrappleHook/AudioStreamPlayer2D"
@onready var grapple_ray_cast_2d: RayCast2D = %GrappleRayCast2D
@onready var grapple_hurt_box: HurtBox = $"../../GrappleHook/NinePatchRect/Control/HurtBox"

@export var grapple_distance : float = 100.0
@export var grapple_speed : float = 200.0

@export_group("Audio SFX")
@export var grapple_fire : AudioStream
@export var grapple_stick : AudioStream
@export var grapple_bounce : AudioStream
@export var grapple_offset : float = 16

var collision_distance : float
var collision_type : int = 0 # 0 = none, 1 = wall, 2 = grapple point
var nine_patch_size : float = 25.0


var tween : Tween
var next_state : State = null
var positions : Array[ Vector3 ] = [
	Vector3( 0,-20,180), # Up
	Vector3( 0, -10, 0 ), # Down
	Vector3( -10, -15, 90 ), # Left
	Vector3( 10, -15, -90) # Right
]

var pos_map : Dictionary = {
	Vector2.UP : 0,
	Vector2.DOWN : 1,
	Vector2.LEFT : 2,
	Vector2.RIGHT : 3
}

func init() -> void:
	grapple_hook.visible = false
	grapple_ray_cast_2d.enabled = false
	grapple_ray_cast_2d.target_position.y = grapple_distance
	grapple_hurt_box.monitoring=false
	pass

func Enter() -> void:
	player.UpdateAnimation( "idle" )
	grapple_hook.visible = true
	grapple_hurt_box.monitoring=true
	set_grapple_position()
	
	raycast_detection()
	
	shoot_grapple() 
	
	chain_audio_player.play()
	
	play_audio ( grapple_fire )
	
	pass

func Exit() -> void:
	grapple_hurt_box.monitoring=false
	next_state = null
	grapple_hook.visible = false
	chain_audio_player.stop()
	tween.kill()
	nine_patch_rect.size.y=nine_patch_size
	pass

func Process( _delta : float ) -> State:
	player.velocity = Vector2.ZERO
	return next_state
	
func Physics ( _delta : float ) -> State:
		return null
		
func HandleInput ( _event: InputEvent ) -> State:
	return null

func set_grapple_position() -> void:
	var new_pos : Vector3 = positions[
		pos_map[ player.cardinal_direction ]
	]
	grapple_hook.position = Vector2( new_pos.x, new_pos.y )
	grapple_hook.rotation_degrees = new_pos.z
	if player.cardinal_direction == Vector2.UP:
		grapple_hook.show_behind_parent = true
	else:
		grapple_hook.show_behind_parent = false
	pass

func raycast_detection() -> void:
	collision_type = 0
	collision_distance=grapple_distance
	
	grapple_ray_cast_2d.set_collision_mask_value( 5, false)
	grapple_ray_cast_2d.set_collision_mask_value( 7, true)
	grapple_ray_cast_2d.force_raycast_update()
	if grapple_ray_cast_2d.is_colliding():
		collision_type = 2
		collision_distance = grapple_ray_cast_2d.get_collision_point().distance_to( player.global_position)
		return
	grapple_ray_cast_2d.set_collision_mask_value( 5, true)
	grapple_ray_cast_2d.set_collision_mask_value( 6, false)
	grapple_ray_cast_2d.force_raycast_update()
	if grapple_ray_cast_2d.is_colliding():
		collision_type = 1
		collision_distance = grapple_ray_cast_2d.get_collision_point().distance_to( player.global_position)
		return
	pass

func play_audio ( audio : AudioStream ) -> void:
	player.audio.stream = audio
	player.audio.play()
	pass
	
func shoot_grapple() -> void:
	if tween:
		tween.kill()
	var tween_duration : float = collision_distance / grapple_speed
	tween = create_tween()
	tween.tween_property(nine_patch_rect, "size", Vector2( nine_patch_rect.size.x,collision_distance), tween_duration)
	
	if collision_type == 2:
		tween.tween_callback( grapple_player )
	else:
		tween.tween_callback( return_grapple )
	pass

func grapple_player() -> void:
	if tween:
		tween.kill()
	play_audio( grapple_stick )
	player.set_collision_mask_value(4,false)
	var tween_duration : float = collision_distance / grapple_speed
	tween = create_tween()
	tween.tween_property(nine_patch_rect, "size", Vector2( nine_patch_rect.size.x, nine_patch_size ), tween_duration)
	
	var player_target : Vector2 = player.global_position
	player_target += player.cardinal_direction * collision_distance
	player_target -= player.cardinal_direction * nine_patch_size

	#var grapple_source : Vector2 = grapple_hook.position
	#grapple_source -= player.cardinal_direction * grapple_offset
	#tween.parallel().tween_property(grapple_hook,"position", grapple_source,tween_duration)

	tween.parallel().tween_property(player,"global_position", player_target,tween_duration)
	player.make_invulnerable(tween_duration)
	tween.tween_callback( grapple_finished )
	pass

func return_grapple() -> void:
	if tween:
		tween.kill()
		
	if collision_type >0:
		play_audio( grapple_bounce )
	var tween_duration : float = collision_distance / grapple_speed
	tween = create_tween()
	tween.tween_property(nine_patch_rect, "size", Vector2( nine_patch_rect.size.x, nine_patch_size ), tween_duration)
	tween.tween_callback( grapple_finished )
	pass
	
func grapple_finished() -> void:
	player.set_collision_mask_value(4,true)
	next_state = idle
	pass
