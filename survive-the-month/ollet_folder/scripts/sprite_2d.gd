
extends Sprite2D

@export var images: Array[Texture2D] = []
@export var fade_duration: float = 3.0
@export var display_duration: float = 5.0

func _ready():
	if images.size() < 3:
		print("Please add 3 images!")
		return

	var mat = material as ShaderMaterial

	# Keep the default Sprite2D texture as Image 1
	mat.set_shader_parameter("blend_amount", 0.0)

	# Wait before the first transition
	await get_tree().create_timer(display_duration).timeout

	# Transition through Images 2, 3, and 4
	for i in range(3):
		mat.set_shader_parameter("next_texture", images[i])
		mat.set_shader_parameter("blend_amount", 0.0)

		var tween = create_tween()
		tween.tween_method(
			func(value):
				mat.set_shader_parameter("blend_amount", value),
			0.0,
			1.0,
			fade_duration
		)

		await tween.finished

		# Update the default texture
		texture = images[i]
		mat.set_shader_parameter("blend_amount", 0.0)

		# Wait before next transition
		if i < 2:
			await get_tree().create_timer(display_duration).timeout
