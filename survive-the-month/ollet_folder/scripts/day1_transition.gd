extends Node

@export_group("Scene Transition Settings")
@export var next_scene: PackedScene
@export var auto_start: bool = true
@export var allow_skip_with_enter: bool = false

@export_group("Timing Settings")
@export var fade_in_duration: float = 0.6
@export var hold_duration: float = 2.0
@export var fade_out_duration: float = 0.6

@export_group("Visual Settings")
@export var transition_color: Color = Color.BLACK

var is_transitioning: bool = false
var skip_requested: bool = false


func _ready() -> void:
	if auto_start:
		show_and_transition()


func _input(event: InputEvent) -> void:
	if not allow_skip_with_enter or not is_transitioning:
		return

	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			skip_requested = true


func show_and_transition() -> void:
	if is_transitioning:
		return

	if next_scene == null:
		push_warning("Next Scene is empty. Assign a .tscn file in the Inspector.")
		return

	is_transitioning = true
	skip_requested = false

	# Add to self first so it works immediately in _ready() without a 1-frame flash
	var overlay_layer := CanvasLayer.new()
	overlay_layer.layer = 100

	var overlay_rect := ColorRect.new()
	overlay_rect.color = transition_color
	overlay_rect.modulate.a = 1.0
	overlay_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

	overlay_layer.add_child(overlay_rect)
	add_child(overlay_layer)

	# Wait one frame so the new scene is settled before starting the fade-in timer
	await get_tree().process_frame

	# 1. Fade in to reveal this scene
	if fade_in_duration > 0.0:
		var reveal_tween := create_tween()
		reveal_tween.tween_property(overlay_rect, "modulate:a", 0.0, fade_in_duration) \
			.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		await reveal_tween.finished
	else:
		overlay_rect.modulate.a = 0.0

	# 2. Hold while the scene is shown (clamped delta prevents load spikes from skipping time)
	var elapsed: float = 0.0
	while elapsed < hold_duration and not skip_requested:
		await get_tree().process_frame
		elapsed += minf(get_process_delta_time(), 0.05)

	# 3. Fade out to cover the screen before switching scenes
	if fade_out_duration > 0.0:
		var cover_tween := create_tween()
		cover_tween.tween_property(overlay_rect, "modulate:a", 1.0, fade_out_duration) \
			.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		await cover_tween.finished
	else:
		overlay_rect.modulate.a = 1.0

	# 4. Move overlay to root so it survives scene change, switch scene, then fade out
	if is_inside_tree():
		overlay_layer.reparent(get_tree().root)

		var next_reveal_tween := overlay_layer.create_tween()
		next_reveal_tween.tween_interval(0.05)
		next_reveal_tween.tween_property(overlay_rect, "modulate:a", 0.0, fade_in_duration) \
			.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		next_reveal_tween.tween_callback(overlay_layer.queue_free)

		get_tree().change_scene_to_packed(next_scene)
