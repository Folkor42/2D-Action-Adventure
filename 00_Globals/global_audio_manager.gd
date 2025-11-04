extends Node

var music_audio_player_count : int = 2
var current_music_player : int = 0
var music_players : Array[ AudioStreamPlayer ] = []
var music_bus : String = "Music"

var music_fade_duration : float = 0.5

func _ready() -> void:
	process_mode=Node.PROCESS_MODE_ALWAYS
	for i in music_audio_player_count:
		var audioplayer = AudioStreamPlayer.new()
		add_child( audioplayer )
		audioplayer.bus = music_bus
		music_players.append ( audioplayer )
		audioplayer.volume_db=-80
	pass
	
func play_music( _audio : AudioStream ) -> void:
	if _audio == music_players[current_music_player].stream:
		return
	
	var old_player : AudioStreamPlayer = music_players[ current_music_player ]
	current_music_player+=1
	if current_music_player > 1:
		current_music_player=0
	
	var current_player : AudioStreamPlayer = music_players[ current_music_player ]
	current_player.stream = _audio
	play_and_fade_in( current_player )
	fade_out_and_stop( old_player )
	pass


func play_and_fade_in ( audioplayer : AudioStreamPlayer ) -> void:
	audioplayer.play()
	var tween : Tween = create_tween()
	tween.tween_property( audioplayer, 'volume_db', 0, music_fade_duration )
	pass

func fade_out_and_stop ( audioplayer : AudioStreamPlayer ) -> void:
	var tween : Tween = create_tween()
	tween.tween_property( audioplayer, 'volume_db', -80, music_fade_duration )
	await tween.finished
	audioplayer.stop()
	pass

func get_current_track () -> AudioStream:
	return music_players[current_music_player].stream
