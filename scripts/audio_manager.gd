extends Node

const SAMPLE_RATE := 44100

var _sound_player: AudioStreamPlayer
var _music_player: AudioStreamPlayer
var _music_phase := 0.0

func _ready() -> void:
	_sound_player = AudioStreamPlayer.new()
	add_child(_sound_player)

	_music_player = AudioStreamPlayer.new()
	add_child(_music_player)
	_music_player.volume_db = -24.0

	GameManager.settings_changed.connect(_on_settings_changed)
	_on_settings_changed()


func play_spin() -> void:
	_play_tone(160.0, 0.16, -12.0)


func play_win() -> void:
	_play_tone(720.0, 0.22, -8.0)


func play_jackpot() -> void:
	_play_tone(960.0, 0.35, -6.0)


func _on_settings_changed() -> void:
	if GameManager.music_enabled:
		_start_music()
	else:
		_music_player.stop()


func _play_tone(frequency: float, duration: float, volume_db: float) -> void:
	if not GameManager.sound_enabled:
		return

	var stream := AudioStreamGenerator.new()
	stream.mix_rate = SAMPLE_RATE
	stream.buffer_length = max(duration, 0.1)
	_sound_player.stream = stream
	_sound_player.volume_db = volume_db
	_sound_player.play()

	var playback := _sound_player.get_stream_playback() as AudioStreamGeneratorPlayback
	if playback == null:
		return

	var frame_count := int(SAMPLE_RATE * duration)
	for i in frame_count:
		var t := float(i) / SAMPLE_RATE
		var fade := 1.0 - (float(i) / frame_count)
		var sample := sin(TAU * frequency * t) * 0.32 * fade
		playback.push_frame(Vector2(sample, sample))


func _start_music() -> void:
	var stream := AudioStreamGenerator.new()
	stream.mix_rate = SAMPLE_RATE
	stream.buffer_length = 1.0
	_music_player.stream = stream
	if not _music_player.playing:
		_music_player.play()
	_fill_music_buffer()


func _process(_delta: float) -> void:
	if GameManager.music_enabled and _music_player.playing:
		_fill_music_buffer()


func _fill_music_buffer() -> void:
	var playback := _music_player.get_stream_playback() as AudioStreamGeneratorPlayback
	if playback == null:
		return

	while playback.get_frames_available() >= 512:
		var frames := PackedVector2Array()
		frames.resize(512)
		for i in 512:
			var frequency := 220.0 if int(_music_phase * 2.0) % 2 == 0 else 277.18
			var sample := sin(TAU * frequency * _music_phase) * 0.08
			frames[i] = Vector2(sample, sample)
			_music_phase += 1.0 / SAMPLE_RATE
		playback.push_buffer(frames)
