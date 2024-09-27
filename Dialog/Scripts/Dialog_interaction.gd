@tool
@icon ("res://GUI/Dialog_System/Icons/chat_bubbles.svg")
class_name DialogInteraction extends Area2D

signal player_interacted
signal finished

@export var enabled : bool = true

var dialog_items : Array[ DialogItem ]

@onready var animation_player = $AnimationPlayer


func _ready():
	if Engine.is_editor_hint():
		return
	
	area_entered.connect( _on_area_entered )
	area_exited.connect( _on_area_exited )
	
	for c in get_children():
		if c is DialogItem:
			dialog_items.append( c )
	pass
	
func _get_configuration_warnings() -> PackedStringArray:
	if _check_for_dialog_items() == false:
		return [ "Requires at least 1 DialogItem Node" ]
	else: 
		return []
	
func _check_for_dialog_items() -> bool:
	for c in get_children():
		if c is DialogItem:
			return true
	return false

func player_interact() -> void:
	player_interacted.emit()
	await get_tree().process_frame
	await get_tree().process_frame
	DialogSystem.finished.connect( _on_dialog_finished )
	DialogSystem.show_dialog( dialog_items )
	pass

func _on_area_entered ( _a : Area2D ) -> void:
	if enabled == false or dialog_items.size() == 0:
		return
	animation_player.play("show")
	PlayerManager.interact_pressed.connect( player_interact )
	pass
	
func _on_area_exited ( _a : Area2D ) -> void:
	if enabled == false or dialog_items.size() == 0:
		return
	animation_player.play("hide")
	PlayerManager.interact_pressed.disconnect( player_interact )
	pass

func _on_dialog_finished () -> void:
	finished.emit()
	DialogSystem.finished.disconnect( _on_dialog_finished )


	
