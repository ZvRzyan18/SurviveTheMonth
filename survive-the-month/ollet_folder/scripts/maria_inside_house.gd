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

var is_disappeared: bool = false
var is_ready_for_input: bool = false
var active_tween: Tween = null


func _ready() -> void:
	modulate.a = 0.0

	if textures.size() != enter_counts.size():
		push_warning("Textures and Enter Counts must have matching sizes.")

	var previous_count: int = 0
	for count in enter_counts:
		if count <= previous_count:
			push_warning("Enter Counts must be in ascending order.")
			break
		previous_count = count

	await get_tree().create_timer(start_delay).timeout

	active_tween = create_tween()
	active_tween.tween_property(self, "modulate:a", 1.0, fade_duration) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	active_tween.tween_callback(func(): is_ready_for_input = true)


func _input(event: InputEvent) -> void:
	if not is_ready_for_input or is_disappeared:
		return

	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			enter_count += 1

			# Disappear immediately when threshold is reached
			if disappear_after_enter > 0 and enter_count >= disappear_after_enter:
				disappear_image()
				return

			# Advance through any reached image thresholds
			if current_image_index < enter_counts.size() and enter_count >= enter_counts[current_image_index]:
				var next_texture: Texture2D = null
				if current_image_index < textures.size():
					next_texture = textures[current_image_index]
				current_image_index += 1

				if next_texture != null:
					change_image(next_texture)


func change_image(new_texture: Texture2D) -> void:
	var interrupted := false
	if active_tween and active_tween.is_running():
		active_tween.kill()
		interrupted = true

	active_tween = create_tween()

	if interrupted:
		# Player is clicking fast: swap texture immediately and fade in from current alpha
		texture = new_texture
		active_tween.tween_property(self, "modulate:a", 1.0, fade_duration) \
			.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	else:
		# Normal speed: fade out, swap texture, then fade in
		active_tween.tween_property(self, "modulate:a", 0.0, fade_out_duration) \
			.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		active_tween.tween_callback(func(): texture = new_texture)
		active_tween.tween_property(self, "modulate:a", 1.0, fade_duration) \
			.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func disappear_image() -> void:
	is_disappeared = true

	if active_tween and active_tween.is_running():
		active_tween.kill()

	active_tween = create_tween()
	active_tween.tween_property(self, "modulate:a", 0.0, fade_out_duration) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
