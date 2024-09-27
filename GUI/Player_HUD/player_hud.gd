extends CanvasLayer

var hearts : Array[ HeartGUI ] = []
@onready var pickup_label = $Control/PickupLabel
@onready var timer = $Control/PickupLabel/Timer



func _ready():
	for child in $Control/HFlowContainer.get_children():
		if child is HeartGUI:
			hearts.append( child )
			child.visible = false
	timer.connect("timeout", _on_timer_timeout)
	pass # Replace with function body.

func update_hp ( _hp : int, _max_hp : int ) -> void:
	update_max_hp( _max_hp )
	@warning_ignore("integer_division")
	var max_heart = _max_hp/2
	for i in max_heart:
		update_heart ( i , _hp )
		pass
	pass

func update_heart ( _index : int, _hp : int ) -> void:
	var _value : int = clampi( _hp - _index * 2, 0, 2 )
	hearts[ _index ].value = _value
	pass

func update_max_hp ( _max_hp : int ) -> void:
	@warning_ignore("integer_division")
	var _heart_count : int = roundi ( _max_hp / 2 )
	for i in hearts.size():
		if i < _heart_count :
			hearts[i].visible = true
		else: 
			hearts[i].visible = false
	pass

func update_display_pickup ( text : String ) ->void:
	if timer.is_stopped():
		pickup_label.text = text
		timer.start()
	else:
		pickup_label.text +="\n" + text
		timer.start()
	pass
	
func _on_timer_timeout() -> void:
	pickup_label.text = ""
	pass


	
