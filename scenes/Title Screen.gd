extends Node2D

const START_LEVEL : String = "res://Levels/Area1/01.tscn"

@onready var new_game_button: Button = $CanvasLayer/Control/NewGameButton
@onready var load_game_button: Button = $CanvasLayer/Control/LoadGameButton
@onready var quit_game_button: Button = $CanvasLayer/Control/QuitGameButton
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export var music : AudioStream
@export var button_focus_audio : AudioStream
@export var button_pressed_audio : AudioStream

func _ready() -> void:
	get_tree().paused = true
	PlayerManager.player.visible = false
	PlayerHud.visible = false
	PauseMenu.process_mode = Node.PROCESS_MODE_DISABLED
	
	$CanvasLayer/SplashScreen.finished.connect(	_setup_title_Screen )
	
	LevelManager.level_load_started.connect( _exit_title_screen )
	
	pass

func _setup_title_Screen() -> void:
	AudioManager.play_music( music )
	new_game_button.pressed.connect( _start_game )
	if SaveManager.get_save_file() == null:
		load_game_button.disabled = true
	load_game_button.pressed.connect( _load_game )
	quit_game_button.pressed.connect( _quit_game )
	new_game_button.grab_focus()
	
	new_game_button.focus_entered.connect( play_audio.bind( button_focus_audio ) )
	load_game_button.focus_entered.connect( play_audio.bind( button_focus_audio ) )
	quit_game_button.focus_entered.connect( play_audio.bind( button_focus_audio ) )
	
	pass
	
func _start_game() -> void:
	play_audio( button_pressed_audio )
	LevelManager.load_new_level( START_LEVEL, "",Vector2.ZERO )
	pass

func _load_game() -> void:
	play_audio( button_pressed_audio )
	SaveManager.load_game()
	pass

func _quit_game() -> void:
	play_audio( button_pressed_audio )
	get_tree().quit()
	pass

func _exit_title_screen() -> void:
	PlayerManager.player.visible = true
	PlayerHud.visible = true
	PauseMenu.process_mode = Node.PROCESS_MODE_ALWAYS
	PlayerManager.player_spawned = false
	self.queue_free()
	pass

func play_audio( _a : AudioStream ) -> void:
	audio_stream_player.stream = _a
	audio_stream_player.play()
	pass
