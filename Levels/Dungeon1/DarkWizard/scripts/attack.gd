class_name WizardStateAttack extends EnemyState

@export var anim_name : String = "cast"
@export_category("AI")
@export var state_duration_min : float = 0.9
@export var state_duration_max : float = 0.9
@export var after_idle_state : EnemyState

const ORB = preload ("res://Levels/Dungeon1/DarkWizard/energy_orb.tscn")

var _timer : float = 0.0
var attack_type : int = randi_range(0,3)

func init() -> void:
	pass # Replace with function body.

func enter() -> void:
	print("attacking player with: ")
	attack_type = randi_range(0,3)
	if attack_type == 0:
		print("Beam Attack")
		enemy.velocity = Vector2.ZERO
		_timer = randf_range ( state_duration_min, state_duration_max )
		enemy.UpdateAnimation( anim_name )
		enemy.beam_attack.emit()
	else:
		print("Orb Attack")
		var bullet = ORB.instantiate()
		bullet.position = enemy.position
		add_child (bullet)
	pass
	
func exit() -> void:
	pass

func process( _delta : float ) -> EnemyState:
	_timer -= _delta
	if _timer <= 0:
		return after_idle_state
	return null

func physics( _delta : float ) -> EnemyState:
	return null
