@icon ("res://GUI/Dialog_System/Icons/cutscene_animation.svg")
class_name CutsceneActionAnimation extends CutsceneAction

@export var animation_player : AnimationPlayer
@export var animation_name : String

func play() -> void:
	if animation_player:
		if animation_name:
			animation_player.process_mode=Node.PROCESS_MODE_ALWAYS
			animation_player.play( animation_name )
			await animation_player.animation_finished
	finished.emit()
	pass
