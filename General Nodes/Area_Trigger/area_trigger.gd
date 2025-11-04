class_name AreaTrigger extends Area2D

signal player_entered 

var dialog : DialogInteraction
var triggered : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect( _on_body_entered )
	for c in get_children():
		if c is  DialogInteraction:
			dialog = c
			break
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered (body : Node2D ) -> void:
	if triggered:
		return
	if body is Player:
		player_entered.emit()
		if dialog:
			triggered = true
			dialog.player_interact()
