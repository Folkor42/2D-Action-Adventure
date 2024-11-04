class_name EnergyBeam extends Node2D

@onready var animation_player = $AnimationPlayer

@export var use_timer : bool = false
@export var time_between_attacks : float = 3.0

# Called when the node enters the scene tree for the first time.
func _ready():
	if use_timer:
		attack_delay()
	pass # Replace with function body.

func attack () -> void:
	animation_player.play("attack")
	await animation_player.animation_finished
	animation_player.play("default")
	if use_timer:
		attack_delay()
	pass

func attack_delay()->void:
	await get_tree().create_timer( time_between_attacks ).timeout
	attack()
	pass
