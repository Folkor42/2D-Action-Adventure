class_name LevelTileMapLayer extends TileMapLayer

@export var tile_size : float = 32.0

func _ready():
	LevelManager.ChangeTileMapBounds( GetTileMapBounds() )
	pass
	
func GetTileMapBounds () -> Array [ Vector2 ]:
	var bounds : Array [ Vector2 ] = []
	bounds.append(
		Vector2( get_used_rect().position * tile_size ) + position
	)
	bounds.append(
		Vector2( get_used_rect().end * tile_size ) + position
	)
	return bounds
	
