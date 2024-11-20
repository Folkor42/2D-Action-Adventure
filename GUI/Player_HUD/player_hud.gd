extends CanvasLayer

@export var button_focus_audio : AudioStream = preload("res://assets/menu_focus.wav")
@export var button_select_audio : AudioStream = preload("res://assets/menu_select.wav")

var hearts : Array[ HeartGUI ] = []
var health_bar : Array [ BossPip ] =[]
@onready var pickup_label = $Control/PickupLabel
@onready var timer = $Control/PickupLabel/Timer
@onready var game_over = $Control2/GameOver
@onready var title_button = $Control2/GameOver/VBoxContainer/TitleButton
@onready var continue_button = $Control2/GameOver/VBoxContainer/ContinueButton
@onready var animation_player = $Control2/GameOver/AnimationPlayer
@onready var audio = $AudioStreamPlayer

func _ready():
	for child in $Control/HFlowContainer.get_children():
		if child is HeartGUI:
			hearts.append( child )
			child.visible = false
	timer.connect("timeout", _on_timer_timeout)
	
	hide_game_over_screen()
	continue_button.focus_entered.connect( play_audio.bind( button_focus_audio ))
	continue_button.pressed.connect( load_game )
	title_button.focus_entered.connect( play_audio.bind( button_focus_audio ))
	title_button.pressed.connect( title_screen )
	LevelManager.level_load_started.connect(hide_game_over_screen)
	LevelManager.BossFightStart.connect(show_boss_bar)
	LevelManager.BossFightEnd.connect(hide_boss_bar)
	pass # Replace with function body.

func hide_game_over_screen()->void:
	game_over.visible=false
	game_over.mouse_filter = Control.MOUSE_FILTER_IGNORE
	game_over.modulate = Color(1,1,1,0)
	pass

func show_game_over_screen()->void:
	game_over.visible=true
	game_over.mouse_filter = Control.MOUSE_FILTER_STOP
	
	var can_continue : bool = SaveManager.get_save_file() != null
	continue_button.visible = can_continue
	
	animation_player.play("show_game_over")
	await animation_player.animation_finished
		
	#focus a button
	if can_continue:
		continue_button.grab_focus()
	else:
		title_button.grab_focus()
		
	pass

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

func play_audio( _a : AudioStream ) -> void:
	audio.stream = _a
	audio.play()
	pass
	
func load_game() -> void:
	play_audio( button_select_audio )
	await fade_to_black()
	SaveManager.load_game()
	pass
	
func title_screen() -> void:
	play_audio( button_select_audio )
	await fade_to_black()
	LevelManager.load_new_level("res://scenes/Title Screen.tscn","",Vector2.ZERO)	
	pass

func fade_to_black() -> bool:
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	PlayerManager.player.revive_player()
	
	return true

func show_boss_bar (max_hp : int) -> void:
	for child in $Control3/HBoxContainer.get_children():
		if child is BossPip:
			health_bar.append( child )
			child.visible = false
	for p in max_hp:
		health_bar[p].visible=true
	health_bar[max_hp-1].end_pip=true
	health_bar[max_hp-1]._ready()
	
func hide_boss_bar () -> void:
	for child in $Control3/HBoxContainer.get_children():
		if child is BossPip:
			child.visible = false
#
func update_boss_health(hp : int)->void:
	health_bar[hp].animation_player.play("damage")
	await health_bar[hp].animation_player.animation_finished
	for p in health_bar.size():
		health_bar[p].full.visible=false
	for p in hp:
		health_bar[p].full.visible=true
	return
