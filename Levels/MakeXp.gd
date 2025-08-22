extends Area2D

@onready var label: Label = $Label
@onready var enemy_spawner: EnemySpawner = $"../EnemySpawner"
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	label.visible=false
	body_entered.connect( _on_area_entered )
	body_exited.connect( _on_area_exited )
	pass
	
func _on_area_entered(_a) -> void:
	label.visible=true
	if !PlayerManager.interact_pressed.is_connected( player_interact ):
		PlayerManager.interact_pressed.connect( player_interact )
	pass
	
func _on_area_exited(_a) -> void:
	label.visible=false
	pass
	
func player_interact() -> void:
	enemy_spawner.spawn_now(1)
	sprite_2d.modulate = Color.CRIMSON
	await get_tree().create_timer(0.2).timeout
	sprite_2d.modulate = Color.WHITE
	pass
