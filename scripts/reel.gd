extends Control
class_name SlotReel

signal stopped(symbol_id: String)

@export var symbol_texture: TextureRect
@export var jackpot_label: Label

var current_symbol_id := ""
var _rng := RandomNumberGenerator.new()
var _is_spinning := false

func _ready() -> void:
	_rng.randomize()
	pivot_offset = size * 0.5
	_build_ui_if_needed()


func set_symbol(symbol: Dictionary) -> void:
	current_symbol_id = String(symbol.get("id", ""))
	var texture := symbol.get("texture", null) as Texture2D
	var label := String(symbol.get("label", ""))

	if symbol_texture != null:
		symbol_texture.texture = texture
		symbol_texture.visible = texture != null

	if jackpot_label != null:
		jackpot_label.text = label
		jackpot_label.visible = texture == null


func spin_to(symbol: Dictionary, duration: float) -> void:
	if _is_spinning:
		return

	_is_spinning = true
	var loops: int = maxi(4, int(duration * 9.0))
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	for i in loops:
		tween.tween_property(self, "scale", Vector2(0.86, 1.12), 0.045)
		tween.tween_property(self, "scale", Vector2.ONE, 0.045)
		tween.tween_callback(_shake_symbol)

	tween.tween_callback(set_symbol.bind(symbol))
	tween.tween_property(self, "scale", Vector2(1.08, 0.92), 0.08)
	tween.tween_property(self, "scale", Vector2.ONE, 0.10)
	tween.tween_callback(_finish_spin)


func _shake_symbol() -> void:
	rotation_degrees = _rng.randf_range(-4.0, 4.0)
	position.x = _rng.randf_range(-3.0, 3.0)


func _finish_spin() -> void:
	rotation_degrees = 0.0
	position.x = 0.0
	_is_spinning = false
	stopped.emit(current_symbol_id)


func _build_ui_if_needed() -> void:
	if symbol_texture != null and jackpot_label != null:
		return

	custom_minimum_size = Vector2(150, 180)

	var panel := PanelContainer.new()
	panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_bottom", 12)
	panel.add_child(margin)

	var center := CenterContainer.new()
	margin.add_child(center)

	symbol_texture = TextureRect.new()
	symbol_texture.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	symbol_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	symbol_texture.custom_minimum_size = Vector2(108, 108)
	center.add_child(symbol_texture)

	jackpot_label = Label.new()
	jackpot_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	jackpot_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	jackpot_label.add_theme_font_size_override("font_size", 44)
	jackpot_label.add_theme_color_override("font_color", Color(1.0, 0.88, 0.2))
	jackpot_label.visible = false
	center.add_child(jackpot_label)
