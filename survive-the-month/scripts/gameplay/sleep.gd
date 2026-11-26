extends Area3D

var scene_root : Node = null;
var enter_hint : Label = null;
var collide : bool = false;

func _ready():
	body_entered.connect(_on_body_entered);
	body_exited.connect(_on_body_exited);

func _on_body_entered(body : Node):
	if body.name == "Character":
		scene_root = get_tree().current_scene;
		enter_hint = scene_root.find_child("enter_hint");
	
		enter_hint.visible = true;
		enter_hint.text = "[Bed] : Press E to sleep.";
		collide = true;

func _on_body_exited(body : Node):
	if body.name == "Character":

		scene_root = get_tree().current_scene;
		enter_hint = scene_root.find_child("enter_hint");

		enter_hint.visible = false;
		collide = false;
	
func _input(event : InputEvent):
	if collide and event is InputEventKey:
		var input_key : InputEventKey = event as InputEventKey;
		if input_key.pressed and not input_key.echo:
			if input_key.keycode == KEY_E:
				GlobalState.current_day += 1;
