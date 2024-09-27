class_name EnemyCounter extends Node2D

signal enemies_defeated

func _ready() -> void:
	child_exiting_tree.connect( on_enemy_destroyed )
	enemy_count()
	pass
	
func on_enemy_destroyed ( _e : Node2D ) -> void:
	if _e is Enemy:
		if enemy_count() <= 1:
			print("Enemy Defeated")
			enemies_defeated.emit()
	pass
	
func enemy_count () -> int:
	var _count : int = 0
	for c in get_children():
		if c is Enemy:
			_count += 1
	return _count
