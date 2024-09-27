extends Control

signal finished

func _ready() -> void:
	$"NyeWeb Games Logo/AnimationPlayer".animation_finished.connect( _on_animation_finished )
	pass
	
func _on_animation_finished( _name : String ) -> void:
	finished.emit()
	queue_free()
