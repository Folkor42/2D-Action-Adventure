class_name Level extends Node2D

const PICKUP = preload("res://Items/Item_pickup/item_pickup.tscn")
@export var music : AudioStream
var scene : String

func _ready():
	self.y_sort_enabled = true
	PlayerManager.set_as_parent( self )
	LevelManager.level_load_started.connect( _free_level )
	AudioManager.play_music( music )
	scene = get_tree().current_scene.scene_file_path
	check_for_previous_drops()
	tree_exited.connect( store_drops )
	pass

func store_drops() -> void:
	SaveManager.remove_persistent_drop( scene )
	for c in get_children():
		if c is ItemPickup:
			SaveManager.add_persistent_drop( c.name_path, scene, c.global_position, c.item_data )
	print( SaveManager.current_save )

func _free_level() -> void:
	PlayerManager.unparent_player ( self )
	queue_free()
	pass

func check_for_previous_drops():
	for d in SaveManager.current_save.drops:
		if d["scene"] == scene:
			print ("Found Item")
			add_drop(d["item_data"],d["pos_x"],d["pos_y"])
		SaveManager.remove_persistent_drop(d["name"])
	pass

func add_drop( item, pos_x, pos_y) -> void:
	var drop : ItemPickup = PICKUP.instantiate() as ItemPickup
	drop.item_data = item
	call_deferred( "add_child", drop )
	drop.global_position = Vector2(pos_x,pos_y)

func parse_save_data ( res_name : String ) -> ItemData:
	print (res_name)
	var item = item_from_save( res_name )
	print (item)
	return item
	
func item_from_save ( save_object : String ) -> ItemData:
	var item = load( save_object )
	return item
