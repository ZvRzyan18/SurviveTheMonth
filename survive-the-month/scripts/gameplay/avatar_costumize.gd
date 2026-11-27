extends Panel

var max_time : float = 0.3;
var current_time : float = 0.0;
var current_frame : int = 0;

var character_sprite : Sprite2D = null;
var close_costumize : Button = null;

func _ready() -> void:
	character_sprite = self.find_child("character_sprite");
	close_costumize = self.find_child("close_costumize");
	close_costumize.pressed.connect(func():
		self.visible = false;
	);
	character_sprite.frame = 1;

func _process(delta: float) -> void:
	current_time += delta;
	if current_time >= max_time :
		current_time -= max_time;
		current_frame = (current_frame + 1) % 8;
	if current_frame >= 5:
		character_sprite.frame = (8 - current_frame) * 3 + 1;
		character_sprite.flip_h = true;
	else :
		character_sprite.flip_h = false;
		character_sprite.frame = current_frame * 3 + 1;
