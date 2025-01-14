class_name ItemEffectHeartIncrease extends ItemEffect

@export var amount : int = 1
@export var sound : AudioStream

func use() -> void:
	PlayerManager.set_health( PlayerManager.player.hp + amount*2 , PlayerManager.player.max_hp + amount*2 )
	PauseMenu.play_sound( sound )
	pass
