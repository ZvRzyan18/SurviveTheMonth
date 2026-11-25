
extends Node2D

@export_group("Scene Transition Settings")
@export var next_scene: PackedScene
@export var enter_required: int = 3
@export var transition_duration: float = 1.0

var enter_count: int = 0
var is_transitioning: bool = false


func _ready():
	# Create fade overlay
	var fade = ColorRect.new()
	fade.name = "FadeOverlay"
	fade.color = Color.BLACK
	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	fade.modulate.a = 0.0

	# Add overlay above the scene
	var canvas = CanvasLayer.new()
	canvas.layer = 100
	add_child(canvas)
	canvas.add_child(fade)

	# Store overlay reference
	set_meta("fade_overlay", fade)


func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:

		if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:

			if is_transitioning:
				return

			enter_count += 1

			print("ENTER count: ", enter_count)

			if enter_count >= enter_required:
				change_to_next_scene()


func change_to_next_scene():
	if is_transitioning:
		return

	if next_scene == null:
		push_error("Please assign Next Scene in the Inspector.")
		return

	is_transitioning = true

	var fade = get_meta("fade_overlay") as ColorRect

	# Fade to black
	var tween = create_tween()
	tween.tween_property(
		fade,
		"modulate:a",
		1.0,
		transition_duration
	)

	await tween.finished

	# Load next scene
	get_tree().change_scene_to_packed(next_scene)
