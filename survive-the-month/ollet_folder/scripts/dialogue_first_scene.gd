
extends Label

@export_group("Typing Settings")
@export var typing_speed: float = 0.04
@export var start_delay: float = 1.0

@export_group("Input Settings")
@export var enter_cooldown: float = 0.15

@export_group("Disappear Settings")
@export var disappear_fade_duration: float = 0.5

var dialogues = [
	"Carlo: Good morning, sir",
	"Boss: Good morning, Carlo. I'm glad you came.",
	"Boss: as you know, the company has been experiencing financial problems lately.",
	"Carlo: Yes, sir. I've heard about it. Is the company going bankrupt?",
	"Boss: We're trying to avoid that, but unfortunately, we need to reduce the number of employees to save money.",
	"Carlo: Wait, sir. Does that mean I'm losing my job?",
	"Boss: I'm sorry, Carlo, but yes. Your position is being terminated.",
	"Carlo: But sir, I've worked here for years. I really need this job.",
	"Boss: I understand, Carlo. This decision isn't about your performance. It's simply because the company can no longer afford to keep everyone.",
	"Carlo: I understand, sir. Thank you for giving me the opportunity to work here.",
	"Boss: Thank you for your hard work, Carlo. I wish you the best.",
	"Carlo: I should go home now. I need to tell my wife what happened.",
	"Carlo: I just hope she'll understand. I don't even know how we're going to manage our expenses.",
	"Carlo: I never thought this day would come. I've always believed I would have a stable job here."
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
		self.get_tree().change_scene_to_file("res://scenes/Gameplay.tscn");
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
