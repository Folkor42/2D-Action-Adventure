class_name EnemyStateMachine extends Node

var states : Array [ EnemyState ]
var prev_state : EnemyState
var current_state : EnemyState

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ChangeState( current_state.process ( delta ) )
	pass

func _physics_process(delta):
	ChangeState( current_state.physics ( delta ) )
	pass


func initialize ( _enemy : Enemy ) -> void:
	states = []
	for c in get_children():
		if c is EnemyState:
			states.append( c )
	for s in states:
		s.enemy = _enemy
		s.state_machine = self
		s.init()
	if states.size() >0 :
		ChangeState ( states[0] )
		process_mode = Node.PROCESS_MODE_INHERIT
	pass

func ChangeState( new_state : EnemyState ) -> void:
	if new_state == null || new_state == current_state:
		return
	
	if current_state:
		current_state.exit()
	
	prev_state = current_state
	current_state = new_state
	current_state.enter()
