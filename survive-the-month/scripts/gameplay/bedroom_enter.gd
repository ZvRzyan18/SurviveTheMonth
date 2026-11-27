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
		enter_hint.text = "[Bedroom] : Press E to enter.";
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
				GlobalState.change_map.emit(GlobalState.LOCATION_BEDROOM, Vector3(0.0, 1.64, -12.31), GlobalState.player_rotation, "res://scenes/house/BedroomView.tscn");
