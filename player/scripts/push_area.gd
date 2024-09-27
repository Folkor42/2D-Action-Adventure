extends Area2D

func _ready() -> void:
	body_entered.connect( _on_body_entered )
	body_exited.connect( _on_body_exited )
	pass # Replace with function body.

func _on_body_entered( b : Node2D ) -> void:
	if b is PushStatue:
		b.push_direction = PlayerManager.player.direction
	pass

func _on_body_exited( b : Node2D ) -> void:
	if b is PushStatue:
		b.push_direction = Vector2.ZERO
	pass
