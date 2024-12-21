class_name TeleportControl extends Control

signal teleport( location : String )

@onready var control_teleport: Control = $"."
@onready var button: Button = $VBoxContainer/Button
@onready var button_2: Button = $VBoxContainer/Button2
@onready var button_3: Button = $VBoxContainer/Button3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_teleport_choices()
	button.pressed.connect ( selected.bind (button) )
	button_2.pressed.connect ( selected.bind (button_2) )
	button_3.pressed.connect ( selected.bind (button_3) )
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func show_teleport_choices()->void:
	control_teleport.visible=true
	get_tree().paused=true
	
func selected( _button )->void:
	get_tree().paused=false
	teleport.emit(_button.level)
	hide_teleport_choices()
	
func hide_teleport_choices()->void:
	control_teleport.visible=false
