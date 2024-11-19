class_name WizardIdle extends EnemyState

@export var state_after_idle : EnemyState

func init() -> void:
	pass # Replace with function body.

func enter() -> void:
	enemy.enable_hit_boxes()
	
	if randf() <= float(enemy.hp / enemy.max_hp):
		enemy.UpdateAnimation( "Idle" )
		await enemy.animation_player.animation_finished
		if enemy.hp <1:
			return
	pass
	
func exit() -> void:
	state_machine.ChangeState(state_after_idle)
	pass

func process( _delta : float ) -> EnemyState:
	return null

func physics( _delta : float ) -> EnemyState:
	return null

func idle() -> void:
	#if damage_count < 1:
		#energy_beam_attack()
		#animation_player.play ("cast_spell")
		#await animation_player.animation_finished
	#
	#if hp <1:
		#return
			#
	#var _t : int = current_position
	#while _t == current_position:
		#_t = randi_range (0,3)

	#teleport( _t )
	pass
