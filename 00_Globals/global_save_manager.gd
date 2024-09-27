extends Node

const SAVE_PATH = "user://"

signal game_loaded
signal game_saved

var current_save : Dictionary = {
	scene_path = "",
	player = {
		hp = 1,
		max_hp = 1,
		pos_x = 0,
		pos_y = 0
	},
	items = [],
	drops = [],
	saved_drops = [],
	persistence = [],
	locations= [],
	quests = []
}

func save_game() -> void:
	update_scene_path()
	update_player_data()
	update_item_data()
	update_drop_data()
	var file := FileAccess.open( SAVE_PATH + "save.sav", FileAccess.WRITE )
	var save_json = JSON.stringify( current_save )
	file.store_line( save_json )
	game_saved.emit()
	print ("Game Saved")
	pass

func get_save_file() -> FileAccess:
	return FileAccess.open( SAVE_PATH + "save.sav", FileAccess.READ )

func load_game() -> void:
	var file := get_save_file()
	var load_json = JSON.new()
	load_json.parse( file.get_line() )
	var  save_dict := load_json.get_data() as Dictionary
	current_save = save_dict
	
	LevelManager.load_new_level( current_save.scene_path, "", Vector2.ZERO )
	await LevelManager.level_load_started
	
	PlayerManager.set_player_position( Vector2(current_save.player.pos_x, current_save.player.pos_y) )
	PlayerManager.set_health( current_save.player.hp, current_save.player.max_hp )
	print (current_save.items)
	print (current_save.drops)
	PlayerManager.INVENTORY_DATA.parse_save_data( current_save.items )
	
	await LevelManager.level_loaded
	
	game_loaded.emit()
	#print(current_save)
	print ("Game Loaded")
	pass

func update_player_data() -> void:
	var p : Player = PlayerManager.player
	current_save.player.hp = p.hp
	current_save.player.max_hp = p.max_hp
	current_save.player.pos_x = p.global_position.x
	current_save.player.pos_y = p.global_position.y
	
func update_scene_path() -> void:
	var p : String = ""
	for c in get_tree().root.get_children():
		if c is Level:
			p = c.scene_file_path
	current_save.scene_path = p

func update_item_data () -> void:
	current_save.items = PlayerManager.INVENTORY_DATA.get_save_data()

func update_drop_data() -> void:
	var drops = get_drop_save_data()
	current_save.saved_drops = drops
	current_save.drops = []
	#print (drops)

func add_persistant_value( value : String ) -> void:
	if check_persistant_value( value ) == false:
		current_save.persistence.append( value )
		print ("added: "+ str(value))
	pass
	
func remove_persistant_value( value : String ) -> void:
	if check_persistant_value( value ) == true:
		current_save.persistence.erase ( value )
		print ("removed: "+ str(value))
	pass
	
func check_persistant_value( value: String ) -> bool:
	var p = current_save.persistence as Array
	return p.has( value )

func add_persistant_location( value : String, coords : Vector2 ) -> void:
	if check_persistant_locations( value ) == false:
		current_save.locations.append( {"name"=value,"pos_x"=coords.x,"pos_y" = coords.y} )
	else:
		remove_persistant_location( value )
		current_save.locations.append( {"name"=value,"pos_x"=coords.x,"pos_y" = coords.y} )
	pass

func add_persistant_item( value : String, scene : String, coords : Vector2, item : ItemData ) -> void:
	if check_persistant_drops( value ) == false:
		current_save.drops.append( {"name"=value,"scene" = scene, "pos_x"=coords.x,"pos_y" = coords.y,"item_data"=item} )
	else:
		remove_persistant_drop( value )
		current_save.drops.append( {"name"=value,"scene" = scene, "pos_x"=coords.x,"pos_y" = coords.y,"item_data"=item} )
	pass

func check_persistant_locations( value: String ) -> bool:
	for i in current_save.locations:
		if i["name"] == value:
			print ("Match")
			return true
	return false
	
func check_persistant_drops( value: String ) -> bool:
	for i in current_save.drops:
		if i["name"] == value:
			print ("Match")
			return true
	return false

func get_persistant_location( value: String ) -> Vector2:
	for i in current_save.locations:
		if i["name"] == value:
			print (i["pos_x"],i["pos_y"])
			return Vector2(i["pos_x"],i["pos_y"])
	return Vector2.ZERO

func remove_persistant_location( value ) -> void:
	for i in current_save.locations:
		if i["name"] == value:
			current_save.locations.erase (i)

func remove_persistant_drop( value ) -> void:
	for i in current_save.drops:
		if i["name"] == value:
			current_save.drops.erase (i)

func get_drop_save_data () -> Array:
# Gather the drops into an array
	var item_save : Array = []
	for i in current_save.drops.size():
		item_save.append( item_to_save( current_save.drops[i]["item_data"],current_save.drops[i]["pos_x"],current_save.drops[i]["pos_y"],current_save.drops[i]["scene"]) )
	return item_save
	
func item_to_save ( drop : ItemData, pos_x, pos_y, _scene ) -> Dictionary:
# Convert the items into a dictionary
	var result = { item = '', posx = pos_x, posy = pos_y, scene = _scene }
	if drop != null:
		result.item = drop.resource_path
	return result
