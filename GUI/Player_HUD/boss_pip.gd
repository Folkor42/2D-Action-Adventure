class_name BossPip extends Control

@onready var background: Sprite2D = $Background
@onready var full: Sprite2D = $Full
@onready var container: Sprite2D = $Container
@onready var animation_player = $AnimationPlayer

@export var begin_pip : bool = false
@export var end_pip : bool = false

var value : int = 1 :
	set( _value ): 
		value = _value
		update_sprite()

func _ready() -> void:
	if begin_pip:
		container.frame=0
		container.z_index=0
		background.scale.x=.7
		background.position.x=14
		full.scale.x=.7
		full.position.x=14
		
	if end_pip:
		container.frame=2
		container.z_index=0
		background.scale.x=.7
		background.position.x=7
		full.scale.x=.7
		full.position.x=7
	update_sprite()

func update_sprite() -> void:
	if value == 0:
		full.visible = false
	else:
		full.visible = true
