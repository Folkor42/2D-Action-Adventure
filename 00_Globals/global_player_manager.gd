extends Node

const PLAYER = preload("res://player/player.tscn")
const INVENTORY_DATA : InventoryData = preload ("res://GUI/Pause_Menu/Inventory/player_inventory.tres")

signal interact_pressed
signal camera_shook ( trama : float )
signal player_leveled_up

var interact_handled : bool = true
var player : Player
var player_spawned : bool = false

var level_requirements = [ 0, 10, 20, 40, 60 ]

func reward_xp( _xp : int )->void:
	player.xp+=_xp
	# TODO Check for Level Up, but need to clamp our leveling and be able to multiple levels at once, recursive.
	if player.level >= level_requirements.size():
		return
	check_for_level_advance()

func check_for_level_advance() -> void:
	if player.level >= level_requirements.size():
		return
	if player.xp >= level_requirements[player.level]:
		player.level += 1
		player.atk += 1
		player.def += 1
		player_leveled_up.emit()
		check_for_level_advance()
	pass
	
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
	camera_shook.emit( clampf(tramua,0,3 ))
	pass

func interact() -> void:
	interact_handled=false
	interact_pressed.emit()

func reset_camera_on_player ( tween_duration : float = 0.5 ) -> void:
	var camera : Camera2D = get_viewport().get_camera_2d()
	if camera:
		if camera.get_parent()==Player:
			return
		camera.reparent(player)
		var tween : Tween = create_tween()
		tween.set_ease( Tween.EASE_OUT )
		tween.set_trans(Tween.TRANS_QUAD)
		tween.tween_property(camera, "position", Vector2.ZERO, tween_duration)
	pass
