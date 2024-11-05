class_name Throwable extends Area2D

@export var gravity_strength : float = 980.0
@export var throw_speed : float = 400.0
@export var throw_height_strength : float = 100.0
@export var throw_starting_height : float = 49.0

var picked_up : bool = false
var throwable : Node2D

@onready var hurt_box: HurtBox = $HurtBox

func _ready() -> void:
	area_entered.connect(_on_area_enter)
	area_exited.connect(_on_area_exited)
	throwable = get_parent()
	setup_hurt_box()
	pass
	
func _on_area_enter ( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.connect( player_interact )
	pass

func _on_area_exited ( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.disconnect( player_interact )
	pass

func setup_hurt_box () -> void:
	hurt_box.monitoring = false
	for c in get_children():
		if c is CollisionShape2D:
			var _col : CollisionShape2D = c.duplicate()
			hurt_box.add_child( _col )
			_col.debug_color = Color(1,0,0,0.5)
			
func player_interact () -> void:
	#pick up one only
	if !picked_up:
		#pick up object
		print ("Pick up pot!")
		pass
	pass
