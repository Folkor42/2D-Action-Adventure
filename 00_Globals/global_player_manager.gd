extends Node

const PLAYER = preload("res://player/player.tscn")
const INVENTORY_DATA : InventoryData = preload ("res://GUI/Pause_Menu/Inventory/player_inventory.tres")

signal interact_pressed
signal camera_shook ( trama : float )

var interact_handled : bool = true
var player : Player
var player_spawned : bool = false

var xp : int = 0

func reward_xp( _xp : int )->void:
	xp+=_xp
	print ("XP = ", str(xp))

func _ready() -> void:
	add_player_instance()
	await get_tree().create_timer(0.2).timeout
	player_spawned = true
	pass


func add_player_instance () -> void:
	player = PLAYER.instantiate()
	add_child( player )
	pass

func set_health( hp : int , max_hp : int ) -> void:
	player.max_hp = max_hp
	player.hp = hp
	player.update_hp( 0 )
	pass
	
func set_player_position( _new_pos : Vector2 ) -> void:
	player.global_position = _new_pos
	pass


func set_as_parent ( _p : Node2D ) -> void:
	if player.get_parent():
		player.get_parent().remove_child( player )
	_p.add_child( player )
	pass
	
func unparent_player ( _p : Node2D ) -> void:
	_p.remove_child( player )
	pass

func play_audio ( _audio : AudioStream ) -> void:
	player.audio.stream = _audio
	player.audio.play()
	pass

func shake_camera ( tramua : float = 1 ) -> void:
	camera_shook.emit( tramua )
	pass

func interact() -> void:
	interact_handled=false
	interact_pressed.emit()
