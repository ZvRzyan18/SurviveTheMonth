
extends Label

@export_group("Typing Settings")
@export var typing_speed: float = 0.04
@export var start_delay: float = 1.0

@export_group("Input Settings")
@export var enter_cooldown: float = 0.15

@export_group("Disappear Settings")
@export var disappear_fade_duration: float = 0.5

var dialogues = [
	"Boss: Carlo, can you come to my office? We need to talk.",
	"Carlo: Yes, sir. Is there something wrong?",
	"Boss: I need you in my office immediately, Carlo. This is a very important matter that we need to discuss."
]

var current_dialogue: int = -1
var is_typing: bool = false
var dialogue_started: bool = false
var dialogue_finished: bool = false
var is_disappearing: bool = false

var typing_elapsed: float = 0.0
var enter_timer: float = 0.0


func _ready():
	text = ""
	visible_characters = 0

	await get_tree().create_timer(start_delay).timeout

	dialogue_started = true
	current_dialogue = 0
	show_dialogue()


func _process(delta):
	if enter_timer > 0:
		enter_timer = maxf(enter_timer - delta, 0.0)

	if not is_typing:
		return

	typing_elapsed += delta

	if typing_speed <= 0:
		visible_characters = -1
		is_typing = false
		return

	var characters_to_show = int(typing_elapsed / typing_speed)

	visible_characters = min(
		characters_to_show,
		text.length()
	)

	if visible_characters >= text.length():
		is_typing = false


func show_dialogue():
	if current_dialogue < 0 or current_dialogue >= dialogues.size():
		return

	text = dialogues[current_dialogue]
	visible_characters = 0

	typing_elapsed = 0.0
	is_typing = true



func _input(event):
	if event is not InputEventKey:
		return

	if not event.pressed or event.echo:
		return

	if event.keycode != KEY_ENTER and event.keycode != KEY_KP_ENTER:
		return

	if not dialogue_started or dialogue_finished or is_disappearing:
		return

	if enter_timer > 0:
		return

	enter_timer = enter_cooldown

	# If this is the last message, disappear immediately
	if current_dialogue == dialogues.size() - 1:
		disappear_dialogue()
		return

	# Move to the next message, even while typing
	current_dialogue += 1
	show_dialogue()


func disappear_dialogue():
	is_disappearing = true
	is_typing = false
	dialogue_finished = true

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN)

	tween.tween_property(
		self,
		"modulate:a",
		0.0,
		disappear_fade_duration
	)

	await tween.finished

	visible = false
