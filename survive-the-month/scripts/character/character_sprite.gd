extends Sprite3D

var direction : int = 0;
var prev_direction : int = 0;

var timer : float = 0.0;
var frame_interval : float = 0.2;
var walk_frame : int = 0;
var walk_frame_increment : int = 1;

var initial_position : Vector3 = Vector3.ZERO;

func on_player_rotate():
	if GlobalState.player_moving:
		return;
	var current_angle : float = wrapf(-GlobalState.player_rotation.y, 0.0, TAU);
	var current_direction : int = roundi(current_angle / (PI / 4)) % 8;
	var delta_dir : int = wrapi(current_direction - prev_direction, -4, 4);
	direction = posmod(direction + delta_dir, 8);
	var frame_dir : int = direction * self.hframes + 1;
	self.flip_h = false;
	if direction >= 5:
		frame_dir = (8 - direction) * self.hframes + 1;
		self.flip_h = true;
	self.frame = frame_dir;
	prev_direction = current_direction;
	
func _ready() -> void:
	GlobalState.player_rotate.connect(on_player_rotate);
	self.frame = 1;
	
	initial_position = self.position;
	
	#initialze current direction
	var current_angle : float = wrapf(-GlobalState.player_rotation.y, 0.0, TAU);
	var current_direction : int = roundi(current_angle / (PI / 4)) % 8;
	var delta_dir : int = wrapi(current_direction - prev_direction, -4, 4);
	direction = posmod(direction + delta_dir, 8);
	prev_direction = current_direction;



func _process(delta: float) -> void:
	if GlobalState.player_moving:
		self.flip_h = false;
		if Input.is_action_pressed("move_forward"):
			direction = 4;
			self.frame = self.hframes * direction + walk_frame;
		elif Input.is_action_pressed("move_backward"):
			direction = 0;
			self.frame = self.hframes * direction + walk_frame;
		elif Input.is_action_pressed("move_left"):
			direction = 6;
			self.frame = self.hframes * 2 + walk_frame;
			self.flip_h = true;
		elif Input.is_action_pressed("move_right"):
			direction = 2;
			self.frame = self.hframes * direction + walk_frame;
		if walk_frame == 1:
			self.position.y = initial_position.y + 0.2;
		else :
			self.position = initial_position;
		
		timer += delta;
		while timer >= frame_interval:
			timer -= frame_interval;
			if walk_frame >= (self.hframes - 1):
				walk_frame_increment = -1;
			elif walk_frame <= 0 :
				walk_frame_increment = 1;
			walk_frame += walk_frame_increment;
	else :
		timer = 0.0;
		self.position = initial_position;
