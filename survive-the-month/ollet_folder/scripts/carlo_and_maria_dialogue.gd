extends Label

@export_group("Typing Settings")
@export var typing_speed: float = 0.04
@export var start_delay: float = 1.0

@export_group("Disappear & Transition Settings")
@export var disappear_fade_duration: float = 0.5
@export var transition_duration: float = 0.6
@export var transition_color: Color = Color.BLACK
@export var next_scene_path: String = "res://ollet_folder/scenes/DayTransition.tscn"

var dialogues: Array[String] = [
	"Carlo: Maria, I'm home.",
	"Maria: Welcome home, honey. How was work today?",
	"Carlo: Maria, we need to talk. Something bad happened at work.",
	"Maria: What happened, Carlo? Is everything okay?",
	"Carlo: My boss called me into his office earlier. He told me that the company is losing money.",
	"Maria: What does that mean?",
	"Carlo: He said the company can no longer afford to keep all its employees. I lost my job, Maria.",
	"Maria: Oh no, Carlo. I'm so sorry to hear that.",
	"Carlo: I didn't expect this to happen. I've worked so hard, but now I don't know what to do.",
	"Maria: It's okay, honey. Don't lose hope. We'll figure something out.",
	"Carlo: I received my final salary of ₱18,000. This is all we have for now.",
	"Carlo: We need to make this money last for an entire month. We have to be careful with our expenses.",
	"Maria: That's okay, Carlo. We can manage. We'll find a way to make it work.",
	"Carlo: I'm worried that we won't have enough money for our daily needs.",
	"Maria: Don't worry, honey. We can save money and avoid unnecessary expenses. We can still get through this.",
	"Carlo: Thank you, Maria. I'm glad I have you by my side.",
	"Maria: Of course, Carlo. We're a team, and we'll face every problem together."
]

var current_dialogue: int = -1
var is_typing: bool = false
var dialogue_started: bool = false
var dialogue_finished: bool = false
var is_disappearing: bool = false

var typing_elapsed: float = 0.0


func _ready() -> void:
	text = ""
	visible_characters = 0

	await get_tree().create_timer(start_delay).timeout

	dialogue_started = true
	current_dialogue = 0
	show_dialogue()


func _process(delta: float) -> void:
	if not is_typing:
		return

	typing_elapsed += delta

	if typing_speed <= 0:
		visible_characters = -1
		is_typing = false
		return

	var characters_to_show: int = int(typing_elapsed / typing_speed)
	visible_characters = min(characters_to_show, text.length())

	if visible_characters >= text.length():
		is_typing = false


func show_dialogue() -> void:
	if current_dialogue < 0 or current_dialogue >= dialogues.size():
		return

	text = dialogues[current_dialogue]
	visible_characters = 0
	typing_elapsed = 0.0
	is_typing = true


func _input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return

	if not event.pressed or event.echo:
		return

	if event.keycode != KEY_ENTER and event.keycode != KEY_KP_ENTER:
		return

	if not dialogue_started or dialogue_finished or is_disappearing:
		return

	# If this is the last message, fade out and transition to the next scene
	if current_dialogue >= dialogues.size() - 1:
		disappear_and_transition()
		return

	# Move to the next message immediately, even while typing
	current_dialogue += 1
	show_dialogue()


func disappear_and_transition() -> void:
	is_disappearing = true
	is_typing = false
	dialogue_finished = true

	var overlay_layer := CanvasLayer.new()
	overlay_layer.layer = 100

	var overlay_rect := ColorRect.new()
	overlay_rect.color = transition_color
	overlay_rect.modulate.a = 0.0
	overlay_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

	overlay_layer.add_child(overlay_rect)
	add_child(overlay_layer)

	# Fade out the label and fade the screen to black at the same time
	var fade_out_tween := create_tween()
	fade_out_tween.set_parallel(true)
	fade_out_tween.tween_property(self, "modulate:a", 0.0, disappear_fade_duration) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	fade_out_tween.tween_property(overlay_rect, "modulate:a", 1.0, transition_duration) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

	await fade_out_tween.finished

	visible = false

	if is_inside_tree():
		overlay_layer.reparent(get_tree().root)

		var fade_in_tween := overlay_layer.create_tween()
		fade_in_tween.tween_interval(0.05)
		fade_in_tween.tween_property(overlay_rect, "modulate:a", 0.0, transition_duration) \
			.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		fade_in_tween.tween_callback(overlay_layer.queue_free)

		get_tree().change_scene_to_file(next_scene_path)
