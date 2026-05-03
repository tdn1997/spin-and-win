extends Node

signal coins_changed(coins: int)
signal bet_changed(bet: int)
signal last_win_changed(amount: int)
signal settings_changed

const STARTING_COINS := 1000
const DEFAULT_BET := 10
const SAVE_PATH := "user://settings.cfg"

var coins := STARTING_COINS:
	set(value):
		coins = max(value, 0)
		coins_changed.emit(coins)

var bet := DEFAULT_BET:
	set(value):
		bet = clamp(value, 1, 999)
		bet_changed.emit(bet)

var last_win := 0:
	set(value):
		last_win = max(value, 0)
		last_win_changed.emit(last_win)

var sound_enabled := true
var music_enabled := true

func _ready() -> void:
	load_settings()


func can_spin() -> bool:
	return coins >= bet


func spend_bet() -> bool:
	if not can_spin():
		return false

	coins -= bet
	last_win = 0
	save_settings()
	return true


func award(amount: int) -> void:
	last_win = amount
	if amount > 0:
		coins += amount
	save_settings()


func reset_coins() -> void:
	coins = STARTING_COINS
	last_win = 0
	save_settings()


func set_sound_enabled(enabled: bool) -> void:
	sound_enabled = enabled
	settings_changed.emit()
	save_settings()


func set_music_enabled(enabled: bool) -> void:
	music_enabled = enabled
	settings_changed.emit()
	save_settings()


func save_settings() -> void:
	var config := ConfigFile.new()
	config.set_value("player", "coins", coins)
	config.set_value("player", "bet", bet)
	config.set_value("audio", "sound_enabled", sound_enabled)
	config.set_value("audio", "music_enabled", music_enabled)
	config.save(SAVE_PATH)


func load_settings() -> void:
	var config := ConfigFile.new()
	var err := config.load(SAVE_PATH)
	if err != OK:
		return

	coins = int(config.get_value("player", "coins", STARTING_COINS))
	bet = int(config.get_value("player", "bet", DEFAULT_BET))
	sound_enabled = bool(config.get_value("audio", "sound_enabled", true))
	music_enabled = bool(config.get_value("audio", "music_enabled", true))
	settings_changed.emit()

