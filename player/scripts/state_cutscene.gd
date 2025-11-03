class_name State_Cutscene extends State

@onready var idle: State_Idle = $"../Idle"

func init() -> void:
	DialogSystem.started.connect( _on_dialog_started )
	DialogSystem.finished.connect ( _on_dialog_finished )
	pass

func Enter() -> void:
	player.UpdateAnimation( "idle" )
	player.process_mode = Node.PROCESS_MODE_ALWAYS
	pass

func Exit() -> void:
	player.process_mode = Node.PROCESS_MODE_INHERIT
	pass

func Process( _delta : float ) -> State:
	player.velocity = Vector2.ZERO
	return null
	
func Physics ( _delta : float ) -> State:
	return null
		
func HandleInput ( _event: InputEvent ) -> State:
	return null
	
func _on_dialog_finished () -> void:
	state_machine.ChangeState(idle)
	pass

func _on_dialog_started () -> void:
	state_machine.ChangeState(self)
	pass
