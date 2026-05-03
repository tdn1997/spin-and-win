extends Control

const REEL_SCRIPT := preload("res://scripts/reel.gd")

var _coins_label: Label
var _bet_label: Label
var _win_label: Label
var _message_label: Label
var _spin_button: Button
var _reels: Array[Control] = []

var _rng := RandomNumberGenerator.new()
var _spinning := false
var _stopped_count := 0
var _results: Array[Dictionary] = []
var _symbols: Array[Dictionary] = [
	{
		"id": "cherry",
		"label": "",
		"texture": load("res://assets/Slot Machine/slot-symbol1.png"),
	},
	{
		"id": "lemon",
		"label": "",
		"texture": load("res://assets/Slot Machine/slot-symbol2.png"),
	},
	{
		"id": "plum",
		"label": "",
		"texture": load("res://assets/Slot Machine/slot-symbol3.png"),
	},
	{
		"id": "bell",
		"label": "",
		"texture": load("res://assets/Slot Machine/slot-symbol4.png"),
	},
	{
		"id": "777",
		"label": "777",
		"texture": null,
	},
]

func _ready() -> void:
	_rng.randomize()
	_build_ui()
	_spin_button.pressed.connect(_on_spin_pressed)
	GameManager.coins_changed.connect(_refresh_ui)
	GameManager.bet_changed.connect(_refresh_ui)
	GameManager.last_win_changed.connect(_refresh_ui)

	for reel in _reels:
		reel.stopped.connect(_on_reel_stopped)
		reel.set_symbol(_symbols[_rng.randi_range(0, _symbols.size() - 1)])

	_refresh_ui()


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color(0.09, 0.11, 0.16)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var safe_area := MarginContainer.new()
	safe_area.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	safe_area.add_theme_constant_override("margin_left", 28)
	safe_area.add_theme_constant_override("margin_top", 36)
	safe_area.add_theme_constant_override("margin_right", 28)
	safe_area.add_theme_constant_override("margin_bottom", 36)
	add_child(safe_area)

	var root := VBoxContainer.new()
	root.alignment = BoxContainer.ALIGNMENT_CENTER
	root.add_theme_constant_override("separation", 18)
	safe_area.add_child(root)

	var title := Label.new()
	title.text = "spin-and-win"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 40)
	title.add_theme_color_override("font_color", Color(0.98, 0.9, 0.58))
	root.add_child(title)

	var machine := TextureRect.new()
	machine.texture = load("res://assets/Slot Machine/slot-machine1.png")
	machine.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	machine.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	machine.custom_minimum_size = Vector2(0, 220)
	root.add_child(machine)

	var stats := HBoxContainer.new()
	stats.alignment = BoxContainer.ALIGNMENT_CENTER
	stats.add_theme_constant_override("separation", 10)
	root.add_child(stats)

	_coins_label = _make_stat(stats, "COINS")
	_bet_label = _make_stat(stats, "BET")
	_win_label = _make_stat(stats, "WIN")

	var reel_row := HBoxContainer.new()
	reel_row.alignment = BoxContainer.ALIGNMENT_CENTER
	reel_row.add_theme_constant_override("separation", 12)
	root.add_child(reel_row)

	for i in 3:
		var reel: Control = REEL_SCRIPT.new()
		reel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		reel_row.add_child(reel)
		_reels.append(reel)

	_message_label = Label.new()
	_message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_message_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_message_label.add_theme_font_size_override("font_size", 22)
	root.add_child(_message_label)

	_spin_button = Button.new()
	_spin_button.text = "SPIN"
	_spin_button.custom_minimum_size = Vector2(0, 74)
	_spin_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_spin_button.add_theme_font_size_override("font_size", 30)
	root.add_child(_spin_button)

	var back_button := Button.new()
	back_button.text = "MENU"
	back_button.custom_minimum_size = Vector2(0, 54)
	back_button.pressed.connect(get_tree().change_scene_to_file.bind("res://scenes/main_menu.tscn"))
	root.add_child(back_button)


func _make_stat(parent: Control, label: String) -> Label:
	var box := VBoxContainer.new()
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(box)

	var caption := Label.new()
	caption.text = label
	caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	caption.add_theme_font_size_override("font_size", 15)
	caption.add_theme_color_override("font_color", Color(0.7, 0.76, 0.84))
	box.add_child(caption)

	var value := Label.new()
	value.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	value.add_theme_font_size_override("font_size", 24)
	value.add_theme_color_override("font_color", Color.WHITE)
	box.add_child(value)
	return value


func _refresh_ui(_value: int = 0) -> void:
	_coins_label.text = str(GameManager.coins)
	_bet_label.text = str(GameManager.bet)
	_win_label.text = str(GameManager.last_win)
	_spin_button.disabled = _spinning or not GameManager.can_spin()

	if not GameManager.can_spin():
		_message_label.text = "Not enough coins. Reset in Settings."
	elif GameManager.last_win > 0:
		_message_label.text = "Nice win!"
	else:
		_message_label.text = "Tap SPIN to play"


func _on_spin_pressed() -> void:
	if _spinning:
		return

	if not GameManager.spend_bet():
		_refresh_ui()
		return

	_spinning = true
	_stopped_count = 0
	_results.clear()
	_message_label.text = "Spinning..."
	_spin_button.disabled = true
	AudioManager.play_spin()

	for index in _reels.size():
		var symbol := _symbols[_rng.randi_range(0, _symbols.size() - 1)]
		_results.append(symbol)
		var duration := 0.65 + float(index) * 0.25
		_reels[index].spin_to(symbol, duration)


func _on_reel_stopped(_symbol_id: String) -> void:
	_stopped_count += 1
	if _stopped_count < _reels.size():
		return

	var payout := _calculate_payout(_results)
	GameManager.award(payout)
	_spinning = false
	_spin_button.disabled = not GameManager.can_spin()

	if payout >= GameManager.bet * 25:
		_message_label.text = "JACKPOT!"
		AudioManager.play_jackpot()
	elif payout > 0:
		_message_label.text = "You won %s coins!" % payout
		AudioManager.play_win()
	else:
		_message_label.text = "Try again"


func _calculate_payout(results: Array[Dictionary]) -> int:
	var ids: Array[String] = []
	for result in results:
		ids.append(String(result.get("id", "")))

	if ids.size() == 3 and ids[0] == "777" and ids[1] == "777" and ids[2] == "777":
		return GameManager.bet * 50

	if ids.size() == 3 and ids[0] == ids[1] and ids[1] == ids[2]:
		return GameManager.bet * 10

	if ids.size() == 3 and (ids[0] == ids[1] or ids[1] == ids[2] or ids[0] == ids[2]):
		return GameManager.bet * 2

	return 0
