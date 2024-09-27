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
	pass

func _free_level() -> void:
	PlayerManager.unparent_player ( self )
	queue_free()
	pass

func check_for_previous_drops():
	var drops = SaveManager.current_save.drops
	for i in range(drops.size(), 0, -1):
		var d = SaveManager.current_save.drops[i-1]
		if d["scene"] == scene:
			add_drop(d["item_data"],d["pos_x"],d["pos_y"])
			SaveManager.current_save.drops.erase(d)
	var saved_drops = SaveManager.current_save.saved_drops
	for i in range(saved_drops.size(), 0, -1):
		var d = SaveManager.current_save.saved_drops[i-1]
		if d["scene"] == scene:
			print ("Found SAVED item for this scene.")
			d["item_data"]=parse_save_data(d["item"])
			add_drop(d["item_data"],d["posx"],d["posy"])
			SaveManager.current_save.saved_drops.erase(d)
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
