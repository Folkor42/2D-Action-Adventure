class_name FootstepAudio2D extends AudioStreamPlayer2D

@export var footstep_variants : Array [ AudioStream ]

var stream_randomizer : AudioStreamRandomizer

func _ready() -> void:
	stream_randomizer = stream

func play_footstep() -> void:
	# Change dynamically to match tilemap
	get_footstep_type()
	play()
	
	pass

func get_footstep_type() -> void:
	for t in get_tree().get_nodes_in_group( "tilemaps" ):
		if t is TileMapLayer:
			if t.tile_set.get_custom_data_layer_by_name( "Footstep_Type" ) == -1:
				print (str(t.name) + " is missing Footstep_Type!")
				continue
			var cell : Vector2i = t.local_to_map( t.to_local ( global_position ) )
			var data : TileData = t.get_cell_tile_data( cell )
			if data : 
				var type = data.get_custom_data( "Footstep_Type" )
				if type == null:
					continue
				stream_randomizer.set_stream( 0, footstep_variants[ type ] )
			pass
		pass
	pass
