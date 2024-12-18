extends CanvasLayer

signal shown
signal hidden

@onready var audio_stream_player = $AudioStreamPlayer

@onready var tab_container: TabContainer = $Control/TabContainer

@onready var button_save: Button = $Control/TabContainer/System/VBoxContainer/Button_Save
@onready var button_load: Button = $Control/TabContainer/System/VBoxContainer/Button_Load
@onready var button_quit: Button = $Control/TabContainer/System/VBoxContainer/Button_Quit
@onready var item_description = $Control/TabContainer/Inventory/item_description


var is_paused : bool = false

func _ready():
	hide_pause_menu()
	button_save.pressed.connect( _on_save_pressed )
	button_load.pressed.connect( _on_load_pressed )
	button_quit.pressed.connect( _on_quit_pressed )
	pass

func _unhandled_input(event) -> void:
	if event.is_action_pressed("pause"):
		if is_paused == false:
			if DialogSystem.is_active:
				return
			show_pause_menu()
		else:
			hide_pause_menu()
		get_viewport().set_input_as_handled()
		
	if is_paused:
		if event.is_action_pressed("right_bumper"):
			change_tab( 1 )
		if event.is_action_pressed("left_bumper"):
			change_tab( -1 )
	pass

func change_tab (_i : int )->void:
	tab_container.current_tab = wrapi (tab_container.current_tab+_i, 0,tab_container.get_tab_count())
	tab_container.get_tab_bar().grab_focus()
		
func show_pause_menu() -> void:
	get_tree().paused = true
	visible = true
	is_paused = true
	tab_container.current_tab=0
	shown.emit()
	
func hide_pause_menu() -> void:
	get_tree().paused = false
	visible = false
	is_paused = false 
	hidden.emit()

func _on_save_pressed() -> void:
	if is_paused == false:
		return
	SaveManager.save_game()
	hide_pause_menu()
	pass
	
func _on_load_pressed() -> void:
	if is_paused == false:
		return
	SaveManager.load_game()
	await LevelManager.level_load_started
	hide_pause_menu()
	pass

func _on_quit_pressed() -> void:
	get_tree().quit()
	pass

func update_item_description ( new_text : String ) -> void:
	item_description.text = new_text
	pass

func play_sound ( audio : AudioStream ) -> void:
	audio_stream_player.stream = audio
	audio_stream_player.play()
	pass
