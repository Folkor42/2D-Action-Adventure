extends Node2D

signal teleport_menu_request

@export_file( "*.tscn" ) var level
@export var target_transition_area : String = "Teleporter"

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var activate: Area2D = $Activate
@onready var teleport_button: Area2D = $TeleportButton
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	teleport_button.monitoring = false
	_place_player()
	await LevelManager.level_loaded
	activate.body_entered.connect(activate_pad)
	activate.body_exited.connect(deactivate_pad)
	teleport_button.body_entered.connect(show_teleport_menu)
	teleport_button.body_exited.connect(hide_teleport_menu)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func activate_pad(_b:CharacterBody2D)->void:
	animation_player.play("activate")	
	teleport_button.monitoring = true
	pass

func deactivate_pad(_b:CharacterBody2D)->void:
	animation_player.play("default")
	teleport_button.monitoring = false	
	if PlayerHud.control_teleport.teleport.is_connected( teleport ):
		PlayerHud.control_teleport.teleport.disconnect(teleport)
	pass

func show_teleport_menu(_b:CharacterBody2D)->void:
	PlayerHud.control_teleport.show_teleport_choices()
	if !PlayerHud.control_teleport.teleport.is_connected(teleport):
		PlayerHud.control_teleport.teleport.connect(teleport)

func hide_teleport_menu( _b:CharacterBody2D)->void:
	PlayerHud.control_teleport.hide_teleport_choices()
	
func teleport(destination)->void:
	level = destination
	animation_player.play("teleport")
	PlayerManager.player.effect_animation_player.play("teleport_out")
	audio_stream_player_2d.play()
	await animation_player.animation_finished
	_player_entered()
	pass


func _player_entered () -> void:
	teleport_button.monitoring = false	
	activate.monitoring=false
	LevelManager.load_new_level( level, "Teleporter", Vector2.ZERO )
	pass

func _place_player() -> void:
	if name != LevelManager.target_transition:
		return
	PlayerManager.set_player_position( global_position + LevelManager.position_offset )
	PlayerManager.player.effect_animation_player.play("teleport_in")
