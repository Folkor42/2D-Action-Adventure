extends CanvasLayer

const ERROR = preload("res://GUI/Shop Menu/Audio/error.wav")
const OPEN_SHOP = preload("res://GUI/Shop Menu/Audio/open_shop.wav")
const PURCHASE = preload("res://GUI/Shop Menu/Audio/purchase.wav")

signal shown
signal hidden

var is_active : bool = false

@onready var close_button: Button = %CloseButton
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	process_mode=Node.PROCESS_MODE_ALWAYS
	hide_menu()
	close_button.pressed.connect ( hide_menu )
	pass

func _unhandled_input(event: InputEvent) -> void:
	if is_active == false:
		return
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		hide_menu()

func show_menu( items : Array[ ItemData ],dialog_triggered : bool = true )-> void:
	print (items, str(items.size()))
	if dialog_triggered:
		await DialogSystem.finished
	enable_menu()
	play_audio(OPEN_SHOP)
	shown.emit()
	pass
	
func hide_menu()-> void:
	enable_menu( false )
	hidden.emit()
	pass

func enable_menu ( _enabled : bool = true ) -> void:
	get_tree().paused=_enabled
	visible=_enabled
	is_active = _enabled

func play_audio ( _audio : AudioStream ) -> void:
	audio_stream_player.stream = _audio
	audio_stream_player.play()
