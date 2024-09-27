class_name PersistantDataHandler extends Node

signal data_loaded
var value : bool = false
var scene : String
var coords : Vector2

func _ready() -> void:
	get_value()
	scene = get_tree().current_scene.scene_file_path
	pass
	
func set_value() -> void:
	print("Checking Value")
	SaveManager.add_persistant_value( _get_name() )
	pass

func clear_drop_value() -> void:
	SaveManager.remove_persistent_drop( _get_name() )
	pass
	
func set_drop_value(global_position,item_data : ItemData) -> void:
	SaveManager.add_persistent_drop( _get_name() , "NO", scene , global_position, item_data )
	print (item_data.resource_name)
	pass

func set_coords( global_position : Vector2 ) -> void:
	SaveManager.add_persistant_location( _get_name() , global_position )
	print (SaveManager.current_save)
	pass
	
func get_value() -> void:
	value = SaveManager.check_persistant_value( _get_name() )
	data_loaded.emit()
	pass
	
func _get_name() -> String:
	# "res://levels/Area1/01.tscn/treasurechest2/PersistantDataHandler
	return get_tree().current_scene.scene_file_path + "/" + get_parent().name + "/" + name
	
func parse_save_data ( save_data : Array ) -> void:
	for i in save_data.size():
		print (save_data[ i ] )
	pass
