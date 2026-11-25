
extends Sprite2D

@export_group("Fade Settings")
@export var fade_duration: float = 1.0
@export var start_delay: float = 0.5
@export var fade_out_duration: float = 0.5

@export_group("Image Change Settings")
@export var textures: Array[Texture2D]
@export var enter_counts: Array[int] = [3, 7, 12]

@export_group("Image Disappear Settings")
@export var disappear_after_enter: int = 15

var enter_count: int = 0
var current_image_index: int = 0

var is_animating: bool = false
var is_disappeared: bool = false
var is_ready_for_input: bool = false

var animation_queue: Array[Texture2D] = []
var disappear_queued: bool = false


func _ready():
	modulate.a = 0.0

	if textures.size() != enter_counts.size():
		push_warning("Textures and Enter Counts must have matching sizes.")

	var previous_count = 0

	for count in enter_counts:
		if count <= previous_count:
			push_warning("Enter Counts must be in ascending order.")
			break
		previous_count = count

	await get_tree().create_timer(start_delay).timeout

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 1.0, fade_duration)

	await tween.finished

	is_ready_for_input = true


func _input(event):
	if not is_ready_for_input:
		return

	if is_disappeared or disappear_queued:
		return

	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:

			enter_count += 1

			# Disappear condition
			if disappear_after_enter > 0 and enter_count >= disappear_after_enter:
				disappear_queued = true
				process_queue()
				return

			# Image change condition
			if current_image_index < enter_counts.size():
				if enter_count == enter_counts[current_image_index]:

					if current_image_index < textures.size():
						var next_texture = textures[current_image_index]

						if next_texture != null:
							animation_queue.append(next_texture)
							current_image_index += 1
							process_queue()


func process_queue():
	if is_animating or is_disappeared:
		return

	if animation_queue.size() > 0:
		change_image(animation_queue.pop_front())
	elif disappear_queued:
		disappear_image()


func change_image(new_texture: Texture2D) -> void:
	is_animating = true

	# Fade out current image
	var fade_out = create_tween()
	fade_out.set_trans(Tween.TRANS_CUBIC)
	fade_out.set_ease(Tween.EASE_IN)
	fade_out.tween_property(self, "modulate:a", 0.0, fade_out_duration)

	await fade_out.finished

	# Change texture
	texture = new_texture

	# Fade in new image
	var fade_in = create_tween()
	fade_in.set_trans(Tween.TRANS_CUBIC)
	fade_in.set_ease(Tween.EASE_OUT)
	fade_in.tween_property(self, "modulate:a", 1.0, fade_duration)

	await fade_in.finished

	is_animating = false
	process_queue()


func disappear_image() -> void:
	is_animating = true

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "modulate:a", 0.0, fade_out_duration)

	await tween.finished

	is_disappeared = true
	is_animating = false
