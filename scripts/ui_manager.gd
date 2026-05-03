extends Control

enum ScreenKind {
	MAIN_MENU,
	SETTINGS,
}

@export var screen_kind := ScreenKind.MAIN_MENU

func _ready() -> void:
	match screen_kind:
		ScreenKind.MAIN_MENU:
			_setup_main_menu()
		ScreenKind.SETTINGS:
			_setup_settings()


func _setup_main_menu() -> void:
	_build_base_background()
	var root := _make_center_stack()

	var art := TextureRect.new()
	art.texture = load("res://assets/Slot Machine/slot-machine2.png")
	art.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	art.custom_minimum_size = Vector2(0, 320)
	root.add_child(art)

	var title := Label.new()
	title.text = "spin-and-win"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 46)
	title.add_theme_color_override("font_color", Color(0.98, 0.9, 0.58))
	root.add_child(title)

	var play_button := _make_menu_button("PLAY")
	play_button.pressed.connect(_change_scene.bind("res://scenes/game.tscn"))
	root.add_child(play_button)

	var settings_button := _make_menu_button("SETTINGS")
	settings_button.pressed.connect(_change_scene.bind("res://scenes/settings.tscn"))
	root.add_child(settings_button)

	var exit_button := _make_menu_button("EXIT")
	exit_button.pressed.connect(get_tree().quit)
	root.add_child(exit_button)


func _setup_settings() -> void:
	_build_base_background()
	var root := _make_center_stack()

	var title := Label.new()
	title.text = "Settings"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 42)
	root.add_child(title)

	var sound_toggle := CheckButton.new()
	sound_toggle.text = "Sound"
	sound_toggle.button_pressed = GameManager.sound_enabled
	sound_toggle.toggled.connect(GameManager.set_sound_enabled)
	root.add_child(sound_toggle)

	var music_toggle := CheckButton.new()
	music_toggle.text = "Music"
	music_toggle.button_pressed = GameManager.music_enabled
	music_toggle.toggled.connect(GameManager.set_music_enabled)
	root.add_child(music_toggle)

	var reset_button := _make_menu_button("RESET COINS")
	reset_button.pressed.connect(_reset_coins)
	root.add_child(reset_button)

	var reset_status := Label.new()
	reset_status.name = "ResetStatusLabel"
	reset_status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	reset_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	root.add_child(reset_status)

	var back_button := _make_menu_button("BACK")
	back_button.pressed.connect(_change_scene.bind("res://scenes/main_menu.tscn"))
	root.add_child(back_button)


func _reset_coins() -> void:
	GameManager.reset_coins()
	var status := find_child("ResetStatusLabel", true, false) as Label
	if status != null:
		status.text = "Coins reset to %s" % GameManager.STARTING_COINS


func _change_scene(path: String) -> void:
	get_tree().change_scene_to_file(path)


func _build_base_background() -> void:
	var background := ColorRect.new()
	background.color = Color(0.08, 0.1, 0.14)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)


func _make_center_stack() -> VBoxContainer:
	var safe_area := MarginContainer.new()
	safe_area.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	safe_area.add_theme_constant_override("margin_left", 30)
	safe_area.add_theme_constant_override("margin_top", 42)
	safe_area.add_theme_constant_override("margin_right", 30)
	safe_area.add_theme_constant_override("margin_bottom", 42)
	add_child(safe_area)

	var center := CenterContainer.new()
	safe_area.add_child(center)

	var root := VBoxContainer.new()
	root.alignment = BoxContainer.ALIGNMENT_CENTER
	root.add_theme_constant_override("separation", 18)
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.custom_minimum_size = Vector2(0, 620)
	center.add_child(root)
	return root


func _make_menu_button(text: String) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(0, 68)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_font_size_override("font_size", 24)
	return button
